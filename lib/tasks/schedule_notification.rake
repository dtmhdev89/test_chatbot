namespace :schedule_notification do
  desc "daily list and schedule notification"
  task create_scheduler: :environment do
    p "create scheduler"
  end
end
