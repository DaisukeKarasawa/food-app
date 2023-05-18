module LinkUrls
    def linkUrls(dish, recipeUrls, errors)
        recipeUrls.each do |url|
            existUrl = RecipeUrl.find_by(url: url)
        if !existUrl.present?
            RecipeUrl.create(url: url, dish: dish)
        else
            next
        end
        end
    end
end