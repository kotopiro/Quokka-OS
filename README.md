# Quokka OS

ペネトレーションテスト特化型 Linux ディストリビューション。
Kali Linux / Parrot OS 系譜の「ホワイトハッカー御用達」を目指す。

- ベース: **Debian (bookworm)** + Kaliリポジトリのオーバーレイ (`docs/distro-decision.md`)
- デスクトップ: **XFCE + LightDM**、テーマは **Qogir-Dark**(GTK/xfwm4/アイコン、`Milestone 14`) (`docs/desktop-environment.md`)
- インストーラ: **Calamares(メイン、ブランド適用済み)+ 従来型Debian Installer(上級者向け)** (`docs/installer.md`)
- ツール構成: Kaliの`kali-tools-*`をQuokka独自カテゴリ名でラップ (`docs/tool-selection.md`)
- 独自ツール: `quokka-report`(レポート生成)/`quokka-fire`+GUI(Tor強制ルーティング)/
  `quokka-about`/`quokkafetch` など。man page完備(`man quokka-report`等)
- 配布形態: ISO (`live-build/`) + VM (`vm-build/`、VirtualBox/.ova・QEMU/.qcow2)
- ビルドプロファイル: `QUOKKA_PROFILE=standard|full`

開発の全履歴・正直な制約事項は `docs/roadmap.md` に集約している(このREADMEは概要のみ)。

## ディレクトリ構成

```text
quokka-os/
├── README.md
├── docs/
│   ├── roadmap.md
│   ├── distro-decision.md
│   ├── tool-selection.md
│   ├── desktop-environment.md
│   └── installer.md
├── branding/
│   ├── palette/
│   ├── plymouth/quokka/
│   ├── grub/quokka/
│   └── desktop/
├── pentest-config/             # monitor/VPN/proxy/wordlist 運用設定
├── live-build/
│   ├── auto/config             # profile 切替付き
│   └── config/
│       ├── package-lists/
│       ├── archives/
│       ├── includes.chroot/
│       ├── includes.installer/
│       └── hooks/normal/
└── vm-build/
    ├── variables.pkr.hcl
    ├── build.pkr.hcl
    └── http/preseed.cfg
```

## 実装済み
- `live-build/auto/config` に `QUOKKA_PROFILE=standard|full` 分岐を追加
- xfwm4/GTK/アイコンは **Qogir-Dark**(vinceliuice/Qogir-theme, GitHubからビルド時導入)を既定化、
  パネルは下部・Whiskermenu(検索付きアプリメニュー)
- `pentest-config/` を新設し、monitor mode / VPN kill switch / NetworkManager / proxychains4 / OpenVPN 運用メモを追加
- `wordlists` パッケージ導入と、`rockyou.txt.gz` をビルド時展開する hook を追加
- VM preseed に初回ログイン時パスワード変更強制と SSH root 直ログイン禁止を追加
- GitHub Actions に profile 選択 + GPG 署名(秘密情報未設定時は自動スキップ)を追加
- Live installer 用 preseed / GUI ランチャー / デスクトップショートカットを追加
- インストーラをCalamares主導線に切り替え、Quokkaブランド(色/ロゴ/スライドショー)を適用(`docs/installer.md`)
- `kali-menu`(攻撃フェーズ別カテゴリメニュー)と `quokka-undercover`(外見偽装トグル)を追加
- `quokka-welcome`(初回ログイン時のウェルカムダイアログ)と `quokka-tweaks`(設定ハブ、kali-tweaks相当)を追加、ドキュメントサイトをISO内に同梱
- ビルド時フックとインストールされるスクリプト(`quokka-monitor`/`quokka-vpn-killswitch`/`quokkafetch`/branding hook群)に
  実行権限が付いていなかった不具合を修正(付いていないと `lb build` 時にhookが実行されない、
  または `[ -x ... ]` チェックでquokkafetchが起動しないなど、静かに機能しない状態だった)

## 重要な未検証項目
このサンドボックスでは以下を実行検証できません。実機または CI で確認してください。

1. `live-build/config/archives/kali.key.chroot` の取得を含む実 ISO ビルド
2. `QUOKKA_PROFILE=standard|full` の両プロファイルでのパッケージ差分確認
3. XFCE パネル配置・Arc-Dark の見た目確認
4. `quokka-monitor` と `quokka-vpn-killswitch` の実機 NIC / VPN での動作確認
5. ライブセッションからのインストーラ起動と、インストール完了後の初回ログイン時パスワード変更確認
6. GitHub Actions で secrets 設定済み/未設定時それぞれの署名フロー確認

## ドキュメントサイト

`docs/site/index.html` をブラウザで開くとブランドカラー適用済みの
静的ドキュメントサイト(全README/docsをまとめたもの)を閲覧できる。

## クイックスタート

```bash
# 1. Kali GPG鍵を取得
wget https://archive.kali.org/archive-key.asc -O live-build/config/archives/kali.key.chroot

# 2. ISOビルド (standard)
cd live-build
sudo QUOKKA_PROFILE=standard lb build

# 3. ISOビルド (full)
sudo lb clean
sudo QUOKKA_PROFILE=full lb build

# 4. VMイメージビルド
cd ../vm-build
packer init .
ISO=../live-build/live-image-amd64.hybrid.iso
packer build -var "iso_path=$ISO" -var "iso_checksum=sha256:$(sha256sum $ISO | awk '{print $1}')" .
```
