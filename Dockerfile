FROM ubuntu:18.04

MAINTAINER Joram Knaack <joramk@gmail.com>

ENV TS_VERSION LATEST
ENV LANG C.UTF-8

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y install bzip2 wget ca-certificates jq \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -M -s /bin/false --uid 1000 teamspeak3 \
    && mkdir /data \
    && chown teamspeak3:teamspeak3 /data

#RUN	apk add bash jq libc6-compat gcompat libstdc++

COPY	get-version.sh /get-version
COPY	start-teamspeak3.sh /start-teamspeak3

EXPOSE	9987/udp 10011 30033

VOLUME	/data
WORKDIR	/data
CMD	["/start-teamspeak3"]
