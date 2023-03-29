# frozen_string_literal: true

module Web
  class BulletinsController < ApplicationController
    before_action :authenticate_user!, only: %i[new edit create update destroy archive to_moderate]
    before_action :set_bulletin, only: %i[show edit update destroy archive to_moderate]

    def index
      authorize Bulletin

      @q = Bulletin.published.ransack(params[:q])
      @bulletins = @q.result.order(updated_at: :desc).page(params[:page]).per(16)
    end

    def show; end

    def new
      @bulletin = Bulletin.new
      authorize @bulletin
    end

    def edit; end

    def create
      resize_uploaded_image

      @bulletin = current_user.bulletins.new(bulletin_params)
      authorize @bulletin

      if @bulletin.save
        redirect_to bulletin_url(@bulletin), notice: t('.success')
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      resize_uploaded_image

      if @bulletin.update(bulletin_params)
        redirect_to profile_path, notice: t('.success')
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @bulletin.destroy

      redirect_to bulletins_url, status: :see_other, notice: t('.success')
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

    def resize_uploaded_image
      return unless bulletin_params[:image]

      path = bulletin_params[:image].tempfile.path
      ImageProcessing::MiniMagick.source(path)
                                 .resize_to_limit(1200, 1200)
                                 .call(destination: path)
    end
  end
end
