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
    apt-get install -y socat && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /home/challenge

# Copy compiled binary from builder stage
COPY --from=builder /build/overflowme ./overflowme

RUN echo "TheEasiestOverflow" > flag.txt

# Permissions
RUN chmod 755 overflowme && \
    chmod 400 flag.txt && \
    chown root:root overflowme flag.txt

EXPOSE 4444

# Run the binary in a loop with socat, 5-second delay between runs
CMD while true; do \
      socat TCP-LISTEN:4444,reuseaddr,fork EXEC:./overflowme; \
      echo "Restarting in 5 seconds..."; \
      sleep 5; \
    done
