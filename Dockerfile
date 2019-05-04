FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y --no-install-recommends dcm2niix meshlab

COPY ./downloads /dl_files
WORKDIR /dl_files
RUN tar -C /usr/local -xzvf freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
RUN python2 fslinstaller.py -q
WORKDIR /
RUN rm -rf dl_files/

COPY ./3dprintyourbrain/script /3dprintscript
WORKDIR /3dprintscript

#CMD jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root && exit