## goalkeeper-api

An api for a simple betting system for the 2014 world cup

### endpoints
```
get games for user
GET /goalkeeper/users/:id/games?from=date&to=date
[{
  id: long
  team0: 3 letter code
  team1: 3 letter code
  winner: 0/1
  score: text
  prediction: 0/1
}]

set prediction for game
POST /goalkeeper/users/:id/games/:id
{
  prediction: 0/1
}

get user info and scores
GET /goalkeeper/users/:id
{
   first: string
   last: string
   picture_url: string
   score: percentage
   country: 3 letter string
   player: string
   level: 0/1/2
}

POST /goalkeeper/users/:id
{
   first: string
   last: string
   picture_url: string
   country: 3 letter string
   player: string
   level: 0/1/2
}

GET /goalkeeper/users?limit=n
[{
   first: string
   last: string
   picture_url: string
   score: percentage
   country: 3 letter string
   player: string
   level: 0/1/2
}]
```

### License

Copyright © 2014 Thomson Reuters