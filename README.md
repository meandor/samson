# Samson
[![CircleCI](https://circleci.com/gh/meandor/samson.svg?style=svg)](https://circleci.com/gh/meandor/samson)
> Samson lives in a cave, and he loves lying in his hammock, cuddling with his "Schnuffeltuch" (his security blanket), and dancing.
>
> "Ich bin Samson, und ich schaff's!" -- Samson

An [Erlang](https://www.erlang.org/) [OTP](https://erlang.org/doc/design_principles/users_guide.html) application serving as a chatbot backend.

## Build
```bash
rebar3 compile
```

## Test
```bash
rebar3 eunit
```

## Endpoints
### Health endpoint
```http request
GET /health
# Returns 200 - {"status": "up"} 
```

### Google Chat API
Handles incoming events and response according to [Google Chat API](https://developers.google.com/hangouts/chat/reference/message-formats).
Body is in format of [events](https://developers.google.com/hangouts/chat/reference/message-formats/events).
```http request
POST /gchat/$GOOGLE_CHAT_ENDPOINT
# Returns 200 - {"text": "answer"} 
```

### Links
 * [hex - package manager for the Erlang ecosystem](https://hex.pm/)
 * [Learn You Some Erlang for great good!](https://learnyousomeerlang.com/)
 * [Google Chat API Documentation](https://developers.google.com/hangouts/chat)
