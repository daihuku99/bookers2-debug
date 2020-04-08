class ChatController < ApplicationController
  def show
  	@room = Room.find(params[:id])
  	@user = @room.user
  	@contents = @room.contents
  end
end
