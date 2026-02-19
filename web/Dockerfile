FROM node:22

WORKDIR /app

# Firebase emulators require Java 21+.
ARG TARGETARCH
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates curl tar && \
    rm -rf /var/lib/apt/lists/* && \
    case "${TARGETARCH}" in \
      amd64) JDK_ARCH="x64" ;; \
      arm64) JDK_ARCH="aarch64" ;; \
      *) echo "Unsupported arch: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://api.adoptium.net/v3/binary/latest/21/ga/linux/${JDK_ARCH}/jdk/hotspot/normal/eclipse" -o /tmp/jdk21.tar.gz && \
    mkdir -p /opt/java && \
    tar -xzf /tmp/jdk21.tar.gz -C /opt/java && \
    mv /opt/java/jdk-* /opt/java/jdk-21 && \
    rm -f /tmp/jdk21.tar.gz

ENV JAVA_HOME=/opt/java/jdk-21
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN npm install --global firebase-tools

# Install dependencies in the image for deterministic startup.
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN chmod +x /app/emulators.sh

# App Hosting, Auth, Firestore, Emulator UI
EXPOSE 5002 9099 8080 4000

ENTRYPOINT ["./emulators.sh"]
