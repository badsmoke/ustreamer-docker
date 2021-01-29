#build
FROM ubuntu:20.04 as build
WORKDIR /build


RUN apt-get update && \
    apt-get install -y git libwebp-dev ca-certificates build-essential libevent-dev libjpeg62-dev uuid-dev libbsd-dev make gcc libjpeg8 libjpeg-turbo8 libuuid1 libbsd0

RUN apt install -y libjpeg-turbo8-dev

RUN git clone --depth=1 https://github.com/pikvm/ustreamer

WORKDIR /build/ustreamer/
RUN make

FROM ubuntu:20.04 as RUN

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        libevent-2.1 \
        libevent-pthreads-2.1-7 \
        libjpeg8 \
        uuid \
        libbsd0

WORKDIR /ustreamer
COPY --from=build /build/ustreamer/ustreamer .

EXPOSE 8080
ENTRYPOINT [ "./ustreamer", "--host=0.0.0.0", "--slowdown"]
