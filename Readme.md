# Docker와 Ansible을 이용한 자동화 환경 구성

Docker 컨테이너 내에서 Ansible을 사용하여 다른 Docker 컨테이너를 관리하는 환경을 구성하는 방법을 보여줍니다. 이 구성을 통해, 개발자는 Docker 컨테이너화된 애플리케이션의 배포 및 관리를 자동화할 수 있습니다.  
여기에서는 nginx를 설치하고 실행시키는 방식으로 구현하였습니다.

## 구성 요소
- Control Node: Ansible 플레이북을 실행하는 주체. Docker 컨테이너로 구성되며, 호스트 시스템의 Docker 데몬과 통신할 수 있도록 설정됩니다.
- Worker Nodes: 관리 대상인 Docker 컨테이너. 여기서는 worker_node_1과 worker_node_2로 예시됩니다.
 
## 전제 조건
- Docker가 설치된 Linux 호스트 시스템
- Ansible 2.9 이상

예제 파일은 ubuntu 기반으로 작성하였습니다.

## 설치 및 실행 방법
### 1. Docker와 Ansible 설치
Control Node 컨테이너에 Docker와 Ansible을 설치합니다. 대부분의 Linux 배포판에서는 패키지 매니저를 통해 쉽게 설치할 수 있습니다.  
Worker Node 컨테이너에서는 SSH를 통한 접근을 허용하기 위해 `openssh-server` 설치하여 준비합니다.

### 2. 프로젝트 디렉토리 구성
프로젝트의 루트 디렉토리에서 다음과 같은 파일 구조를 준비합니다:

```
.
├── ansible
│   ├── ansible.cfg
│   ├── hosts
│   └── playbook.yaml
├── ControlNode.Dockerfile
├── WorkerNode.Dockerfile
└── docker-compose.yml
```

### 3. Docker Compose 파일 작성
`docker-compose.yml`파일을 작성하여 컨트롤 노드와 워커 노드를 정의합니다. Docker 소켓을 컨트롤 노드에 마운트하여 호스트의 Docker 데몬과 통신할 수 있게 합니다.

### 4. Ansible 인벤토리 파일 구성
Ansible의 인벤토리 파일(hosts)에 워커 노드의 정보를 정의합니다. Docker 연결 플러그인을 사용하여 컨테이너에 접근하도록 설정합니다.

### 5. Ansible 플레이북 실행
Control Node 컨테이너 내에서 Ansible 플레이북을 실행하여 Worker Nodes에 대한 자동화 작업을 수행합니다.

### 6. 테스트

```shell
$ docker compose up -d
```

Worker Node 컨테이너에 nginx가 설치되고 실행되었는 지 확인합니다.

- http://localhost:8081
- http://localhost:8082

![image](https://github.com/lee20h/ansible-playbook-nginx-with-docker/assets/59367782/39b0e353-67d5-4e93-a7ee-b5b6770e1ae2)


## 주의 사항
- 컨테이너의 이름 또는 ID를 정확히 지정해야 합니다. `docker ps` 명령을 사용하여 실행 중인 컨테이너의 이름을 확인할 수 있습니다.
- SELinux 또는 AppArmor와 같은 보안 정책이 활성화되어 있을 경우, 이에 따른 추가 설정이 필요할 수 있습니다.

## 문제 해결
- Ansible이 원격 노드에 임시 디렉토리를 생성할 수 없는 경우, /tmp 디렉토리의 권한을 점검하고, 필요한 경우 Ansible 구성을 조정하세요.
