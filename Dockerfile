FROM phusion/baseimage:latest

MAINTAINER Richard

ENV DEPENDENCIES git-core build-essential autoconf libtool libssl-dev
ENV BASEDIR /tmp/shadowsocks-libev
EXPOSE 8338 22

# Set up building environment
RUN apt-get update \
 && apt-get install -y $DEPENDENCIES

# Get the latest code, build and install
RUN git clone https://github.com/shadowsocks/shadowsocks-libev.git $BASEDIR
WORKDIR $BASEDIR
RUN ./configure \
 && make \
 && make install

# Tear down building environment and delete git repository
WORKDIR /
RUN rm -rf $BASEDIR/shadowsocks-libev\
 && apt-get --purge autoremove -y $DEPENDENCIES

# Add runit service for shadowsocks (password must be provided by $SHADOWSOCKS_PASSWORD)
RUN mkdir /etc/service/shadowsocks
ADD runServer.sh /etc/service/shadowsocks/run

# Enable SSH (key must be provided by environment variable $SSH_PUBLIC_KEY)
RUN rm -f /etc/service/sshd/down

# Clean up APT when done.
RUN apt-get clean && rm -rf /tmp/* /var/tmp/*

# Override the host and port in the config file.
CMD ["/sbin/my_init"]
