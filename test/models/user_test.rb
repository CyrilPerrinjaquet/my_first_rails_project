require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user with a valid email should be valid" do
    user = User.new(email: "test@test.org", password_digest: 'test')
    assert user.valid?
  end

  test "user with unvalid email shouldn't be valid" do
    user = User.new(email: "test.org", password_digest: "test")
    assert_not user.valid?
  end

  test "user with not unique email shouldn't be valid" do
    other_user = users(:one)
    user = User.new(email: other_user.email, password_digest: "test")
    assert_not user.valid?
  end

  test "destroy user should destroy associated product" do
    assert_difference('Product.count', -1) do
      users(:one).destroy
    end
  end
end
