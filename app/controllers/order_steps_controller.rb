class OrderStepsController < ApplicationController
	include Wicked::Wizard
	steps :timeplace, :contact, :payment
	def show
		@times = Timing.order("available_from")

		order_id = session[:tmp_order]
		@order = Order.find(order_id)
		if @order.cleanduration
			@order.price = @order.cleanduration*15
		end
		Rails.logger.debug("My object: #{@order}")
		@user = User.new
		render_wizard
	end

	def update
		@times = Timing.order("available_from")
		@order = Order.find(session[:tmp_order])
		@order.attributes=params.require(:order).permit(:location, :cleantime, :cleandate, :name, :number, :email, :cleaner, :status)
		@order.status = step.to_s
    	@order.status = 'active' if step == steps.last
    	@order.update_attributes(params[:tmp_order])
    	Rails.logger.debug("My object: #{@order}")
		render_wizard @order
	end

	private
	def finish_wizard_path
		@order = Order.find(session[:tmp_order])
		booking_confirmation_order_path(@order)
  		# new_user_path
	end
end
