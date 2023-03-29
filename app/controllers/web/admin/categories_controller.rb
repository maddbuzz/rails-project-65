# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      before_action :set_category, only: %i[edit update destroy]

      def index
        @categories = Category.page(params[:page])
        @category_bulletins_counts = Bulletin.group(:category).count
      end

      def new
        @category = Category.new
      end

      def edit; end

      def create
        @category = Category.new(category_params)

        if @category.save
          redirect_to admin_categories_url, notice: t('.success')
        else
          render :new, status: :unprocessable_entity
        end
      end

      def update
        if @category.update(category_params)
          redirect_to admin_categories_url, notice: t('.success')
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @category.destroy
          redirect_to admin_categories_url, status: :see_other, notice: t('.success')
        else
          redirect_to admin_categories_url, alert: t('.fail')
        end
      end

      private

      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
