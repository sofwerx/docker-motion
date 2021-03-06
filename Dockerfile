FROM ubuntu:16.04

RUN apt-get update 
RUN apt-get build-dep -y motion

# Install the basic dependencies
RUN apt-get install -y autoconf automake pkgconf libtool libjpeg8-dev build-essential libzip-dev

# Install ffmpeg dependencies
RUN apt-get install -y libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev ffmpeg libwebp-dev

# Install our dependencies
RUN apt-get install -y git curl libmicrohttpd-dev
RUN git clone https://github.com/Motion-Project/motion /motion
WORKDIR /motion

RUN autoreconf -fiv
RUN ./configure
RUN make
RUN make install

# Minio client
RUN curl -o /usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-amd64/mc
RUN chmod +x /usr/local/bin/mc
RUN apt-get install -y jq

ADD run.sh /run.sh
ADD scripts/ /

CMD /run.sh

