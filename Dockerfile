FROM ubuntu:bionic

COPY ./files /tmp
COPY ./3dprintyourbrain/script /3dprintscript

RUN APT_INSTALL="apt-get install -y --no-install-recommends" && \
    PIP_INSTALL="python2.7 -m pip --no-cache-dir install --upgrade" && \
    GIT_CLONE="git clone --depth 10" && \

    apt-get update && \
    $APT_INSTALL tcsh dcm2niix meshlab python2.7 wget file libpng-dev libmng-dev bzip2 python-pip python-setuptools && \
    $PIP_INSTALL jupyter && \
    
    wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz /tmp/ && \
    tar -C /usr/local -xzvf /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    export FREESURFER_HOME=/usr/local/freesurfer && \
    $FREESURFER_HOME/SetUpFreeSurfer.sh && \
    mv /tmp/license.txt $FREESURFER_HOME && \
    rm -f /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    
    wget https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py /tmp/ && \
    export PYTHONHTTPSVERIFY=0 && \
    python2.7 /tmp/fslinstaller.py -D -E -d /usr/local/fsl && \
    rm -f /tmp/fslinstaller.py && \
    
    mv /3dprintscript/smoothing.mlx /3dprintscript/scans/ && \
    mv /tmp/test_scan.nii /3dprintscript/scans/test_scan/input/struct.nii

EXPOSE 8888
CMD jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root && exit