class TechniquesController < ApplicationController
  before_action :set_technique, only: [ :show, :edit, :update, :destroy ]

  def index
    scope = Technique.includes(:tags)
    scope = scope.search(params[:q]) if params[:q].present?
    @techniques = scope
  end

  def show
  end

  def new
    @technique = Technique.new
  end

  def create
    @technique = Technique.new(technique_params)
    if @technique.save
      redirect_to @technique, notice: "Technique created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @technique.update(technique_params)
      redirect_to @technique, notice: "Technique updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @technique.destroy
    redirect_to techniques_path, notice: "Technique deleted."
  end

  private

  def set_technique
    @technique = Technique.includes(
      :aliases,
      :tags,
      :resources,
      starting_position_variants: :position,
      ending_position_variants: :position
    ).find(params[:id])
  end

  def technique_params
    params.require(:technique).permit(:name, :description, :technique_type, :gi_nogi)
  end
end
