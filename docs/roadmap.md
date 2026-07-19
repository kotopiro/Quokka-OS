# Quokka OS — ロードマップ

## Milestone 1: ブランディング ✅
- [x] カラーパレット確定 (`branding/palette/palette.md`)
- [x] Plymouth起動画面テーマ (`branding/plymouth/quokka/`)
- [x] GRUBブートメニューテーマ (`branding/grub/quokka/`)
- [x] デスクトップ壁紙 1920x1080 (`branding/palette/quokka-wallpaper-1920x1080.png`)
- [x] ベースディストリ決定 (`docs/distro-decision.md`)
- [x] ロゴのSVG化(OpenCVで輪郭抽出→ベクターパス化。元画像とのIoU 0.93)
- [ ] GTK/Qtテーマへの配色反映(Milestone 4で着手)

## Milestone 2: 最小ISO起動 (bring-up)
- [x] `live-build` の設定リポジトリ作成(`live-build/`)
- [x] Debian base(bookworm)確定
- [ ] 実際にDebian環境で `lb build` を実行してISO生成(★ユーザー側での実施が必要。サンドボックスに実行環境なし)
- [ ] 最小構成でVirtualBox/QEMU上での起動テスト・Plymouth/GRUBテーマの表示確認

## Milestone 3: ツール選定・メタパッケージ化 ✅ 設計完了
- [x] 収録ツールの選定方針決定(`docs/tool-selection.md`。Kaliの`kali-tools-*`をQuokka独自カテゴリ名でラップ)
- [x] カテゴリ別package-lists作成(標準6カテゴリ + Full版限定2カテゴリ)
- [x] Kaliリポジトリのオーバーレイ設定(`live-build/config/archives/`)
- [ ] GPG鍵の実データ配置(★ネットワークのある環境で`kali.key.chroot`取得が必要)
- [ ] Full版ISOのビルド設定分岐(標準/Full 2種類のprofile化は未実装)

## Milestone 4: デスクトップ環境 & UIテーマ
- [x] DE選定(`docs/desktop-environment.md`。XFCE + LightDM確定)
- [ ] パレットに基づくGTKテーマ作成
- [ ] ターミナル配色(base16スキーム化)
- [ ] MOTD / neofetch風システム情報表示のカスタム
- [ ] ログイン画面(LightDM)テーマ

## Milestone 5: pentest特化設定
- [ ] ネットワークプロファイル(モニターモード切替スクリプト等)
- [ ] VPN/プロキシチェイン標準設定
- [ ] wordlist/rockyou等の同梱ポリシー決定

## Milestone 6: VM配布パイプライン ✅ 骨組み完了
- [x] `packer` テンプレート作成(`vm-build/`。QEMU→qcow2、VirtualBox→ova)
- [x] 無人インストール用preseed作成
- [ ] 実機での動作確認(★ユーザー側実施が必要)
- [ ] 初回起動時パスワード変更強制などのセキュリティ仕上げ

## Milestone 7: リリース・QA
- [ ] インストーラ動作確認
- [ ] チェックサム・署名付き配布
- [ ] ドキュメントサイト
