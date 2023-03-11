# frozen_string_literal: true

module Web
  module Admin
    class CategoriesController < Web::Admin::ApplicationController
      before_action :set_category, only: %i[edit update destroy]

      def index
        @categories = Category.all.page params[:page]
        @category_bulletins_counts = Bulletin.group(:category).count
      end

      def new
        @category = Category.new
      end

      def edit; end

      def create
        @category = Category.new(category_params)

        respond_to do |format|
          if @category.save
            format.html { redirect_to admin_categories_url, notice: t('.success') }
          else
            format.html { render :new, status: :unprocessable_entity }
          end
        end
      end

      def update
        respond_to do |format|
          if @category.update(category_params)
            format.html { redirect_to admin_categories_url, notice: t('.success') }
          else
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        respond_to do |format|
          if @category.destroy
            format.html { redirect_to admin_categories_url, status: :see_other, notice: t('.success') }
          else
            format.html { redirect_to admin_categories_url, alert: t('.fail') }
          end
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
