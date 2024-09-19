#FROM ubuntu:20.04
#LABEL Juri Bieler: 오리지널 버전에서 libgtk2.0-dev, pkg-config등을 추가
#
# CUDA 및 Ubuntu 버전 설정: 21.8Gb크기의 이미지 생성 성공 (09/20/2024)
#                          14.7Gb크기에 비해 큼 (ubuntu, cuda버전 차이??)
# Docker허브에 매칭되는 이미지가 있어야 한다. 다운받아 여기서부터 시작
ARG CUDA_VERSION=11.8.0
ARG CUDNN_VERSION=8
ARG UBUNTU_VERSION=22.04

FROM nvidia/cuda:${CUDA_VERSION}-cudnn${CUDNN_VERSION}-devel-ubuntu${UBUNTU_VERSION}
LABEL maintainer="Galmegi, 09/20/2024"


RUN apt-get update 
RUN apt-get upgrade -y

# Install gstreamer and opencv dependencies
RUN \
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

RUN \
	apt-get install -y \
	libgstreamer1.0-0 \
	gstreamer1.0-plugins-base \
	gstreamer1.0-plugins-good \
	gstreamer1.0-plugins-bad \
	gstreamer1.0-plugins-ugly \
	gstreamer1.0-libav \
	gstreamer1.0-tools \
	libgstreamer1.0-dev \
	libgstreamer-plugins-base1.0-dev \
	libgtk2.0-dev \
	pkg-config	

# 설치 후 필요없어진 다운 파일을 제거함: 이미지크기 줄임	
RUN	rm -rf /var/lib/apt/lists/* && \
	apt-get purge --auto-remove && \
	apt-get clean

# opencv.git등을 다운받기 위해 git이 필요하여 설치
RUN apt-get update && apt-get install -y git

# just for testing
RUN apt-get -y install nano net-tools netcat

# setup python: pip설치
RUN apt-get install -y python3-pip

# install mavlink dependencies: https://github.com/ArduPilot/pymavlink
RUN apt-get install -y gcc python3-dev libxml2-dev libxslt-dev

RUN pip3 install numpy future lxml pymavlink ray ultralytics

# get opencv and build it: Gstreamer와 결합된 opencv를 새로 컴파일
RUN git clone https://github.com/opencv/opencv.git

RUN apt-get install -y build-essential libssl-dev

RUN apt-get -y install cmake

RUN \
	cd opencv && \
	git checkout 4.5.4 && \
	git submodule update --recursive --init && \
	mkdir build && \
	cd build && \
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D PYTHON_EXECUTABLE=$(which python3) \
	-D BUILD_opencv_python2=OFF \
	-D CMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
	-D PYTHON3_EXECUTABLE=$(which python3) \
	-D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
	-D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") \
	-D WITH_GSTREAMER=ON \
	-D BUILD_EXAMPLES=ON .. && \
	make -j2 && \
	make install && \
	ldconfig && \
	rm -rf /opt/opencv-4.5.4 && rm -rf /opt/opencv_contrib-4.5.4

# ultralytics의 cv2와 중복되니, ultralytics의 default opencv를 제거 
RUN pip3 uninstall opencv-python opencv-python-headless -y
WORKDIR /myapp
	