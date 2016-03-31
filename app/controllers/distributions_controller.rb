class DistributionsController < ApplicationController
  protect_from_forgery only: [:notify], with: :null_session

  before_action :authenticate_user!, except: %i(notify)
  before_action :get_distribution
  before_action :auth_ownership!, except: %i(notify)

  def notify
    # TODO SECURITY auth request
    # TODO use API module

    case params[:event_type]
    when 'building_progress'
      # check if is related to the current building job
      if @distribution.current_building_job_id != params[:event_message][:job_id]
        # TODO check if already_reported(208) is semantically proper
        return head :already_reported
      else
        case params[:event_message][:progress]
        when 'start_building'
          @distribution.start_building if @distribution.may_start_building?
          @distribution.current_building_job_id = params[:event_message][:job_id]
        when 'succeed'
          @distribution.succeed if @distribution.may_succeed?
          @distribution.uploaded_archive_url = params[:event_message][:uploaded_archive_url]
        when 'error_occur'
          @distribution.error_occur
          @distribution.progress_message = params[:event_message][:progress_message]
        when 'minor_update'
          # not a major state progress
          @distribution.progress_message = params[:event_message][:progress_message]
        else
          raise 'Unknown progress type'
        end
      end
    else
      raise 'Unknown event_type'
    end

    @distribution.save!

    head :ok
  end

  def halt
    if @distribution.may_halt?
      @distribution.halt!
    end

    redirect_to :back
  end

  def start_building
    if @distribution.may_pend?
      @distribution.pend!
    end

    redirect_to :back
  end

  private

  def get_distribution
    render_404! unless ( @distribution = Distribution.find params[:id] )
  end

  def auth_ownership!
    render_404! unless @distribution.project.user == current_user
  end

end
