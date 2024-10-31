FROM alpine:3.18 as builder

# Install Zig
RUN apk add --no-cache wget \
    && wget https://ziglang.org/download/0.13.0/zig-linux-x86_64-0.13.0.tar.xz \
    && tar -xf zig-linux-x86_64-0.13.0.tar.xz \
    && mv zig-linux-x86_64-0.13.0 /usr/local/zig

# Build application
WORKDIR /app
COPY . .
RUN /usr/local/zig/zig build -Doptimize=ReleaseFast

FROM alpine:3.18
WORKDIR /app
COPY --from=builder /app/zig-out/bin/apz .
EXPOSE 8080
CMD ["./apz"]