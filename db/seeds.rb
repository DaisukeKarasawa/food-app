# Foods
carrot = Food.create(name: 'にんじん', deadline: 230507, price: 100)
onion = Food.create(name: 'たまねぎ', deadline: 230510, price: 80)
cabbage = Food.create(name: 'キャベツ', deadline: 230505, price: 120)
beef = Food.create(name: '牛肉', deadline: 230503, price: 500)

# Dishes
curry = Dish.create(name: 'カレー', url: 'http://example.com/curry')
fried_vegetable1 = Dish.create(name: '野菜炒め', url: 'http://example.com/fries1')
fried_vegetable2 = Dish.create(name: '野菜炒め', url: 'http://example.com/fries2')
salad = Dish.create(name: 'サラダ', url: 'http://example.com/salad')

# Recipes
curry_recipe = RecipeUrl.create(url: 'http://example.com/curry', dish: curry)
fried_vegetable1_recipe = RecipeUrl.create(url: 'http://example.com/fries1', dish: fried_vegetable1)
fried_vegetable2_recipe = RecipeUrl.create(url: 'http://example.com/fries2', dish: fried_vegetable2)
salad_recipe = RecipeUrl.create(url: 'http://example.com/salad', dish: salad)

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
DishesFood.create(dish: fried_vegetable1, food: cabbage)
DishesFood.create(dish: fried_vegetable1, food: onion)
DishesFood.create(dish: fried_vegetable2, food: cabbage)
DishesFood.create(dish: fried_vegetable2, food: onion)
DishesFood.create(dish: salad, food: cabbage)
