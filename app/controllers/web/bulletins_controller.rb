# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, except: %i[index show]
    before_action :set_bulletin, only: %i[show edit update destroy archive to_moderate]

    def index
      authorize Bulletin

      @q = Bulletin.published.ransack(params[:q])
      @bulletins = @q.result.order(updated_at: :desc)
    end

    def show; end

    def new
      @bulletin = Bulletin.new
      authorize @bulletin
    end

    def edit; end

    def create
      @bulletin = current_user.bulletins.new(bulletin_params)
      authorize @bulletin

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
          # format.html { redirect_to bulletin_url(@bulletin), notice: t('.success') }
          format.html { redirect_to profile_path, notice: t('.success') }
          # redirect_back fallback_location: bulletin_url(@bulletin)
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @bulletin.destroy

      respond_to do |format|
        format.html { redirect_to bulletins_url, status: :see_other, notice: t('.success') }
      end
    end

    def archive
      return unless @bulletin.may_archive?

      @bulletin.archive!
      redirect_to profile_path, notice: t('.success')
    end

    def to_moderate
      return unless @bulletin.may_to_moderate?

      @bulletin.to_moderate!
      redirect_to profile_path, notice: t('.success')
    end

    private

    def set_bulletin
      @bulletin = Bulletin.find(params[:id])
      authorize @bulletin
    end

    def bulletin_params
      params.require(:bulletin).permit(:title, :description, :image, :category_id)
    end
  end
end
