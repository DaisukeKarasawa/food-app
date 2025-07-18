require 'test_helper'

class GraphqlControllerTest < ActionDispatch::IntegrationTest
  test "should sign up new user" do
    query = <<~GQL
      mutation {
        signUp(email: "newuser@example.com", password: "password123", name: "New User") {
          user {
            id
            email
            name
          }
          token
          errors
        }
      }
    GQL
    
    post '/graphql', params: { query: query }
    
    assert_response :success
    json = JSON.parse(response.body)
    
    assert_nil json['errors']
    assert_not_nil json['data']['signUp']['user']
    assert_not_nil json['data']['signUp']['token']
    assert_nil json['data']['signUp']['errors']
    assert_equal 'newuser@example.com', json['data']['signUp']['user']['email']
    assert_equal 'New User', json['data']['signUp']['user']['name']
  end
  
  test "should sign in existing user" do
    user = User.create!(email: "test@example.com", password: "password123", name: "Test User")
    
    query = <<~GQL
      mutation {
        signIn(email: "test@example.com", password: "password123") {
          user {
            id
            email
            name
          }
          token
          errors
        }
      }
    GQL
    
    post '/graphql', params: { query: query }
    
    assert_response :success
    json = JSON.parse(response.body)
    
    assert_nil json['errors']
    assert_not_nil json['data']['signIn']['user']
    assert_not_nil json['data']['signIn']['token']
    assert_nil json['data']['signIn']['errors']
    assert_equal 'test@example.com', json['data']['signIn']['user']['email']
  end
  
  test "should return current user when authenticated" do
    user = User.create!(email: "test@example.com", password: "password123", name: "Test User")
    token = user.generate_jwt
    
    query = <<~GQL
      query {
        currentUser {
          id
          email
          name
        }
      }
    GQL
    
    post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    
    assert_nil json['errors']
    assert_not_nil json['data']['currentUser']
    assert_equal 'test@example.com', json['data']['currentUser']['email']
  end
  
  test "should require authentication for foods query" do
    query = <<~GQL
      query {
        foods {
          id
          name
        }
      }
    GQL
    
    post '/graphql', params: { query: query }
    
    assert_response :success
    json = JSON.parse(response.body)
    
    assert_not_nil json['errors']
    assert_includes json['errors'][0]['message'], 'Authentication required'
  end
  
  test "should return user-specific foods when authenticated" do
    user = User.create!(email: "test@example.com", password: "password123", name: "Test User")
    user.foods.create!(name: "Test Food", deadline: 251220, price: 100)  # December 20, 2025
    token = user.generate_jwt
    
    query = <<~GQL
      query {
        foods {
          name
        }
      }
    GQL
    
    post '/graphql', params: { query: query }, headers: { 'Authorization' => "Bearer #{token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    
    assert_nil json['errors']
    assert_not_nil json['data']['foods']
    assert_equal 1, json['data']['foods'].length
    assert_equal 'Test Food', json['data']['foods'][0]['name']
  end
end