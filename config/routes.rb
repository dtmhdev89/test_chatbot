Rails.application.routes.draw do
  post :cw_webhook, to: "chatbot_webhooks#cw_hook"
  get :fbs_webhook, to: "fbs_webhooks#fbs_webhook"
  post :fbs_webhook, to: "fbs_webhooks#fbs_webhook"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
