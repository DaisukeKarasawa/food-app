require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should create user with valid attributes" do
    user = User.new(email: "test@example.com", password: "password", name: "Test User")
    assert user.valid?
    assert user.save
  end

  test "should not save user without email" do
    user = User.new(password: "password", name: "Test User")
    assert_not user.save
  end

  test "should not save user without password" do
    user = User.new(email: "test@example.com", name: "Test User")
    assert_not user.save
  end

  test "should not save user without name" do
    user = User.new(email: "test@example.com", password: "password")
    assert_not user.save
  end

  test "should not save user with invalid email" do
    user = User.new(email: "invalid-email", password: "password", name: "Test User")
    assert_not user.save
  end

  test "should not save user with duplicate email" do
    user1 = User.create(email: "test@example.com", password: "password", name: "Test User")
    user2 = User.new(email: "test@example.com", password: "password", name: "Test User 2")
    assert_not user2.save
  end

  test "should generate jwt token" do
    user = User.create(email: "test@example.com", password: "password", name: "Test User")
    token = user.generate_jwt
    assert_not token.nil?
    assert token.is_a?(String)
  end

  test "should decode jwt token" do
    user = User.create(email: "test@example.com", password: "password", name: "Test User")
    token = user.generate_jwt
    decoded_user = User.decode_jwt(token)
    assert_equal user.id, decoded_user.id
  end

  test "should return nil for invalid jwt token" do
    decoded_user = User.decode_jwt("invalid_token")
    assert_nil decoded_user
  end
end
