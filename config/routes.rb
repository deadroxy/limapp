Limapp::Application.routes.draw do
  
  resources :users do
    resources :soundtracks
  end
  
end
