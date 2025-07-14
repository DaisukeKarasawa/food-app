module Queries
  module Resolvers
    class Foods < GraphQL::Schema::Resolver
      type [Types::FoodType], null: false
      description "Foodの一覧取得"

      def resolve
        FoodService.list_available_foods
      end
    end
  end
end