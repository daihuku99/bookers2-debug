class UsersController < ApplicationController
  before_action :authenticate_user!
	before_action :baria_user, only: [:update, :edit]
  # geocoded_by :address
  # after_validation :geocode

  def show
  	@user = User.find(params[:id])
  	@books = @user.books
  	@book_new = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
    results = Geocoder.search(@user.address)
    @latlng = results.first.coordinates
  end

  def index
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book_new = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
    @user = current_user
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
    # byebug
  	if @user.update(user_params)
  		redirect_to user_path(@user), notice: "successfully updated user!"
  	else
      # @books = @user.books
      # @book_new = Book.new
  		render :edit
  	end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following_user
  end

  def follower
    @user = User.find(params[:id])
    @users = @user.follower_user
  end

  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image, :postcode, :address_city, :address_street, :address_building)
  end

  #url直接防止　メソッドを自己定義してbefore_actionで発動。
   def baria_user
  	unless params[:id].to_i == current_user.id
  		redirect_to user_path(current_user)
  	end
   end

end
