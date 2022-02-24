FROM alpine:3.11 as packager

LABEL maintainer="shaoranlaos@shaoranlaos.de"

RUN apk add --no-cache iperf3 iputils
RUN echo "nobody:x:65534:65534:Nobody:/:" > /passwd.minimal

FROM scratch

ENV LD_LIBRARY_PATH /usr/lib:/lib
ENV ARGS ""
ENV SERVER ""
ENV SERVER_PORT ""

USER nobody

COPY --from=packager --chown=65534:65534 /tmp /tmp
COPY --from=packager /passwd.minimal /etc/passwd
COPY --from=packager /lib/ld-musl-aarch64.so.1 /lib/libcrypto.so.1.1 /lib/
COPY --from=packager /usr/lib/libiperf.so.0 /usr/lib/libcap.so.2 /usr/lib/
COPY --from=packager /usr/bin/iperf3 /usr/bin/seq /usr/bin/
COPY --from=packager /bin/date /bin/sh /bin/ping /bin/
COPY src/startscript.sh startscript.sh

ENTRYPOINT ["./startscript.sh"]
