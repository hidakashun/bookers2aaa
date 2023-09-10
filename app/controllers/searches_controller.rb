class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    #このコードで検索フォームからの情報を受け取っている。
    @model = params[:model]#検索モデル→params[:model]
    @content = params[:content]#検索ワード→params[:content]
    @method = params[:method]#検索方法→params[:method]

    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
    end
  end

end