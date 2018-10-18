Rails.application.routes.draw do
  # get "posts/index" => "posts#index"
  get 'new' => 'home#new'
  post 'judge' => 'home#judge'


end
