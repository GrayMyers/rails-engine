Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/merchants/find_one", to: "search#find_one_merchant"
      get "/items/find_all", to: "search#find_all_items"

      get "/market/total_revenue_within_range", to: "business_intelligence#total_revenue_within_range"
      get "/market/pending_revenue", to: "business_intelligence#pending_revenue"


      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get "/merchant", to: "items#merchant"
      end

      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchants#items"
        get "/total_revenue", to: "business_intelligence#total_revenue"
      end
    end
  end
end
