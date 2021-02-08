Delayed::Worker.sleep_delay = 10
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.queue_attributes = {
  high_prio: { priority: -5 },
  normal_prior: { priority: 0 },
  low_prior: { priority: 5 }
}

if Rails.env.development?
  module Delayed
    module Backend
      module ActiveRecord
        class Job
          class << self
            alias_method :reserve_original, :reserve
            def reserve(worker, max_run_time = Worker.max_run_time)
              previous_level = ::ActiveRecord::Base.logger.level
              ::ActiveRecord::Base.logger.level = Logger::WARN if previous_level <= Logger::FATAL
              value = reserve_original(worker, max_run_time)
              ::ActiveRecord::Base.logger.level = previous_level
              value
            end
          end
        end
      end
    end
  end
end
