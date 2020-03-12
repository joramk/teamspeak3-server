#!/bin/bash

case $TS_VERSION in
  LATEST)
    JSON=$(wget -q -O - https://www.teamspeak.com/versions/server.json)
    export TS_VERSION=`echo $JSON | jq -r ".linux.x86_64.version"`
    URL=`echo $JSON | jq -r ".linux.x86_64.mirrors.\"teamspeak.com\"" | sed 's/amd64/alpine/'`
    ;;
  *)
    URL="http://files.teamspeak-services.com/releases/server/${TS_VERSION}/teamspeak3-server_linux_alpine-${TS_VERSION}.tar.bz2"
    ;;
esac
cd /data

download=0
if [ ! -e version ]; then
  download=1
else
  read version <version
  if [ "$version" != "$TS_VERSION" ]; then
    download=1
  fi
fi

if [ "$download" -eq 1 ]; then
  echo "Downloading TeamSpeak ${TS_VERSION} from ${URL} ..."
  wget -q -O teamspeak3-server.tar.gz ${URL} \
  && tar -j -x -f teamspeak3-server.tar.gz --strip-components=1 \
  && rm -f teamspeak3-server.tar.gz \
  && echo $TS_VERSION >version
fi

export LD_LIBRARY_PATH=".:/data:/data/redist"
TS3ARGS=""

if [ -e /data/ts3server.ini ]; then
  TS3ARGS="inifile=/data/ts3server.ini"
else
  TS3ARGS="createinifile=1"
fi

if [ -n "$SERVERADMIN_PASSWORD" ]; then
  TS3ARGS="$TS3ARGS serveradmin_password=$SERVERADMIN_PASSWORD"
fi

if [ "accept" = "$TS3SERVER_LICENSE" ]; then
  TS3ARGS="$TS3ARGS license_accepted=1"
  touch /data/.ts3server_license_accepted
fi

exec ./ts3server $TS3ARGS
