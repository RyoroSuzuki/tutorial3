class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  
  def index
    @users = User.paginate(page: params[:page])
  end


  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])

  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "アカウントの作成（仮）完了したよ"
      redirect_to user_path(@user.id)

    else
      render "new"
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "profile updated"
      render "edit"
    else
      render "edit"
    end
  end

    def destroy
      User.find_by(id:params[:id]).destroy
      flash[:success] = "消したよユーザー"
      redirect_to users_path
    end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてね"
        redirect_to login_path
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_path unless currentt_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

end
