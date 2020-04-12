class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :searches, dependent: :destroy
  has_many :user_rooms #中間テーブルのアソシエーション
  has_many :rooms, through: :user_rooms #user_roomを通してroomを取得
  has_many :chats, through: :user_rooms #user_roomを通してchatを取得
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy #userとfollower(フォローする人)を結びつける。follower_idにuser_idを格納する宣言
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy #userとfollowed(フォローされる人)を結びつける。followed_idにuser_idを格納する宣言
  has_many :following_user, through: :follower, source: :followed #上で取得したfollowedをもとにfollowerを通じてUserモデルからfollowing_userを取得する
  has_many :follower_user, through: :followed, source: :follower #上で取得したfollowerをもとにfollowedを通じてUserモデルからfollower_userを取得する
  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, presence: true, length: {maximum: 20, minimum: 2 }
  validates :introduction, length: {maximum: 50 }

  def follow(user_id) #メソッド使用時に引数を使用するので引数を記述
    follower.create(followed_id: user_id) #followed_idカラムにuser_idを格納して保存
  end

  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy #followed_idカラムに特定のuser_idが格納されてるfollowerを探してきて削除
  end

  def following?(user)
    following_user.include?(user)
  end

  def User.search(search, user_or_book, how_search)
    if user_or_book == "1"
      if how_search == "1"
        User.where(['name LIKE?', "%#{search}%"])
      elsif how_search == "2"
        User.where(['name LIKE?', "%#{search}"])
      elsif how_search == "3"
        User.where(['name LIKE?', "#{search}%"])
      elsif how_search == "4"
        User.where(['name LIKE?', "#{search}"])
      else
        User.all
      end
    end
  end

  # include JpPrefecture
  # jp_prefecture :prefecture_code

  # def prefecture_name
  #   JpPrefecture::Prefecture.find(code: prefecture_code).try(:name)
  # end

  # def prefecture_name=(prefecture_name)
  #   self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  # end

  def address
    [address_city, address_street].compact.join(',')
  end

  # after_create :thanks_email

  # def send_thanks_email
  #   ThanksMailer.thanks_email(self).deliver
  # end

  # geocoded_by :address, latitude: :lat, longitude: :lng


end
