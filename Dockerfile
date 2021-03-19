FROM python:3.8

# install command.
RUN apt-get update && apt-get -qq -y install curl && apt-get install -y less vim wget unzip tree

# install aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \ 
    ./aws/install
    
# install sam
RUN pip install --user --upgrade aws-sam-cli
ENV PATH $PATH:/root/.local/bin

# install terraform.
RUN wget https://releases.hashicorp.com/terraform/0.14.8/terraform_0.14.8_linux_amd64.zip && \
    unzip ./terraform_0.14.8_linux_amd64.zip -d /usr/local/bin/
    
# tfenv install
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv
ENV PATH $PATH:~/.tfenv/bin

# create workspace.
COPY ./src /root/src

# initialize command.
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
COPY .aws /root/.aws
COPY init.sh /root/init.sh
RUN chmod +x /root/init.sh && /root/init.sh

WORKDIR /root/src