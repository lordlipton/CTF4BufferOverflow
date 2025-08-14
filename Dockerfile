# Stage 1: Build the binary
FROM debian:stable-slim AS builder

RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Copy vulnerable source
COPY overflowme.c .

# Compile stripped, vulnerable binary with protections disabled
RUN gcc -fno-stack-protector -z execstack -no-pie -O2 -o overflowme overflowme.c && \
    strip overflowme

# Stage 2: Runtime environment
FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y netcat && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/challenge

# Copy compiled binary from builder stage
COPY --from=builder /build/overflowme ./overflowme

# Add the flag
COPY flag.txt ./flag.txt

# Permissions
RUN chmod 755 overflowme && \
    chmod 400 flag.txt && \
    chown root:root overflowme flag.txt

EXPOSE 4444

# Run the binary in a loop with netcat
CMD while true; do nc -lvnp 4444 -e ./overflowme; done


EXPOSE 4444

# Run in infinite loop
CMD while true; do nc -lvnp 4444 -e ./overflowme; done
