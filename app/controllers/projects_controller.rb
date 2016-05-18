class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :filter_invalid_platforms, only: [:create]

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

  def filter_invalid_platforms
    # collection_check_boxes will generate an empty item,
    # so the received params are like ['', 'web', 'android']
    # see also https://github.com/rails/rails/issues/12605

    params.require(:project)[:platforms].select!(&:present?)
  end

  def project_params
    # permit params
    params.require(:project).permit(
      :name,
      :git_repo_path,
      :platforms => []
    )
  end

end
