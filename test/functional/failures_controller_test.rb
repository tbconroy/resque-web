require 'test_helper'

module ResqueWeb
  class FailuresControllerTest < ActionController::TestCase
    include ControllerTestHelpers

    setup do
      @routes = Engine.routes
    end

    describe "GET /failures" do
      it "renders the index page" do
        visit(:index)
        assert_template :index
      end
    end

    describe "DELETE /failures/:id" do
      it "deletes the failure" do
        Resque::Failure.expects(:remove).with('123')
        visit(:destroy, {:id => 123}, :method => :delete)
        assert_redirected_to failures_path
      end
    end

    describe "PUT /failures/:id/retry" do
      it "retries the failure and remove the original message" do
        Resque::Failure.expects(:requeue_and_remove).with('123')
        visit(:retry, {:id => 123}, :method => :put)
        assert_redirected_to failures_path
      end
      it "retries should work also in case of pre 2.0 Resque" do
        Resque::Failure.expects(:requeue).with('123')
        Resque::Failure.expects(:remove).with('123')
        visit(:retry, {:id => 123}, :method => :put)
        assert_redirected_to failures_path
      end
    end
  end
end
