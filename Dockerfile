# ---------- Stage 1: Build ----------
FROM node:18 AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

RUN npm install

# Copy all files
COPY . .

# Build React app
RUN npm run build


# ---------- Stage 2: Production ----------
FROM nginx:alpine

# Remove default nginx config
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy custom nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy build files
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]