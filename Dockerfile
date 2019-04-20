FROM ubuntu:18.04
LABEL Name=ib-gateway Version=0.0.1 maintainer="Weihua Yi (arcayi@qq.com)"

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# change Ubuntu apt source to aliyun
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak \
  && sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list \
  && apt-get clean \
  && apt-get update \
  && apt-get install -y apt-utils \
  && apt-get install -y wget \
  && apt-get install -y unzip \
  && apt-get install -y xvfb \
  && apt-get install -y libxtst6 \
  && apt-get install -y libxrender1 \
  && apt-get install -y libxi6 \
	&& apt-get install -y x11vnc \
  && apt-get install -y socat \
  && apt-get install -y software-properties-common

# Setup IB TWS
RUN mkdir -p /opt/TWS
WORKDIR /opt/TWS
ARG GATEWAY_FILE=ibgateway-latest-standalone-linux-x64.sh
# RUN wget -q https://download.ibkr.com.cn/installers/ibgateway/latest-standalone/$GATEWAY_FILE
ADD $GATEWAY_FILE $GATEWAY_FILE
RUN chmod a+x $GATEWAY_FILE

# Install TWS
RUN yes n | /opt/TWS/$GATEWAY_FILE

# Setup  IBController
RUN mkdir -p /opt/IBC/Logs
WORKDIR /opt/IBC/
ARG IBC_FILE=IBCLinux-3.7.5.zip
# RUN wget -q https://github.com/IbcAlpha/IBC/releases/download/3.7.3/$IBC_FILE
ADD $IBC_FILE $IBC_FILE
RUN unzip ./$IBC_FILE
RUN chmod -R u+x *.sh && chmod -R u+x scripts/*.sh

# No need for java installation now:
# https://github.com/IbcAlpha/IBC/blob/3.7.5/userguide.md
# 
# # Install Java 8 TODO maybe just use "from:java8"
# RUN \
#   echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
#   add-apt-repository -y ppa:webupd8team/java && \
#   apt-get update && \
#   apt-get install -y oracle-java8-installer && \
#   rm -rf /var/lib/apt/lists/* && \
#   rm -rf /var/cache/oracle-jdk8-installer

WORKDIR /

ENV DISPLAY :0

ADD ./ib/config.ini /root/IBC/config.ini

ADD runscript.sh runscript.sh
ADD ./vnc/xvfb_init /etc/init.d/xvfb
ADD ./vnc/vnc_init /etc/init.d/vnc
ADD ./vnc/xvfb-daemon-run /usr/bin/xvfb-daemon-run

RUN chmod -R u+x runscript.sh && chmod -R 777 /usr/bin/xvfb-daemon-run
RUN chmod 777 /etc/init.d/xvfb
RUN chmod 777 /etc/init.d/vnc

RUN rm -rf /opt/TWS/$GATEWAY_FILE \
&&  rm -rf /opt/IBC//$IBC_FILE

CMD bash runscript.sh
