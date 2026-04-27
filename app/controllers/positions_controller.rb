class PositionsController < ApplicationController
  before_action :set_position, only: [ :show, :edit, :update, :destroy ]

  def index
    scope = Position.includes(:variants).all
    scope = scope.search(params[:q]) if params[:q].present?
    @positions = scope
  end

  def show
  end

  def new
    @position = Position.new
  end

  def create
    @position = Position.new(position_params)
    if @position.save
      redirect_to @position, notice: "Position created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @position.update(position_params)
      redirect_to @position, notice: "Position updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @position.destroy
    redirect_to positions_path, notice: "Position deleted."
  end

  private

  def set_position
    @position = Position.includes(:aliases, variants: [ :aliases, :available_techniques ]).find(params[:id])
  end

  def position_params
    params.require(:position).permit(:name, :description, :category)
  end
end
