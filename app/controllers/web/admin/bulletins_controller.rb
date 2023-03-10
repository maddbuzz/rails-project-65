# frozen_string_literal: true

module Web
  module Admin
    class BulletinsController < Web::Admin::ApplicationController
      before_action :set_bulletin, only: %i[archive publish reject]

      def index_under_moderation
        @bulletins = Bulletin.under_moderation.order(updated_at: :desc)
      end

      def index
        @q = Bulletin.ransack(params[:q])
        @bulletins = @q.result.order(updated_at: :desc)
      end

      def archive
        return unless @bulletin.may_archive?

        @bulletin.archive!
        # redirect_to admin_path, notice: t('.success')
        redirect_back fallback_location: admin_path, notice: t('.success')
      end

      def publish
        return unless @bulletin.may_publish?

        @bulletin.publish!
        redirect_to admin_path, notice: t('.success')
      end

      def reject
        return unless @bulletin.may_reject?

        @bulletin.reject!
        redirect_to admin_path, notice: t('.success')
      end

      private

      def set_bulletin
        @bulletin = Bulletin.find(params[:id])
        # authorize @bulletin
      end
    end
  end
end
