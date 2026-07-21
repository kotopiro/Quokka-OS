# Quokka OS Installer

Kali Linux / Parrot OS と同じ方針をとる: **ライブデスクトップから起動する
Calamares を主導線**とし、classic Debian Installer は自動応答(preseed)前提の
上級者向けオプションとして boot menu 側に残す。

## 導線1: Calamares(メイン、ブランド適用済み)

- ライブセッションのデスクトップアイコン「Install Quokka OS」から起動
- `Exec=calamares`(`live-build/config/includes.chroot/usr/share/applications/quokka-installer.desktop`,
  `.../etc/skel/Desktop/Install Quokka OS.desktop`)
- ブランディング一式:
  `live-build/config/includes.chroot/etc/calamares/branding/quokka/`
  - `branding.desc` — 製品名・配色(`branding/palette/palette.md` のシアン系パレット)
  - `logo.png` / `welcome.png` — 既存ブランド素材からコピー
  - `show.qml` — 最小構成のインストール中スライドショー
- `calamares-settings-debian` パッケージが提供するモジュール構成(パーティショニング/
  ユーザー作成/ブートローダー等)をそのまま利用し、branding だけ独自のものに差し替える
- 差し替え方法: `live-build/config/hooks/normal/0110-quokka-calamares-branding.hook.chroot`
  が `/etc/calamares/settings.conf` の `branding: debian` を `branding: quokka` に
  ビルド時 sed 置換する

## 導線2: 従来型 Debian Installer(上級者向け、非ブランド)

- ISO では `live-build` の `--debian-installer live` を使い、boot menu から
  自動応答インストールを起動できるようにする(`debian-installer-launcher`)
- 既定値は `live-build/config/includes.installer/preseed.cfg` で管理
- こちらの画面自体は素の Debian Installer の見た目のまま(ブランド化していない)。
  無人インストール/CI/検証用途を想定しており、通常ユーザーはCalamaresを使う想定

## 注意・未検証

- `branding.desc` のキー名は Calamares のバージョンに依存する可能性がある。
  ネットワーク・実機がないこのサンドボックスでは Calamares 自体を起動して
  スキーマエラーの有無を確認できていない。実ビルド後に
  `calamares --debug` のログを必ず確認すること
- `show.qml` は最低限の1枚スライドのみ。複数スライド化は今後の余地
- 実機/VM で、ライブセッション起動 → Calamaresインストール → ディスク書き込み →
  再起動までを通し確認する必要がある(未実施)
- 従来型 Debian Installer 経路(preseed)も同様に未実施
