module Mutations
  class SignOut < BaseMutation
    field :message, String, null: true

    def resolve
      {
        message: "Logged out successfully"
      }
    end
  end
end