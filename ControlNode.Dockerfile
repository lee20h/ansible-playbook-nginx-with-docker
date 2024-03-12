FROM ubuntu:latest

# 필수 패키지 설치 및 시간대 설정을 위한 환경 변수
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    openssh-client \
    ca-certificates \
    curl

# Add Docker's official GPG key:
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null


RUN apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

# Python 설치 및 필요한 라이브러리 설치
RUN apt-get update && apt-get install -y python3-pip \
    && pip3 install ansible docker

# SSH 키 생성 (Ansible 연결용)
RUN ssh-keygen -q -t rsa -N '' -f /root/.ssh/id_rsa

# 작업 디렉토리 설정
WORKDIR /ansible

# 기본 명령어 설정
CMD ["ansible-playbook", "-i", "hosts", "playbook.yaml", "-vvv"]
