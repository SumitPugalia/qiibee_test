defmodule Qiibee.Blockchain do
    @callback credit(Ecto.UUID.t(), integer()) :: Ecto.UUID.t()
    @callback debit(Ecto.UUID.t(), integer()) :: Ecto.UUID.t()


    @spec  credit(Ecto.UUID.t(), integer()) :: Ecto.UUID.t()
    def credit(user_id, points) do
        client().credit(user_id, points)
    end

    @spec debit(Ecto.UUID.t(), integer()) :: Ecto.UUID.t()
    def debit(user_id, points) do
        client().debit(user_id, points)
    end

#############################################################
  # PRIVATE FUNCTIONS
  #############################################################
    defp client() do
        Application.fetch_env!(:qiibee, :blockchain)[:client]
    end
end