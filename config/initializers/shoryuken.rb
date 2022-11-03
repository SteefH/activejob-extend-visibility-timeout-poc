ActiveJob::QueueAdapters::ShoryukenAdapter::JobWrapper.shoryuken_options(auto_visibility_timeout: true) unless ENV['DISABLE_AUTO_EXTEND_VISIBILITY_TIMEOUT']

# Everything below this line is for demoing purposes

# HACK to make shoryuken log the "Extending message..." logs with INFO level instead of DEBUG
# Bear with me, I'm just making a PoC here
class Logger
  alias_method :old_debug, :debug
  def debug(...)
    return old_debug(...) unless block_given?
    message = yield
    if message.starts_with?('Extending message ')
      info(message)
    else
      old_debug(message)
    end
  end
end

sqs_client_configuration = {
  region: 'eu-central-1',
  access_key_id: '', # localstack doesn't care
  secret_access_key: '', # localstack doesn't care
  endpoint: 'http://localhost:4566',
  verify_checksums: false
}

Shoryuken.configure_server do |config|
  config.sqs_client = Aws::SQS::Client.new(sqs_client_configuration)
end

Shoryuken.configure_client do |config|
  config.sqs_client = Aws::SQS::Client.new(sqs_client_configuration)
end
