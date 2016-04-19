$jobs_queues = {
  to_build: ( JobsQueue.new $redis, :to_build )
}
