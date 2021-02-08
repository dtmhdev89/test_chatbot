Rails.application.routes.draw do
  post :cw_webhook, to: "chatbot_webhooks#cw_hook"
  get :webhook, to: "fbs_webhooks#fbs_webhook"
  post :webhook, to: "fbs_webhooks#fbs_webhook"
  get :privacy, to: "static_pages#privacy"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
