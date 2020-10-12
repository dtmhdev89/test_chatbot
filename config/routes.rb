Rails.application.routes.draw do
  post :cw_webhook, to: "chatbot_webhooks#cw_hook"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
