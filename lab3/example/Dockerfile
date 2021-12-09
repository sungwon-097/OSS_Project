# 베이스 이미지 설정
FROM ubuntu:20.04

# && 앞에 있는 명령어가 실행 됐을 때 뒤의 명령어를 실행(apt update 후 python3 설치)
RUN apt update && apt install -y python3

# 디렉토리를 만들고 이동
WORKDIR /home/example

# doc.html에 저장
RUN echo "<strong>Open Source</strong> Lecture" > doc.html

# lab3라는 이름을 갖는 우분투 20.04이미지를 설치
# docker run --name lab3 -it ubuntu:20.04 

# commit을 통해 현재 상태를 저장하는 이미지 생성
# docker commit lab3 lab3-commit

# 이미지 확인
# docker images

# 컨테이너 목록 확인
# docker ps


