module Mutations
  class SignUp < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true
    argument :name, String, required: true

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :errors, [String], null: true

    def resolve(email:, password:, name:)
      user = User.new(email: email, password: password, name: name)
      
      if user.save
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
          errors: user.errors.full_messages
        }
      end
    end
  end
end