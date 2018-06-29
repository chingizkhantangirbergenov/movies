class ApplicationController < ActionController::API
	

	before_action :check_token

	private
	def check_token
		u = User.find_by_token(params[:token])
		if u.nil?
			render(json: {message: "No such token exists", status: :error}) 
		elsif u.request_count > 3
			render(json: {message: "Pay me money", status: :error}) 
		else
			u.update_attributes(request_count: u.request_count + 1)
		end
	end
end
