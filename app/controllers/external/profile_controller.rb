module External
  class ProfileController < BaseController
    def index
      render inertia: "External/Profile/Index", props: {
        consumer: serialize_consumer(current_consumer),
      }
    end
  end
end
