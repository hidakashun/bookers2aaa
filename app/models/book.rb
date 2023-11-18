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

  #ここから本の投稿一覧ページで、過去一週間でいいねの合計カウントが多い順に投稿を表示
  has_many :week_favorites, -> { where(created_at: ((Time.current.at_end_of_day - 6.day).at_beginning_of_day)..(Time.current.at_end_of_day)) }, class_name: 'Favorite'
  #belongs_to :user
  #has_many :favorites, dependent: :destroy
  #ここまで

  #ここから投稿数の前日比/前週比を表示
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } # 前週
  #ここまで

  #ここからchart.jsを使って過去7日分の投稿数をグラフ化する
  #scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  #scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
  scope :created_2day_ago, -> { where(created_at: 2.day.ago.all_day) } # 2日前
  scope :created_3day_ago, -> { where(created_at: 3.day.ago.all_day) } # 3日前
  scope :created_4day_ago, -> { where(created_at: 4.day.ago.all_day) } # 4日前
  scope :created_5day_ago, -> { where(created_at: 5.day.ago.all_day) } # 5日前
  scope :created_6day_ago, -> { where(created_at: 6.day.ago.all_day) } # 6日前
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
