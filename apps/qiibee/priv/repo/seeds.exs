# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Qiibee.Repo.insert!(%Qiibee.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, brand1} = Qiibee.Accounts.create_brand()

{:ok, _user} =
  Qiibee.Accounts.create_user(%{
    "name" => "Name",
    "email" => "email@yahoo.com",
    "phone_number" => "9582557758",
    "language" => "ENGLISH",
    "brand_id" => brand1.id
  })

{:ok, dt, _} = DateTime.from_iso8601("2024-01-23T23:50:07Z")
{:ok, utc_datetime_usec} = Ecto.Type.cast(:utc_datetime_usec, dt)

{:ok, _coupon} =
  Qiibee.Coupons.create_redeem_coupon(%{
    "expires_at" => utc_datetime_usec,
    "brand_id" => brand1.id,
    "points" => 100
  })

{:ok, _coupon} =
  Qiibee.Coupons.create_reward_coupon(%{
    "description" => "15% discount on Netflix",
    "brand_id" => brand1.id,
    "points" => 150
  })
