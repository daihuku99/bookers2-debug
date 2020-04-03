class BookCommentsController < ApplicationController
	before_action :correct_user, only: [:destroy]
	def create
		@book = Book.find(params[:book_id])
		@book_comment = BookComment.new(book_comment_params)
		@book_comment.user_id = current_user.id
		@book_comment.book_id = @book.id
		if @book_comment.save
			redirect_to book_path(@book)
		else
			@book_new = Book.new
    		@user = @book.user
			render 'books/show'
		end
	end

	def destroy
		book = Book.find(params[:book_id])
		book_comment = book.book_comments.find(params[:id])
		book_comment.user_id = current_user.id
		book_comment.destroy
		redirect_to book_path(book)
	end

	def correct_user
		book = Book.find(params[:book_id])
		book_comment = book.book_comments.find(params[:id])
		if book_comment.user_id != current_user.id
			redirect_to book_path(@book)
		end
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
