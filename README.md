# 自宅の食材管理システムのバックエンド API 開発

## Versions

- Ruby version

  3.2.2

- Rails version

  7.0.4.3

## システム概要

### システム

購入した食材を登録し、賞味期限を確認しながら管理ができるシステムのバックエンド API

### バックエンド API の理由

Apollo サーバーに加え、フロントのフレームワークの学習が行えていないので、バックエンド API を Graphql のアウトプットの一歩目として選択した。
元から食材の賞味期限を管理できるシステムを自分で開発し、家で使用できるようにしたいと考えていたので、今後、フロントと繋いで一つのアプリケーションとして
動かせるようにしたいと思っている。

### 主な機能(スキーマ)

**Food**

```

```

**Shop**

```

```

**Dish**

```

```

### 主な機能(クエリ)

**全ての食材の一覧取得**

登録してある全ての食材の一覧を取得。戻り値には、食材名・賞味期限・その食材で作れる料理を返す。

```
# クエリ
```

```
# レスポンス
```

**料理に必要な食材の一覧取得**

登録してある料理に必要な食材の一覧を取得。戻り値には、料理名・レシピ URL・食材名を返す。

```
# クエリ
```

```
# レスポンス
```

**店別で購入できる食材の一覧取得**

登録してある店で購入が可能な食材の一覧を取得。戻り値には、店名・食材名・価格を返す。

```
# クエリ
```

```
# レスポンス
```

### 主な機能(ミューテーション)

**食品の登録・削除**

**料理の登録削除**

**店の登録・削除**

## 工夫した点
