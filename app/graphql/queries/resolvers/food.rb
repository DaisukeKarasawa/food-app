module Queries
  module Resolvers
    class Food < GraphQL::Schema::Resolver
      type Types::FoodType, null: true
      description "Foodの詳細情報取得"
      argument :name, String, required: true
      
      def resolve(name:)
        FoodService.find_food_by_name(name)
      end
    end
  end
end