class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  #いいね機能
  has_many :favorites, dependent: :destroy

  #コメント機能
  has_many :book_comments, dependent: :destroy

  #ページの閲覧数をカウントし、投稿一覧、投稿詳細に表示させる
  has_many :view_counts, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
  #favorited_by?メソッド
  #このメソッドで、引数で渡されたユーザidがFavoritesテーブル内に存在（exists?）するかどうかを調べます。

  #本の投稿一覧ページで、過去一週間でいいねの合計カウントが多い順に投稿を表示#ここから
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  #belongs_to :user
  #has_many :favorites, dependent: :destroy
  #ここまで

  #検索機能、条件分岐
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

end
