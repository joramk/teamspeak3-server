FROM	alpine:latest
MAINTAINER Joram Knaack <joramk@gmail.com>

ENV	TS_VERSION LATEST
ENV	LANG C.UTF-8

RUN	apk add bash jq libstdc++
COPY	start-teamspeak3.sh /start-teamspeak3

VOLUME	/data
WORKDIR	/data

EXPOSE	9987/udp 10011 30033
CMD	["/start-teamspeak3"]
