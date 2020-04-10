class BooksController < ApplicationController
  before_action :authenticate_user! #ログインしていないユーザーをルートパスへ飛ばす
  before_action :correct_user, only: [:edit, :update, :delete] #current_userのみ使用できるアクション

  def show
  	@book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user #Book.find(params[:id])の@book.idがついた@user
    @book_comment = BookComment.new
  end

  def index
  	@books = Book.all #一覧表示するためにBookモデルの情報を全てくださいのall
    @book_new = Book.new
    @user = current_user
  end

  def create
  	@book_new = Book.new(book_params)
    @book_new.user_id = current_user.id #@book_newのuser_idにcurrent_user.idを入れる
    # byebug #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
  	if @book_new.save #入力されたデータをdbに保存する。
  		redirect_to book_path(@book_new), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
  		@books = Book.all
      @user = current_user
  		render :index
  	end
  end

  def edit
  	@book = Book.find(params[:id])
  end



  def update
  	@book = Book.find(params[:id])
  	if @book.update(book_params)
  		redirect_to book_path(@book), notice: "successfully updated book!"
  	else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
  		render :edit
  	end
  end

  def delete
  	@book = Book.find(params[:id])
  	@book.destoy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  def correct_user #@book.user.idがcurrent_user.idではない場合、一覧ページに飛ばす
      @book = Book.find(params[:id])
        if @book.user.id != current_user.id
          redirect_to books_path
        end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

end
