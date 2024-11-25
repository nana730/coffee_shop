class ErrorsController < ApplicationController
  def internal_server_error
    render template: "errors/internal_server", status: :internal_server_error
  end
  
  def not_found
    respond_to do |format|
      format.html { render status: :not_found } # HTML フォーマット
      format.any  { head :not_found }          # その他のフォーマット
    end
  end

end

