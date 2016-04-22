class DistributionsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_distribution
  before_action :auth_ownership!

  def halt
    if @distribution.may_halt?
      @distribution.halt!
    end

    redirect_back fallback_location: root_path
  end

  def start_building
    if @distribution.may_pend?
      @distribution.pend!
    end

    redirect_back fallback_location: root_path
  end

  private

  def get_distribution
    render_404! unless ( @distribution = Distribution.find params[:id] )
  end

  def auth_ownership!
    render_404! unless @distribution.project.user == current_user
  end

end
