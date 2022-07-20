FROM codercom/code-server:4.5.1

# Inform listen on 8080
EXPOSE 8080

# Install standard packages
USER root

# Install Docker
RUN apt-get update \
  && apt-get install -y ca-certificates curl gnupg lsb-release

RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

ARG DOCKER_GROUPID=999
RUN groupadd -g $DOCKER_GROUPID docker
RUN usermod -aG docker coder

RUN apt-get update \
  && apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin unzip

# Install Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs

# Install Python
RUN apt-get install -y python3 python3-pip python-is-python3

# Install AWS CLI
RUN curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
  && unzip awscliv2.zip \
  && ./aws/install \
  && rm -rf awscliv2.zip ./aws

# Install SAM CLI
RUN curl -L "https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip" -o "aws-sam-cli-linux-x86_64.zip" \
  && unzip aws-sam-cli-linux-x86_64.zip -d sam-installation \
  && ./sam-installation/install \
  && rm -rf aws-sam-cli-linux-x86_64.zip ./sam-installation

# Install Kubectl
RUN curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.22.6/2022-03-09/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin/kubectl

# Install EKSCTL
RUN curl -L "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp \
  && mv /tmp/eksctl /usr/local/bin/eksctl

USER coder

# Install standard extensions
RUN curl -o github.copilot.vsix -L https://github.gallery.vsassets.io/_apis/public/gallery/publisher/github/extension/copilot/1.33.6266/assetbyname/Microsoft.VisualStudio.Services.VSIXPackage \
  && code-server --install-extension github.copilot.vsix

#RUN code-server --install-extension github.copilot

RUN code-server --install-extension donjayamanne.githistory

# Install cool extensions.
RUN code-server --install-extension esbenp.prettier-vscode
RUN code-server --install-extension dbaeumer.vscode-eslint

RUN code-server --install-extension mongodb.mongodb-vscode
RUN code-server --install-extension GraphQL.vscode-graphql
RUN code-server --install-extension formulahendry.vscode-mysql

RUN code-server --install-extension felixfbecker.php-debug \
	&& code-server --install-extension felixfbecker.php-intellisense \

RUN code-server --install-extension Vue.volar
  
# Install AWS toolkit
RUN code-server --install-extension AmazonWebServices.aws-toolkit-vscode

# Setup entrypoint file and apply execution rights
COPY ./entrypoint.sh /bootstrap/entrypoint.sh
COPY ./vscode/settings.json /home/coder/.local/share/code-server/User/settings.json

# Run IDE without updates and telemetry
ENTRYPOINT ["/bootstrap/entrypoint.sh"]
