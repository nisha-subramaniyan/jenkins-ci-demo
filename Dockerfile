
FROM alpine:3.20

RUN apk add --no-cache bash busybox-extras \
    && addgroup -S app \
    && adduser -S -G app app

WORKDIR /app

COPY --chown=app:app app.sh .
COPY --chown=app:app README.md .

RUN chmod 0555 app.sh

USER app

EXPOSE 8080

CMD ["bash", "./app.sh"]
