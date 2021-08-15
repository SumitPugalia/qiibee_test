defmodule Qiibee.Balances do
  @moduledoc """
  balances context.
  """
  alias Ecto.Multi
  alias Qiibee.Balances.Transaction
  alias Qiibee.Balances.Balance
  alias Qiibee.Repo
  alias Qiibee.Blockchain

  import Ecto.Query, warn: false

  #############################################################
  # SERVICE LAYER - POINTS
  #############################################################

  def add_points(user_id, reference_code, points) do
    tx_hash = Blockchain.credit(user_id, points)
    add_transaction(:credit, user_id, reference_code, points, tx_hash)
    :ok
  end

  def deduct_points(user_id, reference_code, points) do
    case not insufficient_balance?(user_id, points) do
      true ->
        tx_hash = Blockchain.debit(user_id, points)
        add_transaction(:debit, user_id, reference_code, points, tx_hash)
        :ok
      false ->
        {:error, :insufficient_balance}
    end
  end

  def get_by_code_and_user(user_id, code) do
    case Repo.one(
           from t in Transaction, where: t.reference_code == ^code and t.user_id == ^user_id
         ) do
      nil -> {:error, :no_txn_found}
      txn -> {:ok, txn}
    end
  end

  def list_transactions(user) do
    from(t in Transaction, where: t.user_id == ^user.id)
    |> Repo.all()
	end

  #############################################################
  # PRIVATE FUNCTIONS
  #############################################################

  defp add_transaction(type, user_id, reference_code, points, tx_hash) do
    attrs = %{type: type, user_id: user_id, reference_code: reference_code, points: points, tx_hash: tx_hash}
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert!()
  end

  defp insufficient_balance?(user_id, points) do
    case Repo.one(
           from w in Wallet, where: w.user_id == ^user_id
         ) do
      nil -> true
      balance -> 
        if balance.points < points, do: true, else: false
    end
  end
end
