# Recommended Docker command:
# docker run --rm -it -p 8888:8888 nimaid/mri2stl

FROM ubuntu:bionic

# Install required software.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unzip \
        tcsh \
        dcm2niix \
        meshlab \
        python2.7 \
        wget \
        file \
        libpng-dev \
        libmng-dev \
        libgomp1 \
        libquadmath0 \
        bc \
        libsys-hostname-long-perl \
        bzip2 \
        python-pip \
        python-setuptools && \
    python2.7 -m pip --no-cache-dir install --upgrade \
        jupyter && \

    # FreeSurfer installation.
    wget -P /tmp/ https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    tar -C /usr/local -xzvf /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    export FREESURFER_HOME=/usr/local/freesurfer && \
    $FREESURFER_HOME/SetUpFreeSurfer.sh && \
    rm -f /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \

    # FSL installation
    wget -P /tmp/ https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
    export PYTHONHTTPSVERIFY=0 && \
    python2.7 /tmp/fslinstaller.py -D -E -d /usr/local/fsl && \
    rm -f /tmp/fslinstaller.py && \
    
    # Cleanup.
    apt-get purge -y \
        wget \
        file \
        bzip2 \
        python-pip \
        python-setuptools && \
    apt-get autoremove -y
COPY ./files/license.txt /usr/local/freesurfer/

# Copy files.
COPY ./3dprintyourbrain/script/3Dprinting_brain.sh /3dprintscript/
COPY ./files/mri2stl.sh /3dprintscript/
COPY ./files/dicom2nii.sh /3dprintscript/
COPY ./files/zip2stl.sh /3dprintscript/
COPY ./3dprintyourbrain/script/smoothing.mlx /3dprintscript/scans/
COPY ./files/test_scan.nii /3dprintscript/scans/test_scan/input/struct.nii

# Prepare Jupyter Notebook server.
WORKDIR /3dprintscript
EXPOSE 8888
CMD jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root && exit