module Types
  class QueryType < Types::BaseObject
    field :current_user, Types::UserType, null: true, description: "Current authenticated user"
    field :foods, resolver: Queries::Resolvers::Foods
    field :food, resolver: Queries::Resolvers::Food
    field :shop, resolver: Queries::Resolvers::Shop
    field :dishes, resolver: Queries::Resolvers::Dishes
    field :dish, resolver: Queries::Resolvers::Dish
    
    def current_user
      context[:current_user]
    end
  end
end
