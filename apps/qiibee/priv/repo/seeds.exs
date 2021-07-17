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
{:ok, user1} = Qiibee.Accounts.create_user(%{
    "name" => "Name",
    "email" => "email@yahoo.com",
    "phone_number" => "9582557758",
    "language" => "ENGLISH",
    "brand_id" => brand1.id 
})
