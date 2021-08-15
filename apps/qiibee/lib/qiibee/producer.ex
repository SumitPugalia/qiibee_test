defmodule Qiibee.Producer do
  @moduledoc false
  @callback dispatch(map()) :: any()

  def dispatch(event) do
    client().dispatch(event)
  end

  defp client() do
    Application.fetch_env!(:qiibee, :producer)[:client]
  end
end
