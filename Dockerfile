# Compile XDebug - See the wizard at https://xdebug.org/wizard.php
# for how these steps were determined; they may change for future
# PHP versions

ARG xdebug_version=2.6.1

FROM php:7.2 as buildXDebug

ARG xdebug_version

WORKDIR /src
COPY src/xdebug-${xdebug_version}.tgz .
RUN tar -xvzf xdebug-${xdebug_version}.tgz
WORKDIR /src/xdebug-${xdebug_version}
RUN phpize
RUN ./configure
RUN make

# Build PHP dev image and install and configure XDebug

FROM php:7.2-apache

ARG xdebug_version

RUN apt-get update && apt-get -y install vim git net-tools \
	&& rm -rf /var/lib/apt/lists/*
WORKDIR /usr/local/lib/php/extensions/no-debug-non-zts-20170718
COPY --from=buildXDebug /src/xdebug-${xdebug_version}/modules/xdebug.so .
#RUN echo "zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20170718/xdebug.so" > /usr/local/etc/php/php.ini

ENV XDEBUGINI_PATH=/usr/local/etc/php/conf.d/xdebug.ini
RUN echo "zend_extension="`find /usr/local/lib/php/extensions/ -iname 'xdebug.so'` > $XDEBUGINI_PATH
COPY src/xdebug.ini /tmp/xdebug.ini
RUN cat /tmp/xdebug.ini >> $XDEBUGINI_PATH

# Discover host IP address on linux machines
#RUN echo "xdebug.remote_host="`route|awk '/default/ { print $2 }'` >> $XDEBUGINI_PATH

# Special DNS to resolve IP on Windows and Mac Host OSs
RUN echo "xdebug.remote_host=host.docker.internal" >> $XDEBUGINI_PATH

WORKDIR /var/www/html

EXPOSE 80
