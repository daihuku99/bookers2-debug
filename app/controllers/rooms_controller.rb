class RoomsController < ApplicationController

	def create
		user = User.find(params[:user_id])
		# room_num = user.rooms.pluck(:id)
		# my_room_num = current_user.rooms.pluck(:id)
		same_room = user.rooms & current_user.rooms
		if same_room == []
			@room = Room.new
			@room.save
			current_user.user_rooms.create(room_id: @room.id)
			user.user_rooms.create(room_id: @room.id)
		else
			@room = same_room[0]
		end
		redirect_to user_room_path(user, @room)
	end

	def show
		@room = Room.find(params[:id])
		@user = User.find(params[:user_id])
		@users = @room.users
		@chats = @room.chats
	end

	# private
	# def room_params
	# 	params.require(:room).permit(:name)
	# end
end
