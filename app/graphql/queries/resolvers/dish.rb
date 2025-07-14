module Queries
  module Resolvers
    class Dish < GraphQL::Schema::Resolver
      type Types::DishType, null: true
      description "Dishの詳細情報取得"
      argument :name, String, required: true

      def resolve(name:)
        DishService.find_dish_by_name(name)
      end
    end
  end
end