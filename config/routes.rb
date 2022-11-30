Rails.application.routes.draw do
  resources :businesses, only: [:index] do
    collection do 
      post :import
    end
  end

  post 'import_model', action: :import_model, controller: 'import'

  # Defines the root path route ("/")
  root "import#index"
end
