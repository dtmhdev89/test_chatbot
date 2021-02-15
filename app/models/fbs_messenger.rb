class FbsMessenger
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Naming
  include ActiveModel::Validations::Callbacks

  VERIFY_TOKEN = ENV["FBS_TOKEN"].freeze
  VERIFY_MODE = "subscribe".freeze
  VERIFY_OBJECT = "page".freeze
end
