class DistributionsController < ApplicationController
  protect_from_forgery only: [:notify], with: :null_session

  def notify
    # TODO SECURITY auth request
    # TODO use API module

    # get distribution
    @distribution = Distribution.find params[:id]

    case params[:event_type]
    when 'building_progress'
      case params[:message][:progress]
      when 'started_pulling', 'started_building', 'started_uploading'
        @distribution.send :"#{params[:message][:progress]}!" if @distribution.send :"may_#{params[:message][:progress]}?"
      when 'succeeded'
        @distribution.succeeded if @distribution.may_succeeded?
        @distribution.uploaded_archive_url = params[:message][:uploaded_archive_url]
        @distribution.save!
      when 'failure_occured'
        @distribution.failure_occured! if @distribution.may_failure_occured?
        # TODO get and save error message
      else
        throw 'Unknown building_progress'
      end
    else
      throw 'Unknown event_type'
    end

    render nothing: true
  end
end
