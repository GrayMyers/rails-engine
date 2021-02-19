Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: "search#find_one_merchant"

      get "/items/find_all", to: "search#find_all_items"

      get "/revenue/", to: "revenue#total_revenue_within_range" #namespace was not working here, had to handroll
      get "/revenue/unshipped", to: "revenue#pending_revenue"
      get "/revenue/items", to: "revenue#items_by_revenue"
      get "/revenue/merchants/:merchant_id", to: "revenue#total_revenue"

      resources :items, only: [:index, :show, :create, :update, :destroy] do
        get "/merchant", to: "items#merchant"
      end

      resources :merchants, only: [:index, :show] do
        get "/items", to: "merchants#items"
      end
    end
  end
end
