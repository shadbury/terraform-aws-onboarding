#!/bin/bash -v
set -euo pipefail

curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash

yum update -y
amazon-linux-extras enable docker
yum install -y gitlab-runner docker-19.03.13ce-1.amzn2  gcc openssl-dev python3 jq
curl -L https://github.com/docker/compose/releases/download/1.28.5/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Create gitlab-runner user so we can have a fixed UID/GID. Prevents file permission issues on restarts.
groupmod -g 100000 gitlab-runner
usermod -u 100000 -g gitlab-runner -s /bin/false -c "Gitlab-runner" gitlab-runner

# Ensure all files created by root inside docker belong to gitlab-runner rather than root. This helps with file permission issue e.g. stashing files.
echo 'gitlab-runner:100000:1' >> /etc/subuid
echo 'gitlab-runner:1000000:65536' >> /etc/subuid
echo 'gitlab-runner:100000:1' >> /etc/subgid
echo 'gitlab-runner:1000000:65536' >> /etc/subgid

cat <<EOF >> /etc/docker/daemon.json
{
    "userns-remap": "gitlab-runner"
}
EOF

usermod -aG docker gitlab-runner

systemctl restart docker

# Install clair-scanner, has issues running in a docker container
curl -Lo /usr/local/bin/clair-scanner https://github.com/arminc/clair-scanner/releases/download/v12/clair-scanner_linux_amd64
chmod +x /usr/local/bin/clair-scanner

CONFIG_FILE=`aws ssm get-parameters --region ap-southeast-2 --name /gitlab/config.toml --with-decryption --query "Parameters[*].{Value:Value}" --output text`
if [ -z $CONFIG_FILE ]
then 

    # Get Token
    GITLAB_TOKEN=`aws ssm get-parameters --region ${aws_region} --name /gitlab/gitlab-runner-token --with-decryption --query "Parameters[*].{Value:Value}" --output text`

    # Register Runner
    INSTANCE_ID=`curl http://169.254.169.254/latest/meta-data/instance-id`

    #modifying hop limit due to know aws provider issue https://github.com/terraform-providers/terraform-provider-aws/issues/10949
    aws ec2 modify-instance-metadata-options --instance-id $INSTANCE_ID --http-put-response-hop-limit 3 --region ${aws_region} --http-endpoint enabled

    gitlab-runner register \
        --non-interactive \
        --name "${var.profile}-linux-runner" \
        --url "${gitlab_url}" \
        --registration-token "$GITLAB_TOKEN" \
        --tag-list "${var.client},linux,local-runner,mgmt" \
        --executor "shell" \
        --shell "bash"
    
    aws ssm put-parameter --region ${aws_region} --name /gitlab/config.toml --value file:///etc/gitlab-runner/config.toml --type SecureString
else
    aws ssm get-parameters --region ap-southeast-2 --name /gitlab/config.toml --with-decryption --query "Parameters[*].{Value:Value}" --output text > /etc/gitlab-runner/config.toml
    
fi

sed -i 's/^concurrent =.*/concurrent = ${concurrency}/g' /etc/gitlab-runner/config.toml

# Git credential helper script
cat <<EOF >> /usr/local/bin/git-credential-helper.sh
#!/bin/bash
echo username=\$GIT_USERNAME
echo password=\$GIT_PASSWORD
EOF
chmod +x /usr/local/bin/git-credential-helper.sh

gitlab-runner restart

yum makecache

yum -y install postgresql12
