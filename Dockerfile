FROM erlang:22
WORKDIR /app
COPY rebar.config rebar.lock ./
COPY src ./src
RUN ls -all
RUN rebar3 compile && rebar3 release && ln -s /app/_build/default/rel/samson/bin/samson /usr/local/bin/samson
EXPOSE 8080
ENTRYPOINT ["samson"]
CMD ["foreground"]
