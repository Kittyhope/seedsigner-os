FROM debian:11

# buildroot dependencies
RUN apt-get -qq update
RUN apt-get -y install \
locales \
lsb-release \
git \
wget \
make \
binutils \
gcc \
g++ \
patch \
gzip \
bzip2 \
perl \
tar \
cpio \
unzip \
rsync \
file \
bc \
libssl-dev \
vim \
build-essential \
libncurses-dev \
mtools \
fdisk \
dosfstools \
python-is-python3

RUN apt-get -y install python3-pip
RUN pip3 install tomli  

# Locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

WORKDIR /opt
ENTRYPOINT ["./build.sh"]
