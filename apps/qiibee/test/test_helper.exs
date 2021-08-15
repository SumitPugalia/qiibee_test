Ecto.Adapters.SQL.Sandbox.mode(Qiibee.Repo, :manual)

# Mox mocks
Mox.defmock(BlockchainMock, for: Qiibee.Blockchain)

ExUnit.start()
Faker.start()
