class DelayedJob < ActiveJob::Base
  def perform(seconds)
    with_shoddy_concurrency_detection do
      Shoryuken.logger.info "Job #{job_id} will sleep for #{seconds}s"
      sleep(seconds)
      Shoryuken.logger.info "Job #{job_id} is done sleeping for #{seconds}s"
    end
  end

  def with_shoddy_concurrency_detection
    # Yay, race conditions!
    @@currently_running_jobs ||= {}
    if @@currently_running_jobs[job_id]
      Shoryuken.logger.error "JOB #{job_id} IS ALREADY RUNNING"
      raise "CRASHING THIS INSTANCE OF JOB #{job_id}"
    end
    @@currently_running_jobs[job_id] = true
    yield
    @@currently_running_jobs.delete(job_id)
  end
end
