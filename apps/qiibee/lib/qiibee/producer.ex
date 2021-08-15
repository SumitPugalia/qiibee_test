defmodule Qiibee.Producer do
    @moduledoc false
    alias Qiibee.Rabbitmq
    @queue_name "loyalty_events"
  
    def dispatch(event) do
        channel = Rabbitmq.get_channel()
        AMQP.Basic.publish(channel, "", @queue_name, event)
    end
end