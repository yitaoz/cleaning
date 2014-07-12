class OrdersController < ApplicationController

	def new
		@order = Order.new
	end

	def create
		@order = Order.new(order_params)
		if @order.save
			session[:tmp_order] = @order.id
			redirect_to order_steps_path
		else 
			render :new
		end
	end

	private
		def order_params
			params.require(:order).permit(:rooms,:bathroom,:cleanduration)
		end
end