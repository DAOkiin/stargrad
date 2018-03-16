class GraduationsController < ApplicationController
  require "net/http"

  def show
    respond_to { |format| format.html }
  end

  def find_best
    url = repo_params
    splitted = url.split('/')
    if valid_url?(url) && url.include?('github.com/') && splitted.size == 5
      repo = splitted[-1]
      owner = splitted[-2]
      @response = find_best_contrib(owner, repo)
    else
      @response = nil
    end
  end

  def generate_award
    uri = URI('http://51.15.38.207:2702/graduate')
    expected_params = pdf_params.to_h
    uri.query = URI.encode_www_form(expected_params)
    data = Net::HTTP.get_response(uri).body
    send_data data, filename: "#{expected_params[:name]}.pdf", type: "application/pdf"
  end

  private

  def repo_params
    params.require(:repo)
  end

  def pdf_params
    params.permit(:name, :repo_name, :total_commits, :order)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.kind_of? URI::HTTP
  rescue URI::InvalidURIError
    false
  end

  def find_best_contrib(owner, repo)
    url = URI.parse("https://api.github.com/repos/#{owner}/#{repo}/stats/contributors")
    contributors = JSON.parse(Net::HTTP.get_response(url).body)
    if contributors.is_a?(Hash)
      nil
    else
      best = contributors.sort_by { |c| c['total'] }.last(3).reverse
      best.map.with_index { |c, i| { total_commits: c['total'],
                                     repo_name: repo,
                                     name: c['author']['login'],
                                     repo_name: i + 1
                                   }
                          }
    end
  end
end
