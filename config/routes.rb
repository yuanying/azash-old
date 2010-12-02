Azash::Application.routes.draw do
  resources :comments, :except => [ :destroy, :edit, :update ] do
    collection do
      get :recent
    end
  end
end
