FROM erlang:22-alpine
WORKDIR /app
COPY _build/default/rel/samson .
EXPOSE 8080
ENTRYPOINT ["/app/bin/samson"]
CMD ["foreground"]
