class Favorite < ApplicationRecord
  #いいね機能
  belongs_to :user
  belongs_to :book
  validates_uniqueness_of :book_id, scope: :user_id
  #user_id という範囲内で
  #あるbook_idに対して、1つだけfavoriteの値を保存することができる
  #=> 1ユーザーが 1投稿に対して 1つだけ いいねデータを保存できる。
end
