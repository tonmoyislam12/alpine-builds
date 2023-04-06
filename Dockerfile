FROM alpine:3.16.4 as maker
RUN apk --no-cache add alpine-sdk coreutils cmake linux-headers perl musl m4 sudo \
  gnutls-dev expat-dev sqlite-dev c-ares-dev cppunit-dev \
  && adduser -G abuild -g "Alpine Package Builder" -s /bin/ash -D builder \
  && echo "builder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && mkdir /packages \
  && chown builder:abuild /packages \
  && mkdir -p /var/cache/apk \
  && ln -s /var/cache/apk /etc/apk/cache
WORKDIR /home/builder
RUN chmod 777 /home/builder
ENV VAR 3.14-stable
RUN wget https://gitlab.alpinelinux.org/alpine/aports/-/archive/$VAR/aports-$VAR.tar.gz && tar -xf aports-$VAR.tar.gz
#https://gitlab.alpinelinux.org/alpine/aports/-/archive/3.14-stable/aports-3.14-stable.tar.gz

RUN su -c "mkdir hello && cp -r /home/builder/aports-$VAR/main/unrar ./hello/ \
   && cd hello/unrar && abuild-keygen -i -n -a && abuild -r" builder


RUN mkdir /abc && cp -r /home/builder/packages/ /abc/
FROM scratch AS alpinesdk

COPY --from=maker /abc/ /
