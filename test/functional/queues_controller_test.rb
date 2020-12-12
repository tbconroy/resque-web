require 'test_helper'

module ResqueWeb
  class QueuesControllerTest < ActionController::TestCase
    include ControllerTestHelpers

    setup do
      @routes = Engine.routes
      @pending_before_push = Resque.info[:pending]
      Resque.push(queue_name, class: 'ExampleJob')
    end

    teardown do
      Resque.remove_queue(queue_name)
    end

    let(:queue_name) { 'example_queue' }

    describe "GET /index" do
      it "renders the index page" do
        visit(:index)
        assert_template :index
      end
    end

    describe "GET /show" do
      it "renders the show page" do
        visit(:show, id: queue_name)
        assert_template :show
      end
    end
  end
end
