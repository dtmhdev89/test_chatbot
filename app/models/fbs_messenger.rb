class FbsMessenger
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Validations::Callbacks

  VERIFY_TOKEN = ENV["FBS_TOKEN"]
  VERIFY_MODE = "subscribe"
  VERIFY_OBJECT = "page"
end
