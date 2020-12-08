module ResqueWeb
  class CaptureFailureAction

    class << self
      def call(controller)
        new(controller).call
      end
    end

    def initialize(controller)
      @controller ||= controller
    end

    def call
      SLACK_CLIENT.chat_postMessage(channel: ENV["SLACK_BOT_CHANNEL"], message)
    end

    private

    attr_reader :controller

    delegate :action_name, :params, to: :controller

    def message
      "#{user_email} triggered #{action_name} on job\n#{job_arguments}"
    end

    def user_email
      request&.headers["x-goog-authenticated-user-email"] || "Unknown"
    end

    def job_arguments
      return 'nil' unless job['payload']

      Array(job['payload']['args']).map { |arg| arg.inspect }.join("\n")
    end

    def job
      @job ||= Resque::Failure.all(params[:id], 1, params[:queue])
    end
  end
end
