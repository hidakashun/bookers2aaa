#ユーザ同士で 1 対 1 の DM ができるようにする
class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
end
