# frozen_string_literal: true

module Web
  module Admin
    class UsersController < Web::Admin::ApplicationController
      before_action :set_user, only: %i[edit update destroy]

      def index
        @users = User.page(params[:page])
        @user_bulletins_counts = Bulletin.group(:user).count
      end

      def edit; end

      def update
        if @user.update(user_params)
          redirect_to admin_users_url, notice: t('.success')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @user.destroy
          redirect_to admin_users_url, status: :see_other, notice: t('.success')
        else
          redirect_to admin_users_url, alert: t('.fail')
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :email, :admin)
      end
    end
  end
end
