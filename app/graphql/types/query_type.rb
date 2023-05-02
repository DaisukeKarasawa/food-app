module Types
  class QueryType < Types::BaseObject
    field :foods, resolver: Queries::Resolvers::Foods
    field :food, resolver: Queries::Resolvers::Food
    field :shop, resolver: Queries::Resolvers::Shop
    field :dishes, resolver: Queries::Resolvers::Dishes
    field :dish, resolver: Queries::Resolvers::Dish
  end
end
