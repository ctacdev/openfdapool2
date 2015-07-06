Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :active_ingredients, only: [:index]
    end
  end

  get 'style_guide' => 'visitors#style_guide'

  root to: 'visitors#ingredient_browser'
end
