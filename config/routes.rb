# Match IDs with dots in them
id_pattern = /[^\/]+/

ResqueWeb::Engine.routes.draw do

  ResqueWeb::Plugins.plugins.each do |p|
    mount p::Engine => p.engine_path
  end

  resource  :overview,  :only => [:show], :controller => :overview
  resources :working,   :only => [:index]
  resources :queues,    :only => [:index,:show], :constraints => {:id => id_pattern}
  resources :workers,   :only => [:index,:show], :constraints => {:id => id_pattern}
  resources :failures,  :only => [:show,:index,:destroy] do
    member do
      put 'retry'
    end
  end

  get '/stats' => 'stats#index'
  get '/stats/resque' => 'stats#resque'
  get '/stats/redis' => 'stats#redis'
  get '/stats/keys' => 'stats#keys'
  get '/stats/keys/:id' => 'stats#keys', :constraints => { :id => id_pattern }, as: :keys_statistic

  root :to => 'overview#show'

end
