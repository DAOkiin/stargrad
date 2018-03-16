class GraduationsController < ApplicationController
  before_action :pdf_params, only: %i[generate pdf_preview]
  skip_before_action :verify_authenticity_token

  def generate
    user_data       = pdf_params
    @name           = user_data[:name]
    @repo_name      = user_data[:repo_name]
    @total_commits  = user_data[:total_commits]
    @order          = user_data[:order]
    # byebug
    pdf = WickedPdf.new.pdf_from_string(render_to_string(template: 'graduations/generate.pdf.erb', encoding: 'UTF-8'))

    send_data pdf, filename: 'file_name.pdf'
  end

  private

  def pdf_params
    params.permit(:name, :repo_name, :total_commits, :order)
  end
end
