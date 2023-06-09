module Queries
    module Resolvers
        class Shop < GraphQL::Schema::Resolver
            type [Types::ShopType], null: false
            description "Shopで購入できる食品の取得"
            argument :name, String, required: true

            def resolve(name:)
                shop = ::Shop.find_by(name: name)
                return [] if !shop
                [{
                    name: shop.name,
                    foods: shop.foods
                }]
            end
        end
    end
end