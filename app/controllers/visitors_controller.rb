class VisitorsController < ApplicationController

  skip_before_action :authenticate_user!
  add_breadcrumb 'Visitors'

  def index
  end

  def new
    add_breadcrumb 'New'
  end

  def submit
    @country = params[:visitor].try(:[], :country)
    @city = params[:visitor].try(:[], :city)
    @ip_country = request.location.country

    respond_to do |format|
      if @country.present? && @city.present?
        format.html { render :index }
      else
        format.html {
          redirect_to new_visitor_path,
          alert: 'Please select your country and city'
        }
      end
    end
  end

  def cities
    render json: City.by_country(params[:country]).to_json
  end
end
