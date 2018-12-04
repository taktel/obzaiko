class UsersController < ApplicationController
  before_action :require_user_logged_in

  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:user][:old_password])
      if @user.update(user_params)
        flash[:success] = 'ユーザ名が更新されました。'
        redirect_to @user
      else
        flash.now[:danger] = '更新に失敗しました。'
        render :edit
      end
    else
      flash.now[:danger] = 'パスワードが一致しません。'
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    flash[:success] = 'ユーザは正常に削除されました。'
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end
