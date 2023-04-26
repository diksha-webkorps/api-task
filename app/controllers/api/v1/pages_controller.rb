class Api::V1::PagesController < Api::V1::BaseController
    before_action :set_page, only: [:show, :update, :destroy]
    def index
        pages = Page.all
        total_records = pages.size
        if !params['search_term'].nil?
          searchKey = '%'+ params['search_term'].downcase+'%'
          pages = pages.where('( LOWER(pages.name) like ?) ', searchKey)
        end
        pages = pages.paginate(:page => params[:page], per_page:10).order('id DESC') if params[:page].present?
        render json: pages, status: 200
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

    def activate_all
        Page.update_all(active: true)
        render json: @page, status: 200
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
