module Response

	def return_json(resource, status = nil)
		###  Rotina de envio de mensagem
		if resource.class != Hash
			render json: resource, status: status
		else
	        Rails.logger.info("\n\n*****  MeetingRoomsController/#{origem} - #{message}\n") if resource[:origem] == ""
			render :json => resource[:message] , status: resource[:status]
		end
	end
end