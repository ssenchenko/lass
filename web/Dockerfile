ARG FIREBASE_EMULATOR_BASE_IMAGE=ghcr.io/ssenchenko/lass-web-emulator-base:node22-java21
FROM ${FIREBASE_EMULATOR_BASE_IMAGE}

WORKDIR /app

# Install dependencies in the image for deterministic startup.
COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN chmod +x /app/emulators.sh

# App Hosting, Auth, Firestore, Emulator UI
EXPOSE 5002 9099 8080 4000

ENTRYPOINT ["./emulators.sh"]
