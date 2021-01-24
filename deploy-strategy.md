# deploy strategy

## 全体
1. tfでecsのservice作成
2. task-def.jsonを作成
3. ci上でregister-task-def
4. deploy

## 方法1. imageをコード管理する
```
task-definitions/
  task-def-client-dev.json
  task-def-server-dev.json
  task-def-client-prd.json
  task-def-server-prd.json
```

### イメージタグ
SHAを使う

### デプロイ
- dev環境
developマージでデプロイされる
latestイメージを使う

- prd環境
task-def.jsonに定義されているバージョンのDockerイメージを使う
1. GitHubでRelaseを作る
2. task-defを更新し、workflo_dispatchを使って手動デプロイ

### ロールバック
タグを戻してPRを投げる

### メリット
実行環境がコードで表現できる
ロールバックが容易
### デメリット
SHAという人間が扱いづらいタグを管理する必要がある

### メモ
Gitのタグを使うと起こる問題
serverを変更してtagが打たれたときclientに変更がないのにバージョンが上がってしまう
上記はトレーサビリティの観点からNG

## 方法2. imageをコード管理しない
```
task-definitions/
  task-def-client-dev.json
  task-def-server-dev.json
  task-def-client-prd.json
  task-def-server-prd.json
```
```
 image: ""
```

### イメージタグ
SHAを使う

### デプロイ
- dev環境
developマージ時にデプロイ

- prd環境
workflo_dispatchを使って手動デプロイ

## ロールバック
不具合を修正もしくはrevert commitをリリースする。

### メリット
タグを書き換えなくて良い

### デメリット
実行環境がコードで表現できない
ロールバックが1に比べ難しい


### メモ
- ホストの配置について
clientとserverのインスタンスを分ける
理由：clientx3,serverx2の方にリソースを効率よく使えるため
