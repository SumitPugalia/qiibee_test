defmodule Qiibee.Balances do
  @moduledoc """
  balances context.
  """
  alias Qiibee.Balances.Transaction
  alias Qiibee.Balances.Balance
  alias Qiibee.Repo
  alias Qiibee.Blockchain

  import Ecto.Query, warn: false

  #############################################################
  # SERVICE LAYER - POINTS
  #############################################################

  def add_points(user_id, reference, points) do
    tx_hash = Blockchain.credit(user_id, points)
    add_transaction(:credit, user_id, reference, points, tx_hash)
    :ok
  end

  def deduct_points(user_id, reference, points) do
    case not insufficient_balance?(user_id, points) do
      true ->
        tx_hash = Blockchain.debit(user_id, points)
        add_transaction(:debit, user_id, reference, points, tx_hash)
        :ok
      false ->
        {:error, :insufficient_balance}
    end
  end

  def get_by_code_and_user(user_id, code) do
    case Repo.one(
           from t in Transaction, where: t.coupon == ^code and t.user_id == ^user_id
         ) do
      nil -> {:error, :no_txn_found}
      txn -> {:ok, txn}
    end
  end

  def list_transactions(user_id) do
    from(t in Transaction, where: t.user_id == ^user_id)
    |> Repo.all()
	end

  #############################################################
  # PRIVATE FUNCTIONS
  #############################################################

  defp add_transaction(type, user_id, reference, points, tx_hash) do
    attrs = %{type: type, user_id: user_id, reference: reference, points: points, tx_hash: tx_hash}
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert!()
  end

  defp insufficient_balance?(user_id, points) do
    case Repo.one(
           from b in Balance, where: b.user_id == ^user_id
         ) do
      nil -> true
      balance -> 
        if balance.points < points, do: true, else: false
    end
  end
end
