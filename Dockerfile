FROM alpine:3.20

RUN apk add --no-cache bash busybox-extras

WORKDIR /app

COPY app.sh .
COPY README.md .

RUN chmod +x app.sh

EXPOSE 8080

CMD ["bash", "./app.sh"]
