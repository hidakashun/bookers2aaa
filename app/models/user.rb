class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  #ユーザ同士で 1 対 1 の DM ができるようにする
  has_many :user_rooms
  has_many :chats
  has_many :rooms, through: :user_rooms

  #ページの閲覧数をカウントし、投稿一覧、投稿詳細に表示させる
  has_many :view_counts, dependent: :destroy

  #いいね機能
  has_many :favorites, dependent: :destroy

  #コメント機能
  has_many :book_comments, dependent: :destroy
  #フォロー,フォロワー機能
  # 自分がフォローされる（被フォロー）側の関係性
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 被フォロー関係を通じて参照→自分をフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # 自分がフォローする（与フォロー）側の関係性
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # 与フォロー関係を通じて参照→自分がフォローしている人
  has_many :followings, through: :relationships, source: :followed
  #　フォローしたときの処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end
  #　フォローを外すときの処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end
  #フォローしていればtrueを返す
  def following?(user)
    followings.include?(user)
  end

  has_one_attached :profile_image
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  #検索機能、条件分岐
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      User.where('name LIKE ?', '%' + content)
    else
      User.where('name LIKE ?', '%' + content + '%')
    end
  end

  #本の投稿一覧ページで、過去一週間でいいねの合計カウントが多い順に投稿を表示(今回はすでに実装済みのためコメントアウトして表示)
  #has_many :books, dependent: :destroy
  #has_many :favorites, dependent: :destroy

end