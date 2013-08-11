#!/usr/bin/env puma

environment ENV['RACK_ENV']
threads 1, 4
workers 4
preload_app!

on_worker_boot do
  ActiveRecord::Base.connection_pool.disconnect!

  ActiveSupport.on_load(:active_record) do
    config = Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']              = ENV['DB_POOL'] || 5
    ActiveRecord::Base.establish_connection
  end
end
