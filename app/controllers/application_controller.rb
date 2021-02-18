class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private

  def render_404
    render json: {:error => "the resource could not be located", :status => 404}.to_json, :status => 404
  end
end
