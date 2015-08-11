require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
    require 'resque'
    require 'resque_scheduler'

    Resque::Scheduler.dynamic = true

    # https://github.com/resque/resque/wiki/FAQ#how-do-i-ensure-my-rails-classesenvironment-is-loaded
    #
    # In addition, reject any abstract classes to prevent:
    #   ActiveRecord::StatementInvalid: Mysql2::Error: Incorrect table name '':
    #   SHOW FULL FIELDS FROM ``
    ActiveRecord::Base.descendants
      .reject { |klass| klass.abstract_class == true }
      .each { |klass|  klass.columns }
  end
end
