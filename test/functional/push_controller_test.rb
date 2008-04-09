require File.dirname(__FILE__) + '/../test_helper'
require 'push_controller'

# Re-raise errors caught by the controller.
class PushController; def rescue_action(e) raise e end; end

class PushControllerTest < Test::Unit::TestCase
  def setup
    @controller = PushController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
