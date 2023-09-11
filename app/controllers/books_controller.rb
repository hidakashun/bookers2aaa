class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new#いらない？
    @book_comment = BookComment.new
  end

  def index
    #本の投稿一覧ページで、過去一週間でいいねの合計カウントが多い順に投稿を表示
    to  = Time.current.at_end_of_day
    #現在の日時を表す Time.current を当日の終わりの時間に設定。
    #at_end_of_day は ActiveSupport::TimeWithZone クラスのメソッドで、その日の終わりを表す時刻（23:59:59.999999）を返している。
    from  = (to - 6.day).at_beginning_of_day
    #at_beginning_of_day　は1日の始まりの時刻を0:00に設定している。
    @books = Book.all.sort {|a,b|
      b.favorites.where(created_at: from...to).size <=>
      a.favorites.where(created_at: from...to).size
    }
    #ここまで
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
      unless @book.user == current_user
        redirect_to books_path
      end
  end
end
