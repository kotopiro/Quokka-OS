# Quokka OS — ロードマップ

## Milestone 1: ブランディング ✅
- [x] カラーパレット確定 (`branding/palette/palette.md`)
- [x] Plymouth起動画面テーマ (`branding/plymouth/quokka/`)
- [x] GRUBブートメニューテーマ (`branding/grub/quokka/`)
- [x] デスクトップ壁紙 1920x1080 (`branding/palette/quokka-wallpaper-1920x1080.png`)
- [x] ベースディストリ決定 (`docs/distro-decision.md`)
- [x] ロゴのSVG化(OpenCVで輪郭抽出→ベクターパス化。元画像とのIoU 0.93)
- [x] GTK/Qtテーマへの配色反映(GTK側)

## Milestone 2: 最小ISO起動 (bring-up)
- [x] `live-build` の設定リポジトリ作成 (`live-build/`)
- [x] Debian base(bookworm)確定
- [ ] 実際にDebian環境で `lb build` を実行してISO生成
- [ ] 最小構成でVirtualBox/QEMU上での起動テスト・Plymouth/GRUBテーマの表示確認

## Milestone 3: ツール選定・メタパッケージ化
- [x] 収録ツールの選定方針決定 (`docs/tool-selection.md`)
- [x] カテゴリ別package-lists作成 (標準6カテゴリ + Full版限定2カテゴリ)
- [x] Kaliリポジトリのオーバーレイ設定 (`live-build/config/archives/`)
- [x] `QUOKKA_PROFILE=standard|full` 分岐実装 (`live-build/auto/config`)
- [ ] GPG鍵の実データ配置 (ネットワーク環境で `kali.key.chroot` 取得)
- [ ] standard/full の両プロファイルで実ビルド確認

## Milestone 4: デスクトップ環境 & UIテーマ
- [x] DE選定 (`docs/desktop-environment.md`)
- [x] GTKテーマ作成 (`branding/desktop/quokka-dark-gtk/`)
- [x] ターミナル配色 (`branding/desktop/xfce4-terminal/`)
- [x] MOTD / システム情報表示 (`branding/desktop/quokkafetch/`)
- [x] ログイン画面(LightDM)テーマ (`branding/desktop/lightdm/`)
- [x] xfwm4 は Arc-Dark を採用し既定設定を作成
- [x] 上部シングルパネルの既定 xfconf を追加
- [ ] 実機での見た目確認

## Milestone 5: pentest特化設定
- [x] monitor mode 切替スクリプト (`pentest-config/quokka-monitor`)
- [x] NetworkManager の monitor I/F 除外 + MAC ランダム化設定
- [x] nftables ベースの VPN kill switch (`pentest-config/quokka-vpn-killswitch`)
- [x] proxychains4 既定設定
- [x] OpenVPN 運用 README
- [x] wordlists パッケージ採用 + ビルド時 gunzip hook
- [ ] 実機 NIC / VPN での検証

## Milestone 6: VM配布パイプライン
- [x] `packer` テンプレート作成 (`vm-build/`)
- [x] 無人インストール用 preseed 作成
- [x] 初回ログイン時のパスワード変更強制 (`chage -d 0`)
- [x] SSH root直ログイン禁止 drop-in 追加
- [ ] 実機での動作確認

## Milestone 7: リリース・QA
- [x] workflow_dispatch での profile 選択
- [x] チェックサム生成
- [x] GPG署名ステップ (secrets 未設定時は自動スキップ)
- [x] Live installer 用 preseed / launcher 追加
- [ ] インストーラ通し確認
- [ ] 署名付き成果物の実ダウンロード確認
- [ ] ドキュメントサイト
