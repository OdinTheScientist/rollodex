class ResourcesController < ApplicationController
  before_action :set_resource, only: [ :show, :edit, :update, :destroy ]

  def index
    scope = Resource.includes(:techniques, :positions).order(:title)
    scope = scope.where("title ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    @resources = scope
  end

  def show
  end

  def new
    @resource = Resource.new
    @preselected_technique_ids = [ params[:technique_id] ].compact.map(&:to_i)
    @preselected_position_ids  = [ params[:position_id] ].compact.map(&:to_i)
    @techniques = Technique.all.order(:name)
    @positions  = Position.all.order(:name)
  end

  def create
    @resource = Resource.new(resource_params)
    if @resource.save
      create_associations
      redirect_to @resource, notice: "Resource created successfully."
    else
      @preselected_technique_ids = technique_ids_from_params
      @preselected_position_ids  = position_ids_from_params
      @techniques = Technique.all.order(:name)
      @positions  = Position.all.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @techniques = Technique.all.order(:name)
    @positions  = Position.all.order(:name)
  end

  def update
    if @resource.update(resource_params)
      @resource.resource_techniques.destroy_all
      @resource.resource_positions.destroy_all
      create_associations
      redirect_to @resource, notice: "Resource updated successfully."
    else
      @techniques = Technique.all.order(:name)
      @positions  = Position.all.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @resource.destroy
    redirect_to resources_path, notice: "Resource deleted."
  end

  private

  def set_resource
    @resource = Resource.includes(:techniques, :positions).find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(:title, :url, :resource_type, :instructor_name, :notes, :foundational)
  end

  def technique_ids_from_params
    Array(params.dig(:resource, :technique_ids)).reject(&:blank?).map(&:to_i)
  end

  def position_ids_from_params
    Array(params.dig(:resource, :position_ids)).reject(&:blank?).map(&:to_i)
  end

  def create_associations
    technique_ids_from_params.each do |tid|
      ResourceTechnique.find_or_create_by!(resource: @resource, technique_id: tid)
    end
    position_ids_from_params.each do |pid|
      ResourcePosition.find_or_create_by!(resource: @resource, position_id: pid)
    end
  end
end
