Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

	post 'meeting_rooms/new', to: 'meeting_rooms#new'
	get 'meeting_rooms/show', to: 'meeting_rooms#show'
	get 'meeting_rooms/search_by_name', to: 'meeting_rooms#search_by_name'
	get 'meeting_rooms/list_all', to: 'meeting_rooms#list_all'
	delete 'meeting_room', to: 'meeting_rooms#delete'

	post '/daily_schedules/new', to: 'daily_schedule#new'
	get '/daily_schedules/list_schedule', to: 'daily_schedule#list_schedule'
	delete '/daily_schedules', to: 'daily_schedule#cancel_schedule'
end
