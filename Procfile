web:    bundle exec rails server puma -p $PORT -e $RACK_ENV
redis:  redis-server
worker: bundle exec sidekiq -C config/sidekiq.yml -c $SIDEKIQ_CONCURRENCY
