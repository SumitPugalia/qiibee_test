defmodule Qiibee.Rabbitmq do
  use GenServer
  @queue_name "loyalty_events"
  ## Client API
  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, :ok, options ++ [name: __MODULE__])
  end

  def get_channel() do
    GenServer.call(__MODULE__, :channel)
  end

  ## Server Callbacks
  def init(_) do
    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, @queue_name, durable: true)
    {:ok, %{channel: channel, connection: connection}}
  end

  def handle_call(:channel, _from, state) do
    %{channel: channel} = state
    {:reply, channel, state}
  end

  def terminate(_reason, %{connection: connection}) do
    AMQP.Connection.close(connection)
    %{}
  end
end
