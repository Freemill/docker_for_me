![img.png](img.png)
![img_1.png](img_1.png)
![img_3.png](img_3.png)

일단 section2로 체크아웃 한다.
<br>
![img_4.png](img_4.png)
![img_6.png](img_6.png)
어떤 base image를 쓸지 결정하기 전에 docker hub 사이트를 확인해 보자. <br>
![img_7.png](img_7.png)
<br>
이렇게만 하고 바로 build를 해보자.
![img_8.png](img_8.png)

```shell
# 현재 directory에 있는 Dockerfile을 사용할것이기 때문에 -f Dockerfile은 필요가 없으나 그래도 명시적으로 명시했다. 마지막의 .은 현재 위치를 표시
Docker build --tag first-image:0.1 -f Dockerfile .
```
![img_9.png](img_9.png)
```shell
#window
docker images | findStr ubuntu
```
![img_10.png](img_10.png)

```shell
docker run first-image:0.1
```
<br>
이렇게만 실행시키면 실행 됐다가 바로 종료 됨.
<br>

![img_11.png](img_11.png)
```shell
docker run -it first-image:0.1 bash
```
접속하려면 위 처럼 실행시키면 된다. 그럼 아래처럼 프롬포트가 바뀌고 컨테이너에 접속한것을 확인 가능하다. <br>

![img_12.png](img_12.png)
컨테이너의 러닝 상태를 확인 가능하다.
![img_13.png](img_13.png)

![img_14.png](img_14.png)

![img_15.png](img_15.png)
![img_16.png](img_16.png)

실습을 하기 전에 용량을 확인해 보자. 
![img_17.png](img_17.png)
119mb이다. 용량이 크다. 그래서 alpine-linux를 쓰자 <br>
alpine-linux는 경량화된 linux이다. <br>
![img_18.png](img_18.png)
docker hub에도 alpine 이미지가 있다.! <br>

![img_19.png](img_19.png)
RUN이라는 커멘드는 도커 이미지 내부에서 실행되고자 하는 어떤 실행절차이자 단계이다. <br>
설치가 다 끝났으면 CMD를 통해서 node를 실행시켜 주어야 한다. <br>
근데 왜 serve냐? 그 이유는 package.json 파일에 <br>
![img_21.png](img_21.png) <br>
script에 적혀있는 serve 명령어를 node 다음에 적어주면 우리가 필요한 파일을 실행시켜주는것! <br>
결국은 node.app.js를 실행시킨다는 의미이다. <br>
```dockerfile
#지금은 아래 처럼 작성 돼 있지만
CMD ["npm", "serve"]
#아래 처럼 작석해도 된다.
CMD ["node", "app.js"]
```
![img_22.png](img_22.png)
![img_24.png](img_24.png)
```dockerfile
RUN npm install
```
<br>
이 부분에서 오류가 발생! npm이라는 명령어가 없기 때문에 오류가 발생. npm이라는 명령어는 nodejs를 설치해야만 가능한 명령어 그런데 alpine에는 노드가 설치 <br
안되어있음. 따라서 이것을 설치 해야한다. <br>
그래서 <br>

```dockerfile
# 이 작업을 먼저 해주어야 한다. 
RUN "node js 설치"
# 이것을 하기 전에
RUN npm install

```
<br>
그런데 이 작업은 귀찮다. 그래서 node가 깔려있는 alpine을 가져오자! <br>

![img_26.png](img_26.png) 
node도 역시 alpine 버전이 있다! <br>
![img_27.png](img_27.png)
```dockerfile
FROM node:alpine    
```
수정!
![img_28.png](img_28.png)
![img_29.png](img_29.png)
아까와 다른 오류가 발생! 이 오류는 무엇이냐 npm install 이라는 작업을 하기 위해서 package.json 파일 즉, node js의 폴더 구조에서 npm install이 <br>
실행되어야 하는데 지금 그 구조가 아니라는 말이다. <br>
그럼 우리가 nodejs 구조로 만들어주거나 아니면 우리의 package.json파일을 image 안으로 넣으면 된다. 

![img_30.png](img_30.png)
![img_31.png](img_31.png)
![img_32.png](img_32.png)
![img_33.png](img_33.png)
그럼 이제 이것을 실행시켜 보자. 
```shell
docker run nodejs-demo1:latest
```
![img_34.png](img_34.png)
Example app for CI/CD listening on port 8000이 출력되는 모습이 보인다. 저 메시지는 <br>
![img_35.png](img_35.png)
이곳에 설정돼 있다.
또 다른 터미널 창에서 확인해보면 container가 떠 있는게 보인다. <br>
![img_38.png](img_38.png)
이번엔 exec를 통해 컨테이너 내부에서 명령어를 실행시켜 보려고 했는데 에러가 난다. <br>
![img_39.png](img_39.png)
그 이유는 node:alpine에는 bash가 없다!
그럼 기본적인 shell인 sh로 실행하자. <br>
![img_40.png](img_40.png)
내부의 파일들을 확인해보자. <br>
![img_41.png](img_41.png)
node_modules라는 파일은 아까 말했듯이 npm install을 하면 생기는 파일이다. 근데 root에 이렇게 파일이 있는것은 옳치않다. 위치를 바꿔보자. <br>
![img_42.png](img_42.png)
docker stop으로 종료 이렇게 된 이유는 
```dockerfile
COPY ./my-nodejs/package.json ./package.json
COPY ./my-nodejs/app.js ./app.js
```
이렇게 root에 복사하게 했기 때문이다. 근데 이렇게 root에 하는것은 보안상이유로 좋지 않다.
![img_43.png](img_43.png)
그래서 우리는 WORKDIR를 지정해 주고 거기에 작업을 하겠다.로 바꿔준다. 
![img_44.png](img_44.png)
이미지를 확인해 보자. <br>
![img_45.png](img_45.png)

이번엔 port를 열어보자. <br>
```shell
docker run -p 8000:8000 --name my-node nodejs-demo1:v2.0
```
컨테이너 안에서는 8000으로 실행이 될테니 host pc에서 접속할 수 있게 8000으로 명시해주자. <br>
![img_46.png](img_46.png)
이제 확인해보면 PORTS에 우리가 명시한게 보인다. <br>
![img_47.png](img_47.png)
![img_48.png](img_48.png)
![img_49.png](img_49.png)

![img_50.png](img_50.png)
![img_51.png](img_51.png)
![img_52.png](img_52.png)
![img_53.png](img_53.png)
![img_54.png](img_54.png)

<br>
docker hub사이즈에서 registry라고 검색하면 된다. <br>

![img_55.png](img_55.png)
![img_57.png](img_57.png)
저기 보면 5000을 기본으로 사용한다. 근데 가끔 mac os는 5000을 사용중이라고 종종 뜬다.
![img_58.png](img_58.png)
확인하고 만약 저게 쓰고있는 포트가 있을시 airplay를 꺼준다. <br>
![img_59.png](img_59.png)
![img_60.png](img_60.png)
확인해보자 <br>
![img_61.png](img_61.png)
![img_62.png](img_62.png)
![img_65.png](img_65.png)
확인 끝 <br>
이제 nodejs로 되어있는 image들을 좀 확인하자 <br>
![img_66.png](img_66.png)
이 이미지를 local registry에 등록할 수 있는 형태로 변경한다음 사용해보자. <br>
![img_67.png](img_67.png)
실행하고 이미지를 다시 조회해보자 <br>
![img_68.png](img_68.png)
이미지 id가 동일하고 이름만 다른 이미지가 하나 더 생겼다 <br> 
이렇게 image id가 다르다는 의미는 아무것도 없는 image들은 docker.io/가 앞에 생략돼 있다는 의미이다. <br>
근데 이제 새로 생긴 image는 local registry로써 앞에 붙어있다. 만약 harbour라던가 aws를 쓴다면 거기에 맞게 태그명을 변경하면 된다.
<br>
이제 image를 push해 볼 것이다. 근데 nodejs-demo1를 push하면 docker hub의 내 계정으로 가는데 localhost:5000/nodejs-demo1을 push하면 <br>
로컬의 registry로 간다. <br>
![img_69.png](img_69.png)
![img_70.png](img_70.png)
이제 인터넷 창에서 확인해보면 들어와 있는것을 확인 가능하다. <br>
![img_71.png](img_71.png)
curl로 확인
![img_72.png](img_72.png)
![img_73.png](img_73.png)
![img_74.png](img_74.png)

![img_75.png](img_75.png)
![img_76.png](img_76.png)
docker hub에 로그인 해서 registry를 확인해보면, 내가 올린 image들을 확인할 수 있다. <br>
![img_78.png](img_78.png)
<br>
사용하는 방법은 간단하다. 일단, Create Repository를 클릭한다. 그리고 거기에 내가 저장할 repository 이름을 적어준다. <br>
![img_79.png](img_79.png)
그런데 repository를 만들고 push를 해야하냐? 그건 아니다. 내가 그냥 push를 하면 지정한 이름으로 repository를 생성한다. 그런데 순서는 원래 repository<br>
를 생성하고 만드는것이니 그렇게 만들도록 하자. <br>

![img_80.png](img_80.png)
```bash
docker push nodejs-demo1:v2.0
```
<br>
아무것도 입력하지 않은 상태에서 docker push를 하면 docker.io사이트로 즉, docker hub로 가게 된다. <br>

![img_81.png](img_81.png)
<br>
확인해보니 access denied라고 뜬다. <br>
![img_82.png](img_82.png)
이미지를 확인해보니 
```bash
[dockerio./library/nodejs-demo1]
```
이렇게 뜬다. library로 되어있다. 즉, 이것은 docker-hub에 마음대로 올릴 수 없다는 것이다. 나는 나의 계정에 올려야 한다. 나의 계정으로 올리자 <br>
```bash
docker tag nodejs-demo1:v2.0 [dockerid]/nodejs-demo1:v2.0
```
이렇게 해야한다. 먼저 계정명을 바꿔준것!
![img_83.png](img_83.png)
```bash
 docker tag nodejs-demo:v2.0 mongddangand/nodejs-demo1:v2.0 
```
나의 경우 이렇게 바꾸었다. <br>
![img_84.png](img_84.png)
이미지가 잘 만들어져있다. 이제 이것을 push해보자. <br>
![img_85.png](img_85.png)
만약 이 작업을 하기 전에 docker에 login하라는 표시가 뜬다면 아래 명령어를 실행한다. <br>
```bash
docker login
```
![img_86.png](img_86.png)
이미지가 업로드된 것을 확인할 수 있다. <br>
다른것도 올려보자. <br>
![img_88.png](img_88.png)
![img_90.png](img_90.png)

image 목록들을 모두 삭제해보자. <br>
```bash
docker rmi [imageID]
```
![img_91.png](img_91.png)
그런데 에러가 발생했다. 왜 그럴까? 사용하는 이미지의 ID들을 보니까 중복되는 것들이 있다. <br>
그럴 때는 강제로 삭제하는 방법이 있다. 하지만 그것보단 그럴 땐 이미지가 갖는 전체 이름과 태그명을 정확히 명시하면 삭제할 수 있다. 
![img_92.png](img_92.png)
그리고 강제로 삭제하는 방법도 있다. <br>
```bash
docker rmi -f [imageID]
```
이렇게 하면 두개가 한번에 삭제된다. 
이제 다시 다운받아보자.
![img_94.png](img_94.png)
