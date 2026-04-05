module Internal
  class CustomersController < BaseController
    def index
      @customers = Customer.includes(:orders).order(:name)
    end

    def show
      @customer = Customer.includes(:orders).find(params[:id])
      @orders   = @customer.orders.recent
    end
  end
end
