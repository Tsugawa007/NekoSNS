class PostsController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_correct_user,{only: [:edit,:update,:destroy]}

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
    @post = Post.find_by(id: params[:id])
    @user = @post.user
    @likes_count = Like.where(post_id: @post.id).count
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id,
      post_name: "default_post.jpg"
      )
    if params[:image]
      #Userの名前入れる
      @post.post_name = "#{@current_user.name}_#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/post_images/#{@post.post_name}",image.read)
    end

    if @post.save
      body = File.open("public/post_images/#{@post.post_name}", 'r') { |io| io.read }
      neko = Utils::NekoApi.new(body)
      if neko.ans == 0
        flash[:notice] = "投稿を作成しました"
        redirect_to("/posts/index") 
      elsif neko.ans == 1
        flash[:notice] = "不適切な写真です"
        render("posts/new")
      else neko.ans == 2
        flash[:notice] = "写真の中に猫がいません"
        render("posts/new")
      end
    else
      flash[:notice] = "猫が含まれていません"
      render("posts/new")
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
  end

  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if params[:image]
      #Userの名前入れる
      @post.post_name = "#{@post.id}.jpg"
      image = params[:image]
      File.binwrite("public/post_images/#{@post.post_name}",image.read)
    end

    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end

  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
