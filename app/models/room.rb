#ユーザ同士で 1 対 1 の DM ができるようにする
class Room < ApplicationRecord
  has_many :user_rooms
  has_many :chats
end
