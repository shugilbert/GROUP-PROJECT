# stage one 
FROM node:16-slim As builder
WORKDIR /calculator
COPY package.json .
COPY yarn.lock .
RUN yarn install
COPY . .
RUN yarn build

#stage 2
FROM nginx:1.19.0
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /calculator/build .
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
