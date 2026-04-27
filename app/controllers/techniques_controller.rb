class TechniquesController < ApplicationController
  def index
    scope = Technique.all
    scope = scope.search(params[:q]) if params[:q].present?
    @techniques = scope
  end

  def show
  end

  def new
  end

  def edit
  end
end
