defmodule Qiibee.Enums do
  @moduledoc false
  import EctoEnum

  defenum(TransactionType, :transaction_type, [:debit, :credit])
end
