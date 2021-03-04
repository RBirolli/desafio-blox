class DailyScheduleController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :validate_user, only: [:new]

	def reserve_room
	end

	def release_reserve
	end

	def list_available_room
	end

	def list_schedule
	end

	private
	
	def validate_user
		###  Validar o usuário e buscar seus os dados
		@current_user = User.find(params[:user_id].to_i) rescue (return_json({origin: "validate_user", message: "Usuario não autorizado", status: 403}))
	end
end
