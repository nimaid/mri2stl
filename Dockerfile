FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install -y --no-install-recommends tcsh dcm2niix meshlab python2.7 wget file libpng-dev libmng-dev bzip2 python-pip python-setuptools
RUN python2.7 -m pip --no-cache-dir install --upgrade jupyter

COPY ./downloads /dl_files
WORKDIR /dl_files

RUN tar -C /usr/local -xzvf freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz
RUN export FREESURFER_HOME=/usr/local/freesurfer; $FREESURFER_HOME/SetUpFreeSurfer.sh; mv license.txt $FREESURFER_HOME

RUN mv fslinstaller.py /tmp/
RUN export PYTHONHTTPSVERIFY=0; python2.7 /tmp/fslinstaller.py -D -E -d /usr/local/fsl

WORKDIR /
RUN rm -rf dl_files/

COPY ./3dprintyourbrain/script /3dprintscript
COPY ./test_scan.nii /3dprintscript
WORKDIR /3dprintscript

EXPOSE 8888
CMD jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root && exit