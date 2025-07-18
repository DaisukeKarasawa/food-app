module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: true

    def resolve(email:, password:)
      user = User.find_by(email: email)
      
      if user && user.authenticate(password)
        token = user.generate_jwt
        {
          user: user,
          token: token,
          errors: nil
        }
      else
        {
          user: nil,
          token: nil,
          errors: ["Invalid email or password"]
        }
      end
    end
  end
end