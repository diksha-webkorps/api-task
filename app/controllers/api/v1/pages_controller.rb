# frozen_string_literal: true

module Api
  module V1
    # Pages Controller
    class PagesController < Api::V1::BaseController
      use Rack::Attack
      before_action :set_page, only: %i[show update destroy]

      def index
        pages = Page.all
        total_records = pages.size
        unless params['search_term'].nil?
          search_key = '%'+ params['search_term'].downcase+'%'
          pages = pages.where('( LOWER(pages.name) like ?) ', search_key)
        end
        pages = pages.paginate(page: params[:page], per_page: 10).order('id DESC') if params[:page].present?
        render json: { success: true, status: 200, total_records: total_records, pages: pages }
      end

      def show
        render json: @page, status: 200
      end

      def create
        @page = Page.new(page_params)

        if @page.save
          render json: @page, status: :created
        else
          render json: @page.errors, status: :unprocessable_entity
        end
      end

      def update
        if @page.update(page_params)
          render json: @page, status: 200
        else
          render json: @page.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @page.destroy
        render json: @page, status: 200
      end

      private

      def set_page
        @page = Page.find(params[:id])
      end

      def page_params
        params.require(:page).permit(:name, :description, :price)
      end
    end
  end
end
