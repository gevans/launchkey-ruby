ExampleApp::Application.routes.draw do

  resources :sessions, except: [:update, :destroy] do
    post 'webhook', on: :collection
  end
  delete 'sessions' => 'sessions#destroy'

  root to: 'pages#index'
end
