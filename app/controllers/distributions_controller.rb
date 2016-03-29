class DistributionsController < ApplicationController
  protect_from_forgery only: [:notify], with: :null_session

  def notify
    # TODO SECURITY auth request
    # TODO use API module

    # get distribution
    @distribution = Distribution.find params[:id]

    case params[:event_type]
    when 'building_progress'
      case params[:event_message][:progress]
      when 'start_building'
        @distribution.start_building if @distribution.may_start_building?
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
      @distribution.save!
    else
      raise 'Unknown event_type'
    end

    head :ok
  end
end
