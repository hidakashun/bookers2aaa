class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :visitor_id, null: false#通知を送ったユーザー
      t.integer :visited_id, null: false#通知を送られたユーザー
      t.integer :book_id#投稿
      t.integer :comment_id#コメント
      t.integer :favorite_id#いいね
      t.string :action, null: false, default: ''
      t.boolean :is_checked, null: false, default: false

      t.timestamps
    end
  end
end