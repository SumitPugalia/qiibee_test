# Qiibee.Umbrella

# DB : Postgres

There are 2 projects:

**Qiibee** - its the backend part which has points management, user/brand accounts, coupons management, notification service, RabbitMQ

**QiibeeWeb** - its the frontend part with endpoints related to user and brand.

## STEPS:

- docker-compose up [rabbitmq + postgres]
- cd apps/qiibee && mix ecto.setup
- cd ../.. && iex -S mix phx.server [start server]
- mix test for tests


## Notes:

- Mox for Mocking.
- RabbitMQ as Producer.
- Broadway as Consumer.
