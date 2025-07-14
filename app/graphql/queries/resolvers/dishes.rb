module Queries
  module Resolvers
    class Dishes < GraphQL::Schema::Resolver
      type [Types::DishType], null: false
      description "Dishの一覧取得"

      def resolve
        DishService.list_all_dishes
      end
    end
  end
end