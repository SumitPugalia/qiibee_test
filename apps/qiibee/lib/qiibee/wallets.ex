defmodule Qiibee.Wallets do
	@moduledoc """
	Wallets context.
	"""
	alias Ecto.Multi
	alias Qiibee.Wallets.Transaction	
	alias Qiibee.Wallets.Wallet
	alias Qiibee.Repo
  
	import Ecto.Query, warn: false

	#############################################################
	# SERVICE LAYER - POINTS
	#############################################################
	
	def add_points(%Wallet{} = wallet, reference_code, points) do
		Multi.new
		|> add_transaction(:credit, wallet.id, reference_code, points)
		|> credit(wallet.id, points)
		|> Repo.transaction()
  end

  def deduct_points(%Wallet{} = wallet, reference_code, points) do
    Multi.new
		|> add_transaction(:debit, wallet.id, reference_code, points)
		|> debit(wallet.id, points)
		|> Repo.transaction()
	end
	
	#############################################################
	# PRIVATE FUNCTIONS
	#############################################################

	defp credit(multi, wallet_id, points) do
    query = from(w in Wallet, where: w.id == ^wallet_id)
    Multi.update_all(multi, :credit, query, inc: [points: points])
	end
	
	defp debit(multi, wallet_id, points) do
    query = from(w in Wallet, where: w.id == ^wallet_id and w.points > ^points)
    points = (-1) * points
    
    Multi.update_all(multi, :debit, query, inc: [points: points])
	end

	defp add_transaction(multi, type, wallet_id, reference_code, points) do
		attrs = %{type: type, wallet_id: wallet_id, reference_code: reference_code, points: points}
		Multi.insert(multi, :transaction, Transaction.changeset(%Transaction{}, attrs))
	end
end