# Foods
carrot = Food.create(name: 'にんじん', deadline: 270507, price: 100)
onion = Food.create(name: 'たまねぎ', deadline: 270510, price: 80)
cabbage = Food.create(name: 'キャベツ', deadline: 270505, price: 120)
beef = Food.create(name: '牛肉', deadline: 270503, price: 500)

# Dishes
curry = Dish.create(name: 'カレー', url: 'http://example.com/curry')
fried_vegetable = Dish.create(name: '野菜炒め', url: 'http://example.com/fries1')

# RecipeUrls
curry_recipe = RecipeUrl.create(url: 'http://example.com/curry_recipe1', dish: curry)
fried_vegetable_recipe1 = RecipeUrl.create(url: 'http://example.com/fried_vegetable_recipe1', dish: fried_vegetable)
fried_vegetable_recipe2 = RecipeUrl.create(url: 'http://example.com/fried_vegetable_recipe2', dish: fried_vegetable)

# Shops
shop_a = Shop.create(name: 'スーパーA')
shop_b = Shop.create(name: 'スーパーB')

# Foods_Shops
FoodsShop.create(shop: shop_a, food: carrot)
FoodsShop.create(shop: shop_a, food: onion)
FoodsShop.create(shop: shop_a, food: cabbage)
FoodsShop.create(shop: shop_a, food: beef)
FoodsShop.create(shop: shop_b, food: carrot)
FoodsShop.create(shop: shop_b, food: onion)
FoodsShop.create(shop: shop_b, food: cabbage)

# Dishes_Foods
DishesFood.create(dish: curry, food: carrot)
DishesFood.create(dish: curry, food: beef)
DishesFood.create(dish: fried_vegetable, food: cabbage)
DishesFood.create(dish: fried_vegetable, food: onion)
