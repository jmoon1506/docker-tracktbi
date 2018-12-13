FROM nvidia/cuda:8.0-devel-ubuntu16.04
MAINTAINER Joseph Moon
ADD license.txt /license.txt

ARG FREESURFER=ftp://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
ARG BEDPOSTX_GPU=http://users.fmrib.ox.ac.uk/~moisesf/Bedpostx_GPU/CUDA_8.0/bedpostx_gpu.zip

RUN mkdir /share
RUN apt-get -y update
RUN apt-get -y install wget tcsh build-essential python3 python3-dev curl libtool unzip locales
RUN locale-gen en_US.UTF-8

RUN gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv 9BDB3D89CE49EC21
RUN wget -O- http://neuro.debian.net/lists/xenial.us-nh.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
RUN apt-get -y update
RUN apt-get -y install fsl-5.0-complete

RUN BEDPOSTX_GPU_ZIP=$(basename $BEDPOSTX_GPU) && \
wget --no-check-certificate $BEDPOSTX_GPU && \
unzip -o -d /usr/share/fsl/5.0 $BEDPOSTX_GPU_ZIP && \
cp /usr/share/fsl/5.0/bin/*.so /usr/share/fsl/5.0/lib/ && \
rm $BEDPOSTX_GPU_ZIP

RUN FREESURFER_GZ=$(basename $FREESURFER) && \
wget --no-check-certificate $FREESURFER && \
tar -xzf $FREESURFER_GZ -C /opt && \
cp license.txt /opt/freesurfer/license.txt && \
rm $FREESURFER_GZ

RUN rm -rf /license.txt
RUN apt-get -y clean

ENV FSLDIR /usr/share/fsl/5.0
ENV FSL_DIR $FSLDIR
ENV FSLOUTPUTTYPE NIFTI_GZ
ENV FSLMULTIFILEQUIT TRUE
ENV FSLTCLSH ${FSLDIR}/bin/fsltclsh
ENV FSLWISH ${FSLDIR}/bin/fslwish
ENV FSLGECUDAQ "cuda.q"
ENV FSL_BIN ${FSLDIR}/bin
ENV FS_OVERRIDE 0
ENV COMPILE_GPU 1

ENV FREESURFER_HOME /opt/freesurfer
ENV LOCAL_DIR ${FREESURFER_HOME}/local
ENV PERL5LIB ${FREESURFER_HOME}/mni/share/perl5
ENV FSFAST_HOME ${FREESURFER_HOME}/fsfast
ENV FMRI_ANALYSIS_DIR ${FREESURFER_HOME}/fsfast
ENV FSF_OUTPUT_FORMAT "nii.gz"
ENV MNI_DIR ${FREESURFER_HOME}/mni
ENV MNI_DATAPATH ${FREESURFER_HOME}/mni/data
ENV MNI_PERL5LIB ${FREESURFER_HOME}/mni/share/perl5
ENV MINC_BIN_DIR ${FREESURFER_HOME}/mni/bin
ENV MINC_LIB_DIR ${FREESURFER_HOME}/mni/lib
ENV SUBJECTS_DIR /share
ENV FUNCTIONALS_DIR ${FREESURFER_HOME}/sessions

ENV PATH "${FREESURFER_HOME}/bin:${MNI_DIR}/bin:${FSLDIR}/bin:$PATH"
ENV LD_LIBRARY_PATH "${FSLDIR}/lib:$LD_LIBRARY_PATH"
ENV OS LINUX