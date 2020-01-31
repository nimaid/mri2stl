# Recommended Docker command:
# docker run --rm -it -p 8888:8888 nimaid/mri2stl

FROM ubuntu:bionic

# Install required software.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xvfb \
        unzip \
        tcsh \
        dcm2niix \
        meshlab \
        python2.7 \
        libpng-dev \
        libmng-dev \
        libgomp1 \
        libquadmath0 \
        bc \
        libsys-hostname-long-perl \
        wget \
        file \
        bzip2 \
        python-pip \
        python-setuptools && \
    python2.7 -m pip --no-cache-dir install --upgrade \
        jupyter && \

    # FreeSurfer installation.
    wget --no-check-certificate -P /tmp/ https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/6.0.0/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    tar -C /usr/local -xzvf /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \
    export FREESURFER_HOME=/usr/local/freesurfer && \
    $FREESURFER_HOME/SetUpFreeSurfer.sh && \
    rm -f /tmp/freesurfer-Linux-centos6_x86_64-stable-pub-v6.0.0.tar.gz && \

    # FSL installation
    wget --no-check-certificate -P /tmp/ https://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && \
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
    ldconfig && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*
COPY ./files/freesurfer_license.txt /usr/local/freesurfer/license.txt

# Copy files.
COPY ./files/smoothing.mlx /3dprintscript/scans/
COPY ./files/test_scan.zip /3dprintscript/

COPY ./files/*.bash /usr/bin/
RUN cd /usr/bin/ && \
    chmod +x ./*.bash && \
    find -type f -name '*.bash' -print0 | while read -d $'\0' f; do mv "$f" "${f%.bash}"; done

# Prepare Jupyter Notebook server.
WORKDIR /3dprintscript
EXPOSE 8888
CMD export SHELL=/bin/bash && jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root && exit