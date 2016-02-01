class ProjectsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @project = current_user.projects.find params[:id]
  end

  def index
    @projects = current_user.projects
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

  def project_params
    # TODO handle platforms

    # set default params
    params.require(:project)[:source_type] = 'github'

    # permit params
    params.require(:project).permit(
      :name,
      :source_type,
      :github_repo_path
    )
  end

end
