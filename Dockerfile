# FROM nvcr.io/nvidia/nemo:v0.10
FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime
MAINTAINER 1147893200@qq.com

WORKDIR /workspace
# 注意这里的id_rsa.pub文件必须是你.ssh/ 文件夹下的公钥文件
COPY requirements.txt ./

# 镜像源
RUN pip config set global.index-url https://pypi.douban.com/simple/
# ssh 以及必要python包安装
RUN apt-get update --fix-missing && apt-get install openssh-server -y \
    && pip install -r requirements.txt \
    && rm requirements.txt

RUN pip install nemo-toolkit[all]==0.10.0
#RUN git clone https://github.com/NVIDIA/apex \
#    && cd apex && pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./ \
#    && rm -r apex
#语言模型安装
# RUN git clone https://github.com/NVIDIA/NeMo.git --branch v0.10.0 \
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

