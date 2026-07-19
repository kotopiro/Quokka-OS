# ツールセット選定方針

## 結論: **Kaliのメタパッケージをベースに、Quokka独自のカテゴリ名でラップする**

「600個のツールを個別選定してゼロからメタパッケージを作る」か「`kali-linux-default` を
まるごと入れるか」の二択ではなく、中間案を採用する。

## 理由

- Kaliの `kali-tools-*` メタパッケージ群は既に長年の運用でカテゴリ分けと依存関係が
  整理されている。車輪の再発明は避ける
- 一方で `kali-tools-*` をそのまま使うと「中身はKali」感が強くなり、Quokka OSとしての
  アイデンティティが薄れる
- そこで、live-buildの `package-lists/*.list.chroot` は複数ファイルに分割できる仕様を
  利用し、**Quokka独自の名前のリストファイル**として `kali-tools-*` を束ねる形にする。
  実体はKaliのメタパッケージに依存しつつ、ユーザー(利用者)から見た構成単位はQuokka独自、
  という設計

## カテゴリ対応表

| Quokkaカテゴリ | 実体(Kaliメタパッケージ) | 用途 |
|---|---|---|
| `quokka-recon` | `kali-tools-information-gathering` | 偵察・情報収集 |
| `quokka-vuln` | `kali-tools-vulnerability` | 脆弱性診断 |
| `quokka-web` | `kali-tools-web` | Web診断 |
| `quokka-exploit` | `kali-tools-exploitation` | Exploitation |
| `quokka-password` | `kali-tools-passwords` | パスワード攻撃・クラッキング |
| `quokka-wireless` | `kali-tools-wireless` | 無線(Wi-Fi/Bluetooth) |
| `quokka-forensics` | `kali-tools-forensics` | フォレンジック |
| `quokka-sniffing` | `kali-tools-sniffing-spoofing` | パケット盗聴・スプーフィング |
| `quokka-reporting` | `kali-tools-reporting` | レポーティング |

## デフォルトISOに何を含めるか

- **標準版 (Quokka OS)**: 上記の `quokka-recon` / `quokka-web` / `quokka-vuln` /
  `quokka-password` / `quokka-sniffing` / `quokka-reporting` を標準搭載
  (軽量・汎用的なpentest用途を想定。ISOサイズを抑える)
- **フル版 (Quokka OS Full)**: 全カテゴリ + `quokka-exploit` + `quokka-wireless`
  (無線アダプタ・より攻撃的なツールが必要な人向け。ISOサイズ大)
- 個別カテゴリはインストール後に `apt install` でも追加可能な設計にする
  (メタパッケージ的な分割なので後から足せる)

## 未決定・要検討事項

- 独自ツール(Quokka OS固有の自作スクリプト・ラッパー)を持つかどうかは今後検討
- `kali-tools-*` に依存しない完全オリジナルの選定にするかは、実際にコミュニティが
  つくかどうかを見てから再検討してもよい
