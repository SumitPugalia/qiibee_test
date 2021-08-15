defmodule Qiibee.RabbitmqWorker do
  @moduledoc false
  alias Qiibee.Rabbitmq
  @queue_name "loyalty_events"

  @behaviour Qiibee.Producer
  def dispatch(event) do
    channel = Rabbitmq.get_channel()
    AMQP.Basic.publish(channel, "", @queue_name, event)
  end
end
