FROM erlang:22-alpine
WORKDIR /app
COPY _build/default/rel/samson .
ENTRYPOINT ["./bin/samson"]
