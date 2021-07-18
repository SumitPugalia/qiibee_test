# Qiibee.Umbrella

# DB : Postgres

There are 2 projects:

**Qiibee** - its the backend part which has points management, user/brand accounts, coupons management, notification service.

**QiibeeWeb** - its the frontend part with endpoints related to user and brand.

## STEPS:

- mix run priv/repo/seeds.exs [seed DB]
- iex -S mix phx.server [start server]

## Note:

- Designing of such product requires lot of thinking and time. I tried my best to segregate various domains based on my intial thoughts.
- The task is pretty huge and coudn't cover a lot of things in 10-12 hours.
- Couldn't get time for dockers, Rabbit MQ ad Broadway Cosumer, tests.
- I have created a basic points redeem (code 2 points) and reward (points to coupon) system which isn't based of blockchain for now. SO didn't use RabbitMQ.
- Have added tests for a context just to provide the idea on how that can be done.
- Use of RabbitMQ and Braodway can be plugged in once they are written.
- Have attached postman collection in the repo
