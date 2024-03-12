FROM ubuntu:latest

# 필요한 패키지 설치 및 SSH 서버 설정
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH 포트
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
