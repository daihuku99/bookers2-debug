class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :book_comments, dependent: :destroy
	has_many :searchse, dependent: :destroy
	#バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
	#presence trueは空欄の場合を意味する。
	validates :title, presence: true, length: {maximum: 200 }
	validates :body, presence: true, length: {maximum: 200 }

	def favorited_by?(user) #メソッド使用時に引数を使用するので引数を記述
		favorites.where(user_id: user.id).exists? #user_idカラムにcurent_user_idが格納されているfavoriteが存在するかどうか
	end

	def Book.search(search, user_or_book, how_search)
		if user_or_book == "2"
			if how_search == "1"
				Book.where(['title LIKE?', "%#{search}%"])
			elsif how_search == "2"
				Book.where(['title LIKE?', "%#{search}"])
			elsif how_search == "3"
				Book.where(['title LIKE?', "#{search}%"])
			elsif how_search == "4"
				Book.where(['title LIKE?', "#{search}"])
			else
				Book.all
			end
		end
	end
end
