#ユーザ同士で 1 対 1 の DM ができるようにする
class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  #空でない＆最大１４０文字以下であるバリデーションも追加しておく！
  validates :message, presence: true, length: { maximum: 140 }
end
