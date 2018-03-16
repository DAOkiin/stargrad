Rails.application.routes.draw do
  get '/' => 'graduations#show'
  post '/find_names' => 'graduations#find_best'
  post '/graduations/generate_award' => 'graduations#generate_award'
end
