# 食材管理システムのバックエンド API

## Versions

- Ruby version

  3.2.2

- Rails version

  7.0.4.3

## システム概要

### - システム -

購入した食材を登録し、賞味期限を確認しながら管理ができるシステム

### - バックエンド API の理由 -

Apollo サーバーに加え、フロントエンドのフレームワークの学習が行えていないが、GraphQL を使用した API 開発を行いたかったので、そのアウトプットの一歩目として選択した。
元から食材管理ができるシステムを自分で開発し、自宅で使用したいと考えていたので、今後、フロントと繋いで一つのアプリケーションとして動かせるようにしたいと思っている。

### - 初期データの登録 -

テストデータをデータベースへ登録する。

※機能を分かりやすくするため、初期データの賞味期限はかなり先に設定されている。

```
rails db:migrate
rails db:seed
```

### - 主な機能(クエリ) -

- **全ての食材の一覧取得**

全ての食材を一覧取得。戻り値には、食材名・賞味期限を返す。

登録した食材の賞味期限を確認するためのクエリ。賞味期限が切れていない食材のみ表示される。

```
# クエリ
{
  foods {
    name
    day
  }
}
```

```
# レスポンス
{
  "data": {
    "foods": [
      {
        "name": "にんじん",
        "day": "27/5/7"
      },
      {
        "name": "たまねぎ",
        "day": "27/5/10"
      },
      {
        "name": "キャベツ",
        "day": "27/5/5"
      },
      {
        "name": "牛肉",
        "day": "27/5/3"
      }
    ]
  }
}
```

- **食材の詳細情報取得**

食材ごとの詳細情報を取得。引数に食材名を渡し、戻り値には、食材名・期限までの残り日数・その食材で作れる料理名・その食材が購入できる店名を返す。

特定の食材の詳細情報を確認するためのクエリ。賞味期限が切れている食材に関しては、"新たに購入して下さい。" と表示される。

```
# クエリ
{
  food(name: "キャベツ") {
    name
    remains
    dishes {
      name
    }
    shops {
      name
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "food": [
      {
        "name": "キャベツ",
        "remains": "1454",
        "dishes": [
          {
            "name": "野菜炒め"
          }
        ],
        "shops": [
          {
            "name": "スーパーA"
          },
          {
            "name": "スーパーB"
          }
        ]
      }
    ]
  }
}
```

- **料理の一覧取得**

全ての料理を一覧取得。戻り値には、料理名・料理ごとのレシピ URL を返す。

登録した料理の一覧および、レシピの URL を確認するためのクエリ。

```
# クエリ
{
  dishes {
    name
    recipeUrls {
      url
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "dishes": [
      {
        "name": "カレー",
        "recipeUrls": [
          {
            "url": "http://example.com/curry_recipe1"
          }
        ]
      },
      {
        "name": "野菜炒め",
        "recipeUrls": [
          {
            "url": "http://example.com/fried_vegetable_recipe1"
          },
          {
            "url": "http://example.com/fried_vegetable_recipe2"
          }
        ]
      }
    ]
  }
}
```

- **料理の詳細情報取得**

料理ごとの詳細情報を取得。引数に料理名を渡し、戻り値には、料理名・その料理のレシピ URL・必要な食材名を返す。

特定の料理の詳細情報を確認するためのクエリ。

```
# クエリ
{
  dish(name: "野菜炒め") {
    name
    recipeUrls {
      url
    }
    foods {
      name
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "dish": [
      {
        "name": "野菜炒め",
        "recipeUrls": [
          {
            "url": "http://example.com/fried_vegetable_recipe1"
          },
          {
            "url": "http://example.com/fried_vegetable_recipe2"
          }
        ],
        "foods": [
          {
            "name": "キャベツ"
          },
          {
            "name": "たまねぎ"
          }
        ]
      }
    ]
  }
}
```

- **店別で購入できる食材の一覧取得**

全ての食材を一覧取得。戻り値には、店名・食材名・価格を返す。

登録した店の購入可能な食材を確認するためのクエリ。

```
# クエリ
{
  shop(name: "スーパーA") {
    name
    foods {
      name
      price
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "shop": [
      {
        "name": "スーパーA",
        "foods": [
          {
            "name": "にんじん",
            "price": 100
          },
          {
            "name": "たまねぎ",
            "price": 80
          },
          {
            "name": "キャベツ",
            "price": 120
          },
          {
            "name": "牛肉",
            "price": 500
          }
        ]
      }
    ]
  }
}
```

### - 主な機能(ミューテーション) -

- **食材の登録**

引数に食材名・賞味期限・価格・料理・店名を渡し、戻り値には食材名のみを返す。

すでにデータ上に食材が存在している、賞味期限がすでに過ぎている、料理名がデータ上に存在していない場合、登録不可。

```
# ミューテーション(作成)
mutation {
  createFood(input: {
    name: "じゃがいも"
    deadline: 230712
    price: 100
    dishes: ["カレー"]
    shop: "スーパーA"
  }) {
    food {
      name
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "createFood": {
      "food": {
        "name": "じゃがいも"
      }
    }
  }
}
```

- **食材の更新**

引数に食材名・賞味期限・店名・価格を渡し、戻り値には食材名のみを返す。

食材がデータ上に存在しない、賞味期限が切れている場合、更新不可。

```
# ミューテーション(更新)
mutation {
  updateFood(input: {
    name: "キャベツ"
    deadline: 230512
    shop: "スーパーC"
    price: 60
  }) {
    food {
      name
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "updateFood": {
      "food": {
        "name": "キャベツ"
      }
    }
  }
}
```

- **料理の登録**

引数に料理名・レシピ URL・食材を渡し、戻り値には料理名・食材を返す。

料理がデータ上に存在している、食材がデータ上に存在していない場合、登録不可。

```
# ミューテーション(作成)
mutation {
  createDish(input: {
    name: "ポテトサラダ"
    recipeUrls: ["http://example.com/potato_salad_recipe"]
    foods: ["じゃがいも"]
  }) {
    dish {
      name
      foods {
        name
      }
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "createDish": {
      "dish": {
        "name": "ポテトサラダ",
        "foods": [
          {
            "name": "じゃがいも"
          }
        ]
      }
    }
  }
}
```

- **料理の更新**

引数に料理名・食材名を渡し、戻り値に料理名とその料理に必要な全ての食材を返す。

料理がデータ上に存在しない場合は更新不可。

```
# ミューテーション(更新)
mutation {
  updateDish(input: {
    name: "野菜炒め"
    foods: ["にんじん"]
  }) {
    dish {
      name
      foods {
        name
      }
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "updateDish": {
      "dish": {
        "name": "野菜炒め",
        "foods": [
          {
            "name": "キャベツ"
          },
          {
            "name": "たまねぎ"
          },
          {
            "name": "にんじん"
          }
        ]
      }
    }
  }
}
```

- **URL の登録**

引数にレシピ URL・料理名を渡し、戻り値には料理名・その料理のレシピ URL を返す。

料理がデータ上に存在しない場合は登録不可。

```
# ミューテーション
mutation {
  createUrl(input: {
    recipeUrls: ["http://example.com/fried_vegetable_recipe3", "http://example.com/fried_vegetable_recipe4"]
    name: "野菜炒め"
  }) {
    dish {
      name
      recipeUrls {
        url
      }
    }
  }
}
```

```
# レスポンス
{
  "data": {
    "createUrl": {
      "dish": {
        "name": "野菜炒め",
        "recipeUrls": [
          {
            "url": "http://example.com/fried_vegetable_recipe1"
          },
          {
            "url": "http://example.com/fried_vegetable_recipe2"
          },
          {
            "url": "http://example.com/fried_vegetable_recipe3"
          },
          {
            "url": "http://example.com/fried_vegetable_recipe4"
          }
        ]
      }
    }
  }
}
```

## 工夫した点

### - コードのモジュール化 -

'app/lib' を作成し、共通化できる処理をモジュール化することで、コードの再利用性を高め可読性を上げた。

### - 削除機能の代用 -

ミューテーションに削除機能を加えるところを更新機能で代用することで、一度登録したデータに対して、必要な情報のみの変更で、永続的にデータを保持できる仕組みにした。

削除ではなく更新にしたため、食品一覧取得時には賞味期限が切れている食材を表示せず、特定の食材やレシピ、店で購入できる食材の取得時など、賞味期限が関係していないクエリでは、食材が全て表示されるようにした。

### - データ操作 -

データ操作に対して、さまざまな工夫を加えた。

- **データへのアクセス(dataloader)**

N+1 問題を解決すべく、GraphQL::Batch を使用し、データのアクセスを改善した。([GraphQL::Batch の実装](https://github.com/DaisukeKarasawa/dataloader))

- **データへのアクセス(each/map)**

'find_by'メソッドや'find_or_create_by'メソッドなど、データへアクセスする処理では、'map'メソッドを使うことでデータを一括で検索することが可能なので、アクセス回数を減らすことができる。しかし、検索結果を再利用する必要のない場合は、'each'メソッドを使うことでコードのシンプルさや可読性を上げることができる。

- **データの作成**

'create'メソッドと配列のループ処理を組み合わせることで、複数のレコードを一度に作成することができる。'each'メソッドを使用する場合、レコードを作成するだけで、作成されたレコードにアクセスすることができない。'map'メソッドを使用する場合は、作成されたレコードにアクセスするために配列を作成する必要があり、その分のメモリを消費する。

## 改善点・今後のアップデート

- **戻り値とエラー**

今回のプロダクトは、フロントと繋いでいないので、戻り値に何を返せば良いのかを感覚的に理解することができなかった。特に、エラーをどのように返して、フロントでどのような処理をするかをイメージすることができなかったため、ハンドリングやエラー時の戻り値に改善が見込める。

現時点で、エラーメッセージを必要な場所でレスポンスすることはできている。しかし、エラー処理の知識があまりなく、書き方に誤りがあると思うので、今後エラー面の学習を行なった上でもう一度書き直す。

- **コードのネスト**

ミューテーションのコードで if 文やネストが少し多く、見通しが悪くなってしまったように感じた。まだコードのモジュール化やリファクタリングができる箇所があるかもしれないので、綺麗にできるそうなところは修正を入れる。

加えて、モジュール化したコードに、さらにパターン化して統一できそうなものも見られるので、引数に応じて一つのコードで処理を変えられるように変更を加えていく。

- **価格設定**

食材の価格は変化が激しいことに加え、現時点では１つの食材に対する価格が、全ての店で統一されている。今後、価格を登録することの需要を再検討し、必要であれば、どのタイミングでどのように必要になるかを明確する。

- **テスト**

現時点では、テストの実装ができていないが、このシステムにおけるテストを作成し、自分の見落としているところがないか確認できるようにする。
