class PagesController < ApplicationController
  layout 'static_page'

  def show
    render file: "pages/#{params[:name]}"
  end
end
