class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :filter_invalid_platforms, only: [:create]
  before_action :concat_necessary_platforms, only: [:create]

  def show
    @project = current_user.projects.find params[:id]
    @online_preview = @project.online_preview
    @distributions = @project.distributions

    # modify the order of the distributions, make sure the `web` one is the first
    # @distributions = [ web_distribution = @project.distributions.with_platform('web') ]
    # @project.distributions.where.not(platform: 'web').each{ |d| @distributions << d }
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
    # `collection_check_boxes` will generate an empty item,
    # so the received params are like ['', 'web', 'android']
    # that's the desirable result, so have to filter manually
    # see also https://github.com/rails/rails/issues/12605

    params.require(:project)[:platforms].select!(&:present?)
  end

  def concat_necessary_platforms
    # the checkbox for `web` platform is disabled to be readonly,
    # thus the value wont appear in request params,
    # have to concat it manually

    necessary_platform = 'web'

    unless params.require(:project)[:platforms].include? necessary_platform
      params.require(:project)[:platforms] << necessary_platform
    end
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
