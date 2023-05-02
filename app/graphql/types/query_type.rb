module Types
  class QueryType < Types::BaseObject
    field :foods, resolver: Queries::Resolvers::Foods
    field :food, resolver: Queries::Resolvers::Food
  end
end
