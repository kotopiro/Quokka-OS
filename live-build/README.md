# Quokka OS — live-build 設定 (Milestone 2)

Debian公式のライブイメージビルドシステム `live-build` の設定一式。
**Debian環境(実機 or VM)で実行してください。** このリポジトリのサンドボックスにはネットワーク/特権がなく、実際のISOビルドはできません。

## GitHub Actionsでの自動ビルド(ローカルにDebian環境がない場合)

`.github/workflows/build.yml` を用意済み。リポジトリをGitHubにpushするか
`workflow_dispatch` で手動実行すると、GitHub Actions(ubuntu-24.04ランナー)上で
`lb build` を実行し、ISOをArtifactsとしてアップロードする。

- ローカルにDebian VM/実機がなくても、ISOをビルドできる
- ビルドできたISOは Artifacts からダウンロードして、手元のQEMU/VirtualBoxで起動確認する
  (GitHub Actions上では画面(Plymouth/GRUB)の目視確認まではできないため)
- Kaliの署名鍵は `live-build/config/archives/kali.key.chroot` が未コミットの場合、
  ワークフローが自動で `wget` して取得する

## 前提

- Debian 12 (bookworm) 系のホスト、または同等の環境
- `sudo apt install live-build`

## ビルド手順

```bash
cd live-build
sudo lb clean          # 念のため初回は不要だが癖でつけておく
sudo lb build           # 数十分〜数時間かかる(ネットワーク速度・マシンスペック依存)
```

成功すると `live-image-amd64.hybrid.iso` (ファイル名はarchive-areas等の設定で変わる) が生成される。

## この設定に含まれるもの

| パス | 内容 |
|---|---|
| `auto/config` | ベースディストリ(bookworm)、ISOメタ情報、ブート引数などの定義 |
| `config/package-lists/quokka.list.chroot` | 最小起動確認用のパッケージ(XFCE + Plymouth + GRUB)。本格ツール群はMilestone 3で追加 |
| `config/includes.chroot/usr/share/plymouth/themes/quokka/` | ブランディングで作成したPlymouth起動画面テーマ |
| `config/includes.chroot/boot/grub/themes/quokka/` | GRUBブートメニューテーマ |
| `config/includes.chroot/usr/share/backgrounds/quokka/` | デスクトップ壁紙 |
| `config/hooks/normal/0100-quokka-branding.hook.chroot` | ビルド時にPlymouth/GRUBテーマを既定として有効化するフック |

## 動作確認したいこと(Milestone 2のゴール)

1. ISOがビルドできる
2. VirtualBox/QEMUでISOから起動し、Plymouthのシアン起動画面が表示される
3. GRUBメニューがQuokka OSテーマで表示される
4. XFCEデスクトップにQuokka壁紙が適用されている

## 既知の未確定事項

- デスクトップ環境をXFCEで確定するかは未決定(`package-lists`はXFCE前提で仮置き)
- Plymouthスクリプトはテキストベースの最小実装。実機での見た目調整(フォント欠落時のフォールバック等)は実際の起動テストをしながら詰める必要あり
- Kaliツールリポジトリのオーバーレイは未設定(Milestone 3で `config/archives/` に追加予定)
