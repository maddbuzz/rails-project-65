# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_bulletin, only: %i[show edit update destroy]

    def index
      @bulletins = Bulletin.order(created_at: :desc)
    end

    def show; end

    def new
      @bulletin = Bulletin.new
    end

    def edit; end

    def create
      @bulletin = current_user.bulletins.new(bulletin_params)

      respond_to do |format|
        if @bulletin.save
          format.html { redirect_to bulletin_url(@bulletin), notice: t('.success') }
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @bulletin.update(bulletin_params)
          format.html { redirect_to bulletin_url(@bulletin), notice: t('.success') }
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @bulletin.destroy

      respond_to do |format|
        format.html { redirect_to bulletins_url, notice: t('.success') }
      end
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :image, :category_id)
    end
  end
end
