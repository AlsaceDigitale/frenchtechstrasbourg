class StartupsController < ApplicationController
  def index
    @startups = Startup.is_published.all
    respond_to do |format|
      format.html
      format.json {
        grouped_startups = @startups.group_by(&:coordinates).map do |coordinates, startups| {
          lat: coordinates.first,
          lng: coordinates.last,
          startups:startups.map do |s|
            {
              name: s.name,
              description: s.description(I18n.locale),
              address: s.address,
              url: s.url
            }
          end
        }
      end
      render :json => grouped_startups.to_json
      }
      format.rss { render :layout => false }
    end
  end

  def new
  	@startup = Startup.new
  end

  def create
  	@startup = Startup.new create_params

  	if @startup.save
  		render :action => "thanks"
  	else
  		render :action => "new"
  	end
  end

  def show
    @startup = Startup.find(params[:id])
    @page_title = @startup.name
  end

  protected

  def create_params
  	params.require(:startup).permit(:name, :url, :street, :zip_code, :city, :email, :description_fr, :description_en, :logo)
  end
end
