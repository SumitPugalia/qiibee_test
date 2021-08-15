defmodule Qiibee.Consumer do
    use Broadway
    
    @behaviour Broadway.Acknowledger

    alias Broadway.Message
    alias Qiibee.Coupons
    alias Qiibee.Balances

    @queue_name "loyalty_events"
  
    def start_link(_opts) do
      Broadway.start_link(__MODULE__,
        name: Qiibee.Consumer,
        producer: [
          module: {BroadwayRabbitMQ.Producer, queue: @queue_name},
          concurrency: 1,
          rate_limiting: [
            allowed_messages: 1,
            interval: 12_000
          ]
        ],
        processors: [
          default: [
            concurrency: 1
          ]
        ]
      )
    end
  
    @impl true
    def handle_message(_, message, _) do
      data = Jason.decode!(message.data)
      handle_event(data)
      message
    end

    defp handle_event(%{"event" => "code_to_points"} = data) do
        Coupons.redeem_coupon(data["user_id"], data["code"] )
    end

    defp handle_event(%{"event" => "points_to_reward"} = data) do
        Coupons.reward_coupon(data["user_id"], data["id"])
    end

    defp handle_event(%{"event" => "earn_points"} = data) do
        Balances.add_points(data["user_id"], "ManuallyAddedByBrand", data["points"])
    end

    defp handle_event(%{"event" => "burn_points"} = data) do
        Balances.deduct_points(data["user_id"], "ManuallyDeductedByBrand", data["points"])
    end
  end