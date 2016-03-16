class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_extra_params, only: [:create]

  def show
    @project = current_user.projects.find params[:id]
  end

  def index
    @projects = current_user.projects.order created_at: :desc
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new project_params
    if @project.save
      # TODO flash
      redirect_to project_path @project
    else
      # TODO flash
    end
  end

  private

  def set_extra_params
    # set platforms
    # TODO support more platforms
    params.require(:project)[:platforms] = ['web']

    # set source_type
    params.require(:project)[:source_type] = 'github'
  end

  def project_params
    # permit params
    params.require(:project).permit(
      :name,
      :source_type,
      :github_repo_path,
      :platforms => []
    )
  end

end
