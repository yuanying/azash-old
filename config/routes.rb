Azash::Application.routes.draw do
  resources :comments, :except => [ :destroy ]
end
