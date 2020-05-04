# work from latest LTS ubuntu release
FROM ubuntu:18.04

# run update and install necessary tools
RUN apt-get update -y && apt-get install -y \
    build-essential \
    libnss-sss \
    curl \
    vim \
    less \
    wget \
    unzip \
    cmake \
    python \
    gawk \
    python-pip \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss-sss \
    libbz2-dev \
    liblzma-dev \
    bzip2 \
    libcurl4-openssl-dev \
    libssl-dev \
    git \
    autoconf \
    rna-star \
    samtools \
    bsdmainutils

# install numpy and pysam
WORKDIR /usr/local/bin
RUN pip install numpy
RUN pip install cython
RUN pip install pysam

# get lumpy script
ADD https://api.github.com/repos/Vron1/davelab_ebv_detection/git/refs/heads/ version.json
RUN git clone https://github.com/Vron1/davelab_ebv_detection.git
RUN cp davelab_ebv_detection/ebv_detection.sh .
RUN cp davelab_ebv_detection/masked_ebv_genome_idx_STAR .