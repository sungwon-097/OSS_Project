# Nvidia PyTorch를 베이스 이미지로 지정
FROM nvcr.io/nvidia/pytorch:21.10-py3

# && 앞에 있는 명령어가 실행 됐을 때 뒤의 명령어를 실행(apt update 후 opencv 설치 에러를 해결하기 위해 libgl1-mesa-glx 설치)
RUN apt update && apt install -y zip htop screen libgl1-mesa-glx

# requirements.txt . 의 소스를 복사(설치해야 할 패키지의 목록)
COPY requirements.txt .

# pip update 후 필요한 패키지 추가 설치
RUN python -m pip install --upgrade pip
RUN pip uninstall -y nvidia-tensorboard nvidia-tensorboard-plugin-dlprof
RUN pip install --no-cache -r requirements.txt coremltools onnx gsutil notebook wandb>=0.12.2
RUN pip install --no-cache -U torch torchvision numpy Pillow
# RUN pip install --no-cache torch==1.10.0+cu113 torchvision==0.11.1+cu113 -f 

# working directory 생성
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# /usr/src/app 디렉토리를 이미지로 복사
COPY . /usr/src/app

# Downloads to user config dir
ADD https://ultralytics.com/assets/Arial.ttf /root/.config/Ultralytics/

# # pip install -r requirements.txt

#   Base ----------------------------------------
# matplotlib>=3.2.2
# numpy>=1.18.5
# opencv-python>=4.1.2
# Pillow>=7.1.2
# PyYAML>=5.3.1
# requests>=2.23.0
# scipy>=1.4.1
# torch>=1.7.0
# torchvision>=0.8.1
# tqdm>=4.41.0
#   Logging -------------------------------------
# tensorboard>=2.4.1
#   wandb
# Plotting ------------------------------------
# pandas>=1.1.4
# seaborn>=0.11.0

# thop  # FLOPs computation