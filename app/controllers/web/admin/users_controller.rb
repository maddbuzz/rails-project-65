# frozen_string_literal: true

module Web
  module Admin
    class UsersController < Web::Admin::ApplicationController
      before_action :set_user, only: %i[edit update destroy]

      def index
        @users = User.all.page params[:page]
      end

      # def new
      #   @user = User.new
      # end

      def edit; end

      # def create
      #   @user = User.new(user_params)

      #   respond_to do |format|
      #     if @user.save
      #       format.html { redirect_to admin_users_url, notice: t('.success') }
      #     else
      #       format.html { render :new, status: :unprocessable_entity }
      #     end
      #   end
      # end

      def update
        respond_to do |format|
          if @user.update(user_params)
            format.html { redirect_to admin_users_url, notice: t('.success') }
          else
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        respond_to do |format|
          if @user.destroy
            format.html { redirect_to admin_users_url, status: :see_other, notice: t('.success') }
          else
            format.html { redirect_to admin_users_url, alert: t('.fail') }
          end
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
