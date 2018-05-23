FROM alpine:edge as builder
RUN apk --no-cache add git rust cargo make openssl-dev eudev-dev linux-headers g++ perl
# TODO: remove perl once the ring situation is solved
WORKDIR /root/
RUN git clone https://github.com/paritytech/parity.git
WORKDIR /root/parity
RUN git checkout stable
RUN cargo b --release

FROM alpine:latest  
RUN apk --no-cache add ca-certificates libgcc libstdc++ eudev
WORKDIR /root/
COPY --from=builder /root/parity/target/release/parity .
ENTRYPOINT ["./parity"]
