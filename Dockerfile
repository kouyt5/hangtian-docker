FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime
MAINTAINER 1147893200@qq.com

WORKDIR /workspace
COPY requirements.txt ./

# 镜像源
RUN pip config set global.index-url https://pypi.douban.com/simple/
# 必要python包安装
RUN pip install -r requirements.txt \
    && rm requirements.txt

RUN pip install nemo-toolkit[all]==0.10.0
#语言模型安装
# RUN git clone https://github.com/NVIDIA/NeMo.git --branch v0.10.0 \ # github is slowly...
RUN git clone https://hub.fastgit.org/NVIDIA/NeMo.git --branch v0.11.1\
    && cd NeMo/scripts \
    && apt-get update && apt-get install swig -y \
    && apt-get install pkg-config libflac-dev libogg-dev libvorbis-dev libboost-dev -y\
    && apt-get install libsndfile1-dev python-setuptools libboost-all-dev python-dev -y\
    && apt-get install cmake -y\
    && bash ./install_decoders.sh \
    && cd ../../ && rm -r NeMo/

RUN pip install https://github.com/kpu/kenlm/archive/master.zip
EXPOSE 22

# 后台执行ssh服务
ENTRYPOINT /etc/init.d/ssh start && /bin/bash

