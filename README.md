# Quokka OS

ペネトレーションテスト特化型 Linux ディストリビューション。
Kali Linux / Parrot OS 系譜の「ホワイトハッカー御用達」を目指す。

- ベース: **Debian (bookworm)** + Kaliリポジトリのオーバーレイ (`docs/distro-decision.md`)
- デスクトップ: **XFCE + LightDM** (`docs/desktop-environment.md`)
- ツール構成: Kaliの`kali-tools-*`をQuokka独自カテゴリ名でラップ (`docs/tool-selection.md`)
- 配布形態: ISO (`live-build/`) + VM (`vm-build/`、VirtualBox/.ova・QEMU/.qcow2)
- 現在フェーズ: Milestone 1〜3,6 は設計・骨組み完了。実ビルド・実機検証がネクストアクション

## ディレクトリ構成

```
quokka-os/
├── README.md
├── docs/
│   ├── roadmap.md               # 全体ロードマップ(進捗チェックリスト)
│   ├── distro-decision.md       # ベースディストリ選定理由
│   ├── tool-selection.md        # ツール/メタパッケージ設計
│   └── desktop-environment.md   # DE選定理由
├── branding/
│   ├── palette/                 # カラー定義・ロゴ(PNG/SVG)・壁紙
│   ├── plymouth/quokka/         # 起動画面テーマ
│   └── grub/quokka/             # ブートメニューテーマ
├── live-build/                  # ISOビルド設定(要: Debian環境で `sudo lb build`)
│   ├── auto/config
│   └── config/
│       ├── package-lists/       # 標準6カテゴリ + Full限定2カテゴリ(.disabled)
│       ├── archives/            # Kaliリポジトリ・オーバーレイ設定
│       ├── includes.chroot/     # ブランディング資産の実配置
│       └── hooks/normal/        # ビルド時にテーマを既定化するフック
└── vm-build/                    # VMイメージビルド(要: Packer)
    ├── variables.pkr.hcl
    ├── build.pkr.hcl
    └── http/preseed.cfg
```

## ★ サンドボックス環境の制約(重要)

このリポジトリ一式は **設計・設定ファイルレベルでは完成**しているが、以下は
ネットワーク/仮想化が使えないサンドボックスでは検証できていない。**実機/CI環境での
実施が必須**:

1. `live-build/config/archives/kali.key.chroot` — Kaliの実GPG鍵をネットワーク環境で取得
2. `cd live-build && sudo lb build` — 実際のISOビルド
3. VirtualBox/QEMUでのISO起動テスト(Plymouth/GRUBテーマの表示確認含む)
4. `cd vm-build && packer build ...` — VMイメージビルド

## クイックスタート(実機/CI側での手順)

```bash
# 1. Kali GPG鍵を取得
wget https://archive.kali.org/archive-key.asc -O live-build/config/archives/kali.key.chroot

# 2. ISOビルド
sudo apt install live-build
cd live-build && sudo lb build

# 3. VMイメージビルド(ISOができてから)
cd ../vm-build
packer init .
ISO=../live-build/live-image-amd64.hybrid.iso
packer build -var "iso_path=$ISO" -var "iso_checksum=sha256:$(sha256sum $ISO | awk '{print $1}')" .
```

詳細は `docs/roadmap.md` を参照。
