module ResqueWeb
  class QueuesController < ResqueWeb::ApplicationController
    def index
    end

    def show
      set_subtabs view_context.queue_names
    end
  end
end
