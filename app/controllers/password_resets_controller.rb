class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # (1) への対応

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "パスワード再設定用のリンクを送りました"
      redirect_to root_path
    else
      flash[:danger] = "そのメールアドレスは登録されていません"
      render "new"

    end

  end

  def edit
  end

  def update
   if params[:user][:password].empty?
     @user.errors.add(:password, :blank)
     render "edit"
   elsif @user.update_attribute(user_params)
    log_in @user
    flash[:success] = "パスワードの再設定完了したよ"
    redirect_to @user
   else
    render "edit"
   end

  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end


    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end

  

end
