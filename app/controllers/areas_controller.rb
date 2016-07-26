class AreasController < ApplicationController

  def index
    render json: Area.all
  end

  def new
    @area = Area.new
  end

  def create
    @area = Area.create(area_params)
    redirect_to rooms_path(area: @area.id)
  end

  private

  def area_params
    params.require(:area).permit(:name)
  end

end