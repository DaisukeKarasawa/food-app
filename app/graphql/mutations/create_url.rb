module Mutations
  class CreateUrl < BaseMutation
    field :recipeUrls, [Types::RecipeUrlType], null: true
    field :errors, [String], null: true

    argument :recipeUrls, [String], required: true
    argument :name, String, required: true

    def resolve(**args)
      dish = Dish.find_by(name: args[:name])
      if !dish
        return {
          recipeUrls: nil,
          errors: ["#{args[:name]}は登録されていません。"]
        }
      end

      # RecipeUrl作成とDishとの紐付け
      urls = args[:recipeUrls].map do |url|
        if !RecipeUrl.find_by(url: url)
          RecipeUrl.create(url: url, dish: dish)
        else
          next
        end
      end.compact

      dish.recipe_urls << urls

      # if !urls.include?(nil)
      #   {
      #     urls: urls,
      #     errors: []
      #   }
      # else
      #   {
      #     urls: nil,
      #     errors: ["すでに登録されているURLが含まれています。"]
      #   }
      # end
      {
        recipeUrls: urls,
        errors: []
      }
    end
  end
end
