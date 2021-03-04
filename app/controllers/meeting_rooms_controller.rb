class MeetingRoomsController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :validate_new_params, only: [:new]
	before_action :validate_user, only: [:new]

	def new
		###  Criar uma nova sala de reunião
		###  Parametros: user_id, name, local
		message = {origin: "", message: "Nova sala cadastrada com sucesso", status: 201}
		@current_user.meeting_rooms.create!(@params) rescue (message = {origin: "validate_user", message: "Erro na inclusão de nova sala", status: 401})
		return_json(message)
	end

	def show
		###  Exibir os dados de uma determinada sala de reunião
		response = MeetingRoom.where(id: params['room'].to_i).select(
				:id, :name, :local) rescue (response = {origin: "show", message: "Sala não localizada", status: 403})
		(response = {origin: "show", message: "Sala não localizada", status: 404}) if response[0].nil?

		return_json(response, 200)
	end

	def search_by_name
		###  Procurar uma sala pelo nome
		response = MeetingRoom.where("name ilike '%#{params[:by_name]}%'").select(
				:id, :name, :local) rescue (response = {origin: "show", message: "Sala não localizada", status: 403})
		(response = {origin: "show", message: "Sala não localizada", status: 403}) if response[0].nil?

		return_json(response, 200)
	end

	def list_all
		###  Exibir a lista de todas as salas
		response = MeetingRoom.all.select(:id, :name, :local) rescue (response = {origin: "show", message: "Não tem Sala Cadastrada", status: 404})
		(response = {origin: "show", message: "Não tem Sala Cadastrada", status: 403}) if response[0].nil?

		return_json(response, 200)
	end

	def delete
		###  Excluir uma sala
		message = {origin: "", message: "Sala excluida com sucesso", status: 200}
		room = MeetingRoom.where(id: params['room'].to_i)
		room[0].nil? ? (message = {origin: "validate_user", message: "Sala não localizada", status: 401}) : (room.delete(params['room']) )
		
		return_json(message)
	end

	private

	def validate_user
		###  Validar o usuário e buscar seus os dados
		@current_user = User.find(params[:user_id].to_i) rescue (return_json({origin: "validate_user", message: "Usuario não autorizado", status: 403}))
	end

	def validate_new_params
		@params = params.permit(:name, :local, :user_id)
	end

	def return_json(resource, status = nil)
		if resource.class != Hash
			render json: resource, status: status
		else
	        Rails.logger.info("\n\n*****  MeetingRoomsController/#{origem} - #{message}\n") if resource[:origem] == ""
			render :json => resource[:message] , status: resource[:status]
		end
	end
end
