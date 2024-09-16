# Use an official Node.js image with version 20
FROM node:20

# Install JDK 17
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get clean;

# Install Firebase CLI
RUN npm install -g firebase-tools

# Copy Firebase project files (including firebase.json) from host to container
COPY . /app

# Default working directory
WORKDIR /app

# Sync it with firebase.json so that all ports there are exposed
EXPOSE 4000 4001 4002 4010 4011 4020 4030

RUN chmod +x emulators.sh

ENTRYPOINT ["./emulators.sh"]
