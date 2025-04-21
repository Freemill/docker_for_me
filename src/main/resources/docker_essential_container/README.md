![img.png](img.png)
![img_1.png](img_1.png) 
![img_2.png](img_2.png)
![img_3.png](img_3.png)
![img_4.png](img_4.png)
![img_5.png](img_5.png)
![img_7.png](img_7.png)<br>
docker run은 create start 명령어를 포함한다. <br>
![img_9.png](img_9.png) <br>
실습해보자. <br>
![img_10.png](img_10.png)
![img_12.png](img_12.png)
```zsh
Pulling from library/ubuntu
```
library라는 계정에 가서 ubuntu라는 image를 다운로드 받고 있다. 기본적으로 왼쪽의 docker hub 사이트에 가서 <br>
다운로드 받는다. <br>
![img_13.png](img_13.png)
<br>
여기서 다운로드 받은것!
<br>
```bash
# mac
# 이 명령어를 사용하면 다운로드한 이미지를 확인할 수 있다.
docker images | grep ubuntu

# window
docker images | findStr ubuntu
```
<br>

```bash
# 실행중인 docker container를 확인하는 명령어
docker container ls

# 위와 똑같은 command로 아래가 있다.
docker ps
```
<br>

![img_14.png](img_14.png)
<br>
분명 위에서 run으로 실행시켰음에도 아무것도 안나온다. 그 이유는 docker는 container로 실행을 시켰을 때 process가 더이상 작동하지 않으면 종료한다.<br>

```bash
# 현재 running 상태의 container뿐만 아니라 중지 되어있는 container들도 보여주는 명령어
docker ps -a
```
<br>

![img_15.png](img_15.png)

<br>
그럼 이번엔 process를 유지하게 하자. <br>

```bash
# -it는 iteractive tty라고 해서 화면에 커맨드를 입력했을 때 해당하는 커맨드가 ubuntu라는 linux container에 전달되는 상태를 만드는 옵션이다.
docker run -it ubuntu:16.04
```

![img_17.png](img_17.png)
<br>
프롬포트가 바뀌었다. 컨테이너 아이디가 보인다. <br>

새로운 커멘더 창을 뛰오고 확인해보자. <br>
![img_18.png](img_18.png)

<br>
다시 원래 프롬포트 창으로 돌아가보자. <br>

```bash
#컨테니어 ID 확인
hostname
```

![img_19.png](img_19.png)

```bash
# 리눅스 시스템의 명령어 파일 조회
ls -al 

# 컨테이너 종료
exit
``` 

![img_20.png](img_20.png)
![img_21.png](img_21.png)

<br>

Database도 기동해보자 <br>
```bash
docker images | grep mariadb
```
<br> -> mariadb이라는 image없는것 확인 <br>

 ![img_23.png](img_23.png)

```bash
# mysql 설치
docker run -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true --name my-mariadb mariadb
```
![img_24.png](img_24.png)
밑에 ubuntu:16.04는 오타

<br>
근데 이렇게 띄우면 container log가 찍히는 상태라서 우리가 어떤 명령어를 입력할 수 없다. 이렇게 되면 다른 database의 명령어를 사용하기 위해서<br>
별도의 창을 또 열어여한다. <br>
일단 mariadb를 종료해보자. 보통 Ctrl+C로 종료가 되는데 database같이 process로 작동되는 middleware같은 경우에는 Ctrl+c로 종료가 안되는 경우가 있다.
<br>

```bash
docker container stop [컨테이너 네임]
```
<br>

그럴땐 이렇게 종료하다.
 
```bash
docker run -d -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true --name my-mariadb mariadb
```
<br>
-d, 즉, detach모드로 실행시켜 보자. 이 말은 지금 실행되고 있는 터미널과 분리해서 실행하라는 말이다. 즉 백그라운드에서 실행시키라는 말!<br>
이 명령어를 실행시키기 전에 docker ps -a에서 my-mariadb가 있는지 확인하고 완전히 삭제시키고 실행을 시키자! 있다면 아래 명령어 실행! <br>

```bash
docker container rm my-mariadb
```
<br>

![img_25.png](img_25.png)
<br>
확인. <br>
이제 container 내부에 접속해서 각종 명령어를 실행시켜보자 <br>

```bash
# bash를 컨테이너 안에 전달한다. bash 쉘이라는 process를 작동
docker container exec -it my-mariadb bash
```

![img_26.png](img_26.png)
<br>
프롬포트가 바뀐것을 확인 가능하다. <br>
이 상태는 컨테이너 내부에 접속해서 들어온 상태이다. 이 컨테이너는 mariadb라는 db이기 때문에 db에 client로 접속을 해보자.<br>

```bash
mariadb -h127.0.0.1 -uroot -p
```
<br>
처음에 db없이 접속 가능하게 설정햏기 때문에 Enter만 누르고 접속이 가능하다.

![img_27.png](img_27.png)

<br>
들어 가서 db에 관련된 명령어를 입력하여 확인하고 과정이 끝나면 exit를 통해 나올 수 있다.

![img_29.png](img_29.png)
![img_30.png](img_30.png)
<br>
detach모드롤 실행한 컨테이너는 아직도 작동중이다. <br>

```bash
docker container stop my-mariadb
```
로 컨테이너로 종료하자. 또 만약에 더이상 사용하지 않는다면 <br>
```bash
 docker container rm [container name]
```
<br>
명령어를 통해 삭제하자.
<br>

![img_31.png](img_31.png)

![img_32.png](img_32.png)
![img_33.png](img_33.png) 
![img_34.png](img_34.png)

![img_35.png](img_35.png)

<br>
그럼 nginx를 먼저 한번 기동해보자. <br>

```bash
docker run nginx
```
![img_37.png](img_37.png)
![img_40.png](img_40.png)
<br>
localhost에는 접속할 수 없다. 이번엔 container의 내부로 접속해 보자. <br>

```bash
docker exec -it [container_id] bash
```

![img_41.png](img_41.png)

![img_42.png](img_42.png)
<br>
내부에 접속햇다. 이 상태에서 curl이라는 command를 사용해보자. <br>
curl은 터미널 상태에서 특정한 호스트에 접속해보고 우리가 필요로하는 api를 테스트해보는 테스트 도구이다. <br>

![img_43.png](img_43.png)
코드가 잘 동작하는것을 볼 수 있다. 위의 터미널에서도 호출된 이력이 잘 보인다. <br>
이 말은 container 내부에서는 nginx라는 서버가 잘 작동되고 있다. 그런데 외부에서는 호출이 안되는 상태이다! 이 말은 <br>
컨테이너 내부와 컨테이너 외부에 해당하는 host pc가 연결돼 있지 않다는 의미이다. <br>

<br>
다시 한번 기동해보자. 일단 다 위에 터미널에서 ctrl+c로 나오고 <br>

![img_44.png](img_44.png)
```bash
# host Pc에서 80으로 접속할 것이고 컨테이너 내부에서 80으로 응답할 것이다.
docker run -p 80:80 nginx
```
![img_46.png](img_46.png)
<br>
컨테이너 외부에서 응답이 된다. <br>
 
![img_47.png](img_47.png)
![img_48.png](img_48.png)

![img_49.png](img_49.png)
<br>
```bash
docker system prune
```
<br>
명령어를 사용하여 stop된 컨테이너와 사용되지 않은 network 그리고 불확실하게 사용된 images를 일괄적으로 삭제시키자.

<br>
-d으로 한번 실행시켜보자.
<br>

![img_51.png](img_51.png)

<br>
스탑 시키고 rm 시켜보자 근데 stop할때 id의 일부만 입력하면 id가 중복되지 않고 유니크할 시 그놈이 삭제된다. <br>

![img_52.png](img_52.png)

![img_53.png](img_53.png)

![img_55.png](img_55.png)

```bash
docker run --rm -d -p 80:80 nginx
```
이렇게 하면 컨테이너가 종료될 때 삭제된다.

![img_56.png](img_56.png)
<br>
파일 목록 확인
<br>

![img_57.png](img_57.png)
![img_58.png](img_58.png)
<br>
exit로 종료

![img_59.png](img_59.png)

```bash
# 13306으로 호출해서 3306(mariadb)로 받겠다.
docker run -d -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=true -p 13306:3306 --name my-mariadb mariadb
```
![img_60.png](img_60.png)
![img_61.png](img_61.png)
![img_62.png](img_62.png)
![img_64.png](img_64.png)
![img_65.png](img_65.png)
![img_66.png](img_66.png)

```bash
cd devops-docker/my-node.js

# -v [host가 갖는 directory] : [container가 갖는 directory] 를 매핑해준다.
docker run -it -v ./:app -p 8000:8000 node:alpine sh
```

![img_67.png](img_67.png)
![img_68.png](img_68.png)
![img_70.png](img_70.png)
![img_71.png](img_71.png)
<br> 
-it라는 옵션 때문에 컨테이너 안으로 바로 접속해 있다. <br>
![img_74.png](img_74.png)
![img_75.png](img_75.png)
<br>
오류 발생! <br>
![img_76.png](img_76.png)
<br>
그 이유는 app.js라는 파일에서 express모듈 사용! <br>
![img_77.png](img_77.png)
![img_79.png](img_79.png)
<br>
근데 이렇게 컨테이너 pc에서 파일을 생성하고 변경하고 사용하는 모든 것들이 볼륨 마운트가 걸려있다면 호슽트 피씨에도 적용이 된다.<br>
확인해 볼까? <br>
![img_80.png](img_80.png)
<br>
컨테이너 내부에서 express라는 모듈을 설치했을 때 node_modules라던가 package-lock.json같은 파일이 생긴다. <br>
근데 그 내용이 <br>
![img_81.png](img_81.png)
<br>
호스트 pc에도 동일하게 적용이 돼있다. 

![img_82.png](img_82.pnㅈg)
![img_84.png](img_84.png)
<br>
정상적으로 실행이 된다. <br>
![img_85.png](img_85.png)
![img_86.png](img_86.png)
<br> 이렇게 나오는 이유는 app.js를 열어보면 된다. 
 