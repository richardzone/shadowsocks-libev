#! /bin/bash

# You need either a Shadowsocks password or a docker container to use this
if [[ -z "$SHADOWSOCKS_PASSWORD" && -z "$SSH_PUBLIC_KEY" ]]; then
  echo "FATAL ERROR: Neither \$SHADOWSOCKS_PASSWORD nor \$SSH_PUBLIC_KEY is specified."
  echo "Please specify it with docker run -e \"SHADOWSOCKS_PASSWORD=mypass\" -e \"SSH_PUBLIC_KEY=\`cat ~/.ssh/id_rsa.pub\`\""
  kill 1
  exit 1
fi

if [[ -n "$SSH_PUBLIC_KEY" ]]; then
  echo $SSH_PUBLIC_KEY >> /root/.ssh/authorized_keys
else
  echo "INFO: No SSH Public Key specified. SSH will not function."
fi

if [[ -n "$SHADOWSOCKS_PASSWORD" ]]; then
  IMAGE_NAME="richardzone/shadowsocks-libev"
  SHADOWSOCKS="/usr/local/bin/ss-server"
  HOST="0.0.0.0"
  PORT="8338"

  # $SHADOWSOCKS -s $HOST -p $PORT -k $SHADOWSOCKS_PASSWORD $EXTRA_SHADOWSOCKS_ARGS >> /var/log/syslog 2>&1
  echo "INFO: Starting Shadowsocks server . . ."
  $SHADOWSOCKS -s $HOST -p $PORT -k $SHADOWSOCKS_PASSWORD $EXTRA_SHADOWSOCKS_ARGS
 
else
  echo "INFO: No Shadowsocks Password specified. Shadowsocks will not function."
fi

