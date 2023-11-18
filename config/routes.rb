Rails.application.routes.draw do
  devise_for :users

  root :to =>"homes#top"
  get "home/about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    #コメント機能
    resources :book_comments, only: [:create, :destroy]
    #コメントは、投稿bookに対してコメントされるため、以下のように親子関係になる！

    #いいね機能
    resource :favorites, only: [:create, :destroy]
    #いいねは、投稿bookに対していいねされるため、以下のように親子関係になる！
    #resourceとなっている点
    #単数形にすると、/:idがURLに含まれなくなる。
    #いいね機能の場合は「1人のユーザーは1つの投稿に対して1回しかいいねできない」という仕様であるため、destroyをする際にもユーザーidと投稿(post_image)idが分かれば、どのいいねを削除すればいいのかが特定できる。
    #そのため、URLに/:idを含めない形にしている！！
  end
  resources :users, only: [:index,:show,:edit,:update] do

    #Userと、Relationshipは関連づけられているためuserのidが必要
    #relationshipsをネストする
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
        #指定した日の記録(投稿数)を非同期で表示する
    get "daily_posts" => "users#daily_posts"
  end
    #検索機能
    get '/search', to: 'searches#search'

    #ユーザ同士で 1 対 1 の DM ができるようにする
    resources :chats, only: [:show, :create]
end