class DailyScheduleController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_action :validate_user, only: [:new]
	before_action :validate_params, only: [:new]

	def new
		begin
			###  Validar as datas e efetuar a reserva de uma sala
			s_time = DateTime.parse(@params[:start_time])
			e_time = DateTime.parse(@params[:end_time])
			message = []

			###  Verificar se a data é anterior a data atual
			message << "Hora de início do agendamento inválida" if s_time <= Time.now
			message << "Hora de fim do agendamento inválida" if e_time <= Time.now

			###  Verificar se está em horario comercial
			s_hour = s_time.strftime("%H").to_i
			e_hour = e_time.strftime("%H").to_i
			message << "Hora de início do agendamento fora do horario comercial" if s_hour < 8 or s_hour > 18
			message << "Hora de fim do agendamento fora do horario comercial" if e_hour < 8 or e_hour > 18

			###  Verificar se a hora de inicio é menor que a de fim
			message << "Hora de fim do agendamento maior que a hora de início" if s_time >= e_time

			###  Verificar se está em dia da semana
			message << "Este não é um dia útil" if s_time.on_weekend?

			###  Verificar se agenda para mais de um dia
			message << "Não é permitido agendamento para mais de um dia" if (s_time + 1) <= e_time

			if message != []
				response = {origin: "", message: message, status: 400}
			else
				###  Verifica se o horario está livre
				c_date = DailySchedule.where("('#{s_time}' BETWEEN start_date AND end_date) OR ('#{e_time}' BETWEEN start_date AND 
							end_date) OR (start_date BETWEEN '#{s_time}' and '#{e_time}')").where(meeting_room_id: params['room'])
				if !c_date[0].nil?
					response = {origin: "", message: ["Horario já reservado"] , status: 404}
				else
					###  Horario livre, verificar se existe a sala
					room_l = MeetingRoom.where(id: params['room'].to_i).select(:id, :name, :local)
					if room_l[0].nil?
						response = {origin: "", message: ["Sala não cadastrada"] , status: 404}
					else
						###  Passou na validação, efetuar o agendamento
						room = room_l[0]
						room.daily_schedules.create!(user_id: @current_user.id, subject: @params[:subject],start_date: @params[:start_time], end_date: @params[:end_time])
						response = {origin: "", message: ["Agendamento efetuado com sucesso"], status: 201}
					end
				end
			end

		rescue => error
			Rails.logger.error("\n\n*****  Erro: #{error.inspect}\n")
			response = {origin: "", message: ["Falha no agendamento"], status: 400}
		end

		return_json(response)
	end

	def cancel_schedule
		###  Libera a reserva de uma sala / período
		daily_sch = DailySchedule.find(params['id'])
		if daily_sch['user_id'] != params['user_id'].to_i
			###  Usuário não autorizado
			response = {origin: "", message: "Usuário não autorizado a cancelar o agendamento" , status: 404}
		else
			response = {origin: "", message: "Cancelamento efetuado com sucesso", status: 200}
			DailySchedule.find(params['id']).destroy rescue (response = {origin: "cancel_schedule", message: 
					"Erro no cancelamento de agenda", status: 404})
		end

		return_json(response)
	end

	def list_schedule
		###  Lista as reservas por um ou mais dias úteis.
		if params['room'].nil?
			###  Lista todas as salas
			response = DailySchedule.joins("join users on users.id = daily_schedules.user_id").where("start_date::DATE BETWEEN '#{params['start_date']}' AND '#{params['end_date']}'").select(
				"daily_schedules.id, daily_schedules.meeting_room_id, daily_schedules.subject, daily_schedules.start_date,
				daily_schedules.end_date, users.name").order(:start_date)
		else
			###  Lista somente a sala solicitada
			response = DailySchedule.joins("join users on users.id = daily_schedules.user_id").where(meeting_room_id: params['room']).where("
				start_date::DATE BETWEEN '#{params['start_date']}' AND '#{params['end_date']}'").select(
				"daily_schedules.id, daily_schedules.meeting_room_id, daily_schedules.subject, daily_schedules.start_date,
				daily_schedules.end_date, users.name").order(:start_date)
		end

		return_json(response, 200)
	end

	private

	def validate_params
		@params = params.permit(:room, :subject, :user_id, :start_time, :end_time)
	end

	def validate_user
		###  Validar o usuário e buscar seus os dados
		@current_user = User.find(params[:user_id].to_i) rescue (return_json({origin: "validate_user", 
					message: "Usuario não autorizado", status: 403}))
	end
end
