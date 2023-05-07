# 自宅の食材管理システムのバックエンド API 開発

## Versions

- Ruby version

  3.2.2

- Rails version

  7.0.4.3

## システム概要

### システム

購入した食材を登録し、賞味期限を確認しながら管理ができるシステム

### バックエンド API の理由

Apollo サーバーに加え、フロントのフレームワークの学習が行えていないので、バックエンド API を Graphql のアウトプットの一歩目として選択した。
元から食材管理ができるシステムを自分で開発し、自宅で使用したいと考えていたので、今後、フロントと繋いで一つのアプリケーションとして動かせるようにしたいと思っている。

### 主な機能(クエリ)

**全ての食材の一覧取得**

全ての食材を一覧取得。戻り値には、食材名・賞味期限を返す。

これは、登録した食材の賞味期限を確認するためのクエリ。賞味期限が切れていない食材のみ表示される。

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
        "day": "23/5/7"
      },
      {
        "name": "たまねぎ",
        "day": "23/5/10"
      },
      {
        "name": "キャベツ",
        "day": "23/5/5"
      },
      {
        "name": "牛肉",
        "day": "23/5/3"
      }
    ]
  }
}
```

**食材の詳細情報取得**

食材ごとの詳細情報を取得。引数に食材名を渡し、戻り値には、食材名・期限までの残り日数・その食材で作れる料理名・その食材を購入した店名を返す。

これは、特定の食材の詳細情報を確認するためのクエリ。賞味期限が切れている食材に関しては、"新たに購入して下さい。" と表示される。

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
        "remains": "2",
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

**料理の一覧取得**

全ての料理を一覧取得。戻り値には、料理名・レシピの URL を返す。

これは、登録した料理の一覧および、レシピの URL を確認するためのクエリ。

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

**料理の詳細情報取得**

食材ごとの詳細情報を取得。引数に料理名を渡し、戻り値には、料理名・レシピの URL・必要な食材名を返す。

これは、特定の料理の詳細情報を確認するためのクエリ。

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

**店別で購入できる食材の一覧取得**

全ての食材を一覧取得。戻り値には、店名・食材名・価格を返す。

これは、登録した店の購入可能な食材を確認するためのクエリ。

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

### 主な機能(ミューテーション)

**食材の登録・更新**

作成では、引数に食材名・賞味期限・価格・料理・店名を渡し、戻り値には食材名のみを返す。

食材の作成の際、すでにデータ上に引数で私は食材が存在している場合、nil が返る。

```
# ミューテーション(作成)
mutation {
  createFood(input: {
    name: "じゃがいも"
    deadline: 230508
    price: 100
    dishes: ["カレー"]
    shop: "スーパーC"
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

更新では、引数に食材名・賞味期限・店名を渡し、戻り値には食材名のみを返す。

更新のミューテションでは、購入した店の新規登録と新たに購入した食材の賞味期限の登録を行う。

引数に渡した賞味期限がすでに過ぎている場合、nil を返す。

```
# ミューテーション(更新)
mutation {
  updateFood(input: {
    name: "キャベツ"
    deadline: 230512
    shop: "スーパーC"
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

**料理の登録・更新**

作成では、引数に料理名・レシピ URL・食材を渡し、戻り値には料理名・食材を返す。

新しい料理にデータに保存されている食材を登録する。

```
# ミューテーション(作成)
mutation {
  createDish(input: {
    name: "だし巻き卵"
    recipeUrls: ["http://example.com/japanese_omelet_recipe"]
    foods: ["卵"]
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
        "name": "だし巻き卵",
        "foods": [
          {
            "name": "卵"
          }
        ]
      }
    }
  }
}
```

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

更新では、引数に料理名・レシピ URL・食材名を渡し、戻り値に料理名のみを返す。

**URL の登録**

引数に URL を渡し、戻り値には料理名・URL を返す。

データ内の既存の料理に対して、新たなレシピの URL を追加する。

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

### コードのモジュール化

'app/lib' を作成し、共通化できる処理をモジュール化することで、コードの再利用性を高め可読性を上げた。

### 削除機能の代用

ミューテーションに削除機能を加えるところを編集機能で代用することで、必要な情報のみを登録することで、データ上に保存できる仕組みを作った。
削除ではなく編集にしたため、食品一覧取得時では賞味期限が切れている食材を表示せず、特定の食材取得時やレシピ、店で購入できる食材の取得時などの賞味期限が関係いていないクエリでは、
食材を表示するようにした。これにより、登録が楽になることに加え、永続的に登録した食材の情報を保持することが可能になる。

### each メソッドと map メソッドの使い分け

ミューテージョンなどで、配列の要素に対して何か処理を行う際に、'map'メソッドを使用するか、'each'メソッドを使用するかを状況を見て使い分けを行った。

**データへのアクセス**

'find_by'メソッドや'find_or_create_by'メソッドなど、データへアクセスする処理では、'map'メソッドを使うことでデータを一括で検索するするので、アクセス回数を減らすことができる。しかし、検索結果を再利用する必要のない場合は、'each'メソッドを使うことでコードのシンプルさや可読性を上げることができる。

**データの作成**

'create'メソッドと配列のループ処理を組み合わせることで、複数のレコードを一度に作成することができる。'each'メソッドを使用する場合、レコードを作成するだけで、作成されたレコードにアクセスすることができない。'map'メソッドを使用する場合は、作成されたレコードにアクセスするために配列を作成する必要があり、その分のメモリを消費する。

## 改善点・今後のアップデート

プロダクト設計の面で知識と経験がなく、以下のような修正ができそうな点を見つけられたとしても現時点でそれを改善できるような力を持ち合わせていない。
なので、今後の学習を通して気づけたところから修正を行い、アップデートをしたいと思う。

**戻り値とエラー**

今回のプロダクトは、フロントと繋いでいないので、戻り値に何を返せば良いのかが感覚的に理解することができなかった。特にエラーは、何を返してフロントでどのような処理をするかまで考えが回らなかったため、ハンドリングやエラー時の戻り値に穴が見られる。そのこと以前に、エラーへの知識があまりないので、現時点で自分の望んだ場所でエラーメッセージをレスポンスすることはできているが、書き方が正しいのかがはっきり理解できていない。

**コードのネスト**

ミューテーションのコードで if 文やネストが少し多く、見通しが悪くなってしまったように感じた。まだコードのモジュール化やリファクタリングができる箇所があるかもしれない。
