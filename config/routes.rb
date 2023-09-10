Rails.application.routes.draw do
  devise_for :users

  root :to =>"homes#top"
  get 'home/about' => 'homes#about', as: 'about'

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    #いいね機能
    resource :favorites, only: [:create, :destroy]
    #resourceとなっている点
    #単数形にすると、/:idがURLに含まれなくなる。
    #いいね機能の場合は「1人のユーザーは1つの投稿に対して1回しかいいねできない」という仕様であるため、destroyをする際にもユーザーidと投稿(post_image)idが分かれば、どのいいねを削除すればいいのかが特定できる。
    #そのため、URLに/:idを含めない形にしている！！
  end


  resources :users, only: [:index,:show,:edit,:update]


end
