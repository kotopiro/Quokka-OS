# ライブUSBの永続化(Persistence)

Quokka OSのライブUSBは、そのままでは再起動すると変更内容が消えます。
Kali/Ubuntu等と同じく、live-boot標準の永続化機能を使って変更を保存できます。

## 手順(概要)

1. USBメモリのISO領域とは別に、ext4等でフォーマットした追加パーティションを作成し、
   ボリュームラベルを `persistence` に設定する
2. そのパーティションのルートに `persistence.conf` というファイルを作成し、
   中身を1行 `/ union` とする
3. 起動時にブートメニューで `persistence` オプション付きで起動する
   (例: 起動メニューで `e` を押して編集し、`boot=live` の行末に `persistence` を追記)

## 正直な制約

- Quokka OS側でこの手順を自動化するツールは用意していない(手動作業が前提)。
  GUIでの永続化パーティション作成ツール(Kaliの一部ツール相当)は今回未実装
- 上記手順はDebian live-boot標準の一般的な方法であり、Quokka OS固有の検証は
  実施していない
