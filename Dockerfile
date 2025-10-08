FROM alpine:3

RUN apk update && apk add \ 
  alpine-sdk \ 
  git \
  gcompat \
  libstdc++ \
  autoconf \
  libxt-dev \
  cairo-dev \
  m4 \
  automake \
  tk-dev \
  fontconfig \
  font-nunito

WORKDIR /tmp
RUN git clone https://github.com/RTimothyEdwards/XCircuit

WORKDIR /tmp/XCircuit
# freeze version
RUN git reset --hard b67fb820ac5506f9926ebc7f92c65c74c48e087d
RUN autoreconf -f -i && \
  ./configure --build=aarch64-unknown-linux-gnu && \
  make && \
  make install

WORKDIR /
RUN rm -rf /tmp/XCircuit
COPY fonts/nunito.lps /usr/local/lib/xcircuit-3.10/fonts
COPY fonts/nunito.xfe /usr/local/lib/xcircuit-3.10/fonts
RUN fc-cache -f
RUN adduser -Ds /bin/ash user
RUN mkdir /app && chown user:user -R /app
WORKDIR /app
USER user
CMD ["xcircuit"]