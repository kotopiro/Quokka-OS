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
- [x] Calamaresへの切り替え + Quokkaブランディング(色/ロゴ/スライドショー) (`docs/installer.md`)
- [ ] インストーラ通し確認(Calamares・従来型 Debian Installer 双方とも未実施)
- [ ] 署名付き成果物の実ダウンロード確認
- [x] ドキュメントサイト (`docs/site/`、静的HTML・ブランドカラー適用済み)

## 見つかった不具合の修正

- ビルドフック(`live-build/config/hooks/normal/*.hook.chroot`)3本すべてに
  実行権限が付いていなかった。live-buildはchroot内で直接実行するため、
  +xがないと `lb build` 時にhookが機能しない(=GRUBテーマ適用やwordlists展開が
  実は一度も走っていなかった可能性がある)。→ 修正済み
- `/usr/local/bin/quokka-monitor` `quokka-vpn-killswitch` `quokkafetch` にも
  実行権限が付いていなかった。特に `quokkafetch` は
  `/etc/profile.d/quokka-fetch.sh` 側で `[ -x /usr/local/bin/quokkafetch ]` を
  チェックしているため、このままではログイン時に一度も表示されない状態だった。→ 修正済み

## 現状のまとめ

設定・ブランディング・自動化(GitHub Actions)まわりはこのサンドボックス内で
用意できる範囲では完成している。残るチェック項目(✅未満のもの)は、
**すべて実機またはネットワーク接続のあるビルド環境が必要**という共通点がある:

- 実際の `lb build` によるISO生成とその起動確認
- VM/実機でのGUI・ネットワーク・VPNの動作確認
- GitHub ActionsでのGPG署名フローの実地確認（secrets設定後）

これらはコード変更で解決するものではなく、"動かして確認する"フェーズなので、
`.github/workflows/build.yml` を push するか `workflow_dispatch` で手動実行し、
成果物のISOをVirtualBox/QEMUや実機USBで検証するのが次のアクション。

## Milestone 8: Kali相当の機能追加
- [x] `kali-menu` パッケージ導入(攻撃フェーズ別カテゴリメニュー。自前実装よりKali本家のものを利用)
- [x] Quokka Undercover(外見偽装トグル。`quokka-undercover` + デスクトップランチャー)
      — 一次実装は汎用テーマへの切り替えのみで、Kali Undercoverほどの
      Windows風UI再現はしていない
- [ ] Forensic mode 起動メニュー項目 — 機能自体(`noautomount noswap` 起動パラメータ)は
      live-boot標準機能なので手動指定すれば動くはずだが、専用のGRUBメニュー項目化は
      live-buildのbootloaderテンプレート上書きが必要で、検証環境がないと書き換えを
      誤ると起動不能になるリスクがあるため見送っている
- [ ] カスタムカーネル(無線注入パッチ等)— 対象外。Kali本家も専属チームでカーネルを
      個別ビルドしており、このプロジェクトの規模では現実的でない
- [ ] ARM/Raspberry Pi イメージ、NetHunter(Android版)、クラウドイメージ(AWS/Azure/GCP)、
      Kali Purple(防御版)相当のもの — 対象外。いずれも別プラットフォーム向けの
      独立したビルドパイプラインが必要で、"設定ファイルを足す"レベルの作業ではない

## Milestone 9: 初回起動体験・サポート機能(Kaliの"感動できる"部分への対応)
- [x] `quokka-welcome` — 初回ログイン時に一度だけ出るウェルカムダイアログ
      (zenity製。ドキュメントサイト/各機能への入り口をまとめた)
- [x] `quokka-tweaks` — Kaliの`kali-tweaks`に相当する設定ハブ
      (プロファイル表示・Undercoverトグル・無線IF一覧・VPN状態・壁紙リセット)
- [x] ドキュメントサイト(`docs/site/`)をISO内 `/usr/share/doc/quokka-os/site/` に同梱し、
      quokka-welcomeから直接開けるようにした
- [ ] 正直な制約: 本家 `kali-tweaks` はPython/newt製の本格的なTUIアプリ、
      Kaliのオンボーディングも公式ドキュメントサイト(Kali Docs)という巨大な
      裏付けがある。今回作った2本はzenityベースの軽量ダイアログであり、
      同水準の作り込みではない。実機起動での見た目・動作は未確認
