require 'rails_helper'
	begin
	  require "meeting_room_controller"
	rescue LoadError
	end

	RSpec.describe MeetingRoomsController, type: :controller do

	    let(:valid_session) { {} }

	    describe "Validate MeetingRoom" do
	        it "creates a new meeting_room" do
    	      user = User.create!(name: "User 19999")
	          expect {
	            post :new, params: {user_id: user.id, name: "sala 2", local: "predio 1"}, session: valid_session
	          }.to change(MeetingRoom, :count).by(1)
	  	      expect(response).to have_http_status(201)
	        end

	        it "creates a duplicate meeting_room" do
    	      user = User.create!(name: "User 19999")
		      @meeting_room = MeetingRoom.create!(user_id: user.id, name: "sala 1", local: "predio 1")
	          expect {
	            post :new, params: {user_id: user.id, name: "sala 1", local: "predio 1"}, session: valid_session
	          }.to change(MeetingRoom, :count).by(0)
	  	      expect(response).to have_http_status(404)
	        end

	        it "check invalid user_id" do
	          expect {
	            post :new, params: {user_id: 999999, name: "sala 1", local: "predio 1"}, session: valid_session
	          }.to change(MeetingRoom, :count).by(0)
	  	      expect(response).to have_http_status(403)
	        end

	        it "check invalid parameters" do
    	      user = User.create!(name: "User 19999")
	          expect {
	            post :new, params: {user_id: user.id, name_x: "sala 1", local: "predio 1"}, session: valid_session
	          }.to change(MeetingRoom, :count).by(0)
	  	      expect(response).to have_http_status(404)
	        end

	        it "check null parameters" do
    	      user = User.create!(name: "User 19999")
	          expect {
	            post :new, params: {user_id: user.id, name: "", local: "predio 1"}, session: valid_session
	          }.to change(MeetingRoom, :count).by(0)
	  	      expect(response).to have_http_status(404)
	        end
		end

	    describe "GET show" do
	      it "get data fom a room" do
    	    user = User.create!(name: "User 19")
		    @meeting_room = MeetingRoom.create!(user_id: user.id, name: "sala 1", local: "predio 12")
	        get :show, params: {room: @meeting_room.id}, session: valid_session
 	        expect(response).to have_http_status(200)
	      end

	      it "search for invalid room" do
	        get :show, params: {room: 0}, session: valid_session
 	        expect(response).to have_http_status(404)
	      end
	    end

	    describe "GET search_by_name" do
	      it "search room by name" do
    	    user = User.create!(name: "User 19")
		    meeting_room = MeetingRoom.create!(user_id: user.id, name: "sala 1", local: "predio 12")
	        get :search_by_name, params: {by_name: 'sa'}, session: valid_session
 	        expect(response).to have_http_status(200)
	      end

	      it "assigns the requested to not find a meeting_room" do
	        get :search_by_name, params: {by_name: 'room'}, session: valid_session
 	        expect(response).to have_http_status(404)
	      end
	    end

	    describe "DELETE" do
	      it "Delete room" do
    	    user = User.create!(name: "User 19")
		    meeting_room = MeetingRoom.create!(user_id: user.id, name: "sala 1", local: "predio 12")
	        delete :delete, params: {room: meeting_room.id}, session: valid_session
 	        expect(response).to have_http_status(200)

	        get :search_by_name, params: {room: meeting_room.id}, session: valid_session
 	        expect(response).to have_http_status(404)
	      end
	    end
	end
