# Mox mocks
Mox.defmock(BlockchainMock, for: Qiibee.Blockchain)
Mox.defmock(ProducerMock, for: Qiibee.Producer)

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Qiibee.Repo, :manual)
