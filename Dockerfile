FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    iperf3 \
    git sudo build-essential cmake make gcc g++ pkg-config \
    libtool autoconf automake \
    libmbedtls-dev libsctp-dev libyaml-cpp-dev libgtest-dev \
    libfftw3-dev libboost-program-options-dev libconfig++-dev \
    iproute2 net-tools iputils-ping nano \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/zeromq/libzmq.git && \
    cd libzmq && ./autogen.sh && ./configure && \
    make -j$(nproc) && make install && ldconfig

RUN git clone https://github.com/zeromq/czmq.git && \
    cd czmq && ./autogen.sh && ./configure && \
    make -j$(nproc) && make install && ldconfig

RUN git clone https://gitlab.com/ocudu/ocudu.git && \
    cd ocudu && mkdir build && cd build && \
    cmake ../ -DENABLE_EXPORT=ON -DENABLE_ZEROMQ=ON && \
    make -j$(nproc)

RUN git clone https://github.com/srsRAN/srsRAN_4G.git && \
    cd srsRAN_4G && mkdir build && cd build && \
    cmake ../ -DENABLE_ZEROMQ=ON && \
    make -j$(nproc)

COPY configs /configs
COPY scripts /scripts

RUN chmod +x /scripts/*.sh

WORKDIR /opt

CMD ["/bin/bash"]
