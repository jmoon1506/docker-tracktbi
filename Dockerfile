FROM ubuntu:16.04
MAINTAINER Joseph Moon
ADD license.txt /license.txt

ARG GET_PIP=https://bootstrap.pypa.io/get-pip.py
ARG TESLA=http://us.download.nvidia.com/tesla/396.44/NVIDIA-Linux-x86_64-396.44.run
ARG CUDA5=http://developer.download.nvidia.com/compute/cuda/5_0/rel-update-1/installers/cuda_5.0.35_linux_64_ubuntu11.10-1.run
ARG CUDA8=https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
ARG FREESURFER=ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
ARG BEDPOSTX_GPU=http://users.fmrib.ox.ac.uk/~moisesf/Bedpostx_GPU/CUDA_8.0/bedpostx_gpu.zip

RUN mkdir /share
RUN apt-get -y update
RUN apt-get install -y apt-transport-https
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y universe
RUN apt-get -y update
RUN apt-get -y install wget tcsh build-essential python3 python3-dev curl libtool unzip kmod initramfs-tools locales vim-tiny dkms
RUN locale-gen en_US.UTF-8