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

## Milestone 10: OSセキュリティハードニング
- [x] カーネル/sysctlハードニング (`live-build/config/includes.chroot/etc/sysctl.d/90-quokka-hardening.conf`)
- [x] SSHハードニング強化(既存の`PermitRootLogin no`に加え、認証試行回数制限・X11転送禁止等を追加。
      ペンテスト業務で使うTCPフォワーディング/トンネリングは塞いでいない)
- [x] fail2ban導入(sshdへのブルートフォース対策)
- [x] AppArmor導入・有効化
- [x] auditd導入・有効化
- [x] パスワード品質ポリシー(`libpam-pwquality`、最低10文字+英大小文字・数字混在)
- [x] セキュリティアップデートの自動適用(`unattended-upgrades`、securityリポジトリのみ対象)
- [x] USBGuard導入
- [x] 正直な制約(解消): 初回実機起動後に手動で`usbguard generate-policy`を実行する
      必要がある点について、`quokka-tweaks`に導線(「USBGuardに今のUSB機器構成を
      許可登録する」)を追加し、GUIから実行できるようにした
- [ ] 正直な制約: 今回はswap無効化・journald揮発化(ログの非永続化)は見送った。
      機密データの残留リスクは下がるが、トラブルシューティングやクラッシュ時の
      データ保全という通常業務への支障が大きいと判断したため
      (別途「秘匿性最優先」の要件が出た場合は再検討)
- [ ] 実機での動作確認(fail2ban誤検知・AppArmor拒否ログの有無等)は未実施
- [ ] `docs/site/roadmap.html`等のドキュメントサイトHTMLはこの変更に追随して
      いない(手動更新が必要)

## Milestone 11: 独自要素・ブランド強化(他OSにない機能で差別化)
- [x] `quokka-report` — Quokka OS独自のペンテストレポート生成ツール新規実装
      (`init` / `add-finding` / `build` / `list`)。Kali/ParrotはDradis/Faraday等の
      外部重量級ツールに頼るのが一般的だが、pandocのみに依存する軽量な自前実装とした。
      `palette.md`のセマンティックカラー(Critical/Warning/Success)をそのまま
      深刻度バッジの色に流用し、生成後のHTMLレポート自体にもブランドが一貫する設計
- [x] Firefox ESRの起動ページをQuokka OSブランド調のカスタムページに変更
      (`policies.json` + `/usr/share/quokka-os/homepage/index.html`)。
      ドキュメントサイト・ツール一覧・ロードマップへの導線をブラウザ起動直後に提示
- [x] `quokka-welcome`に`quokka-report`の案内項目を追加
- [ ] 正直な制約: `policies.json`の設置パス(`/etc/firefox-esr/policies.json`)は
      Debianパッケージの慣例に基づく想定であり、実機ビルドでの動作確認は未実施
- [ ] 正直な制約: `quokka-report`はMarkdown→HTML変換をpandocに依存しており、
      自前のMarkdownパーサは実装していない
- [ ] 未着手: カーソルテーマ・追加壁紙バリエーション・Thunarカスタムアクション
      (「Quokka Actions」右クリックメニュー)・ログイン/ログアウト時のサウンド等の
      視覚面の追加要素は今回のスコープでは着手していない

## Milestone 12: 視覚要素の追加(カーソル・右クリックアクション・サウンド)
- [x] 追加壁紙2種(`quokka-wallpaper-circuit-1920x1080.png` / `-gradient-...png`)を生成し、
      `quokka-tweaks`から3種類を選択できるように変更
- [x] カーソルテーマ「Quokka-Cyan」— `left_ptr`(標準の矢印ポインタ)のみ独自デザインし、
      それ以外は`Inherits=Adwaita`で継承する一次実装。ビルド時に`xcursorgen`で
      コンパイルし、システム既定(`/usr/share/icons/default/index.theme`)に設定する
      フック(`0130-quokka-cursor.hook.chroot`)を追加
  - [ ] 正直な制約: `xcursorgen`を提供するパッケージ名(`x11-apps`と仮定)はこの
        サンドボックス環境では確認できず、Debian bookwormでの実際のパッケージ名は要確認
  - [ ] 実機でのカーソル表示・ホットスポット位置の確認は未実施
- [x] Thunar右クリックメニュー「Quokka Actions」3項目を追加(`etc/skel/.config/Thunar/uca.xml`)
  - ここでターミナルを開く
  - SHA256ハッシュを計算(`quokka-hash`)
  - quokka-reportのevidenceに追加(`quokka-evidence-add`、`quokka-report add-evidence`新設)
- [x] ログインチャイム音を追加(`ffmpeg`のsine波で生成した独自の短い2音チャイム、
      `/etc/xdg/autostart/quokka-login-sound.desktop`でセッション開始時に再生)
  - [ ] 正直な制約: 実際の音質・音量バランスはこのサンドボックス内では聴覚確認できておらず未検証
  - [ ] ログアウト音は見送り: `xfce4-session`にはログアウト前フックの標準的な仕組みが無く、
        `xfce4-session-logout`バイナリのラップ等は将来のパッケージ更新で上書きされる・
        ログアウトフロー自体を壊すリスクがあり、無理に実装しないほうが安全と判断

## Milestone 13: UIの独自性強化(アプリケーションメニュー統合)
- [x] `index.theme`のCursorThemeが古い`Adwaita`参照のままだったのを`Quokka-Cyan`に修正
      (branding/desktop側・live-build側の両方)
- [x] `quokka-welcome` / `quokka-report`にアプリケーションランチャー(.desktop)を追加し、
      アプリケーションメニューから起動可能に(`quokka-tweaks`/`quokka-undercover`は既存)
- [ ] 未着手・検討中: xfwm4のウィンドウ装飾(タイトルバー・ボーダー)は現状`Arc-Dark`
      (サードパーティ)のまま。Quokka独自にするには本格的なピクスマップ作成が必要で、
      GTKテーマと同じ「既存テーマを配色だけ上書きする」方式を取るにしても、
      Arc-Darkの実アセットがこのビルド環境(サンドボックス)には存在せず、
      実際のXFCEセッションでの表示確認もできないため、壊れた見た目で出荷するリスクを
      避けて今回は見送り。次にPCが直った際に実機で試すのが安全
- [ ] 未着手: quokka-report等それぞれに専用の個別アイコン(現状は共通ロゴを流用)

## Milestone 14: 見た目の方針転換(Qogirテーマ採用)
- ユーザーから「(シアン発光ハッカー風の)今の見た目はださい。FreeBSD/Linux Mint/Zorin OSの
  ような見た目にしたい。GitHub等の既存リソースも活用してほしい」というフィードバックを受け、
  自作CSSの「Quokka-Dark」テーマ運用を終了し、[vinceliuice/Qogir-theme]
  (https://github.com/vinceliuice/Qogir-theme, GPL-3.0, 1.7k+ stars, XFCE公式対応)
  に切り替え
- [x] `0140-quokka-qogir-theme.hook.chroot`を新設。ビルド時にGitHubから
      Qogir-theme(GTK+xfwm4、`--tweaks round`で角丸ウィンドウ)と
      Qogir-icon-theme(アイコン)を取得してインストール
- [x] `xsettings.xml`(GTKテーマ・アイコンテーマ)・`xfwm4.xml`(ウィンドウ装飾)を
      Qogir-Darkに変更。これにより長らく未解決だった「タイトルバーがArc-Darkのまま」
      問題も解消される見込み
- [x] カーソルのみ独自の`Quokka-Cyan`を維持(色の主張はカーソル1点に絞り、
      全体は落ち着いたトーンにする方向性)
- [x] 壁紙の既定設定が実は未配線(スタブ実装)だったバグを発見・修正
      (`xfce4-desktop.xml`を新設)
- [x] 基本パッケージリストから`arc-theme`/`papirus-icon-theme`を削除
      (Qogir導入失敗時のみフック内でPapirus-Darkにフォールバック)
- [ ] 正直な制約: このサンドボックス環境ではXFCEセッションを実際に起動できず、
      見た目の最終確認ができていない。install.shがXFCE向けにxfwm4フォルダを
      自動生成する前提で進めているが、vinceliuice系テーマ共通の既知の挙動を
      根拠にした未検証の想定
- [ ] 正直な制約: Qogirの配色バリエーションは default(青)/manjaro(緑)/ubuntu(橙)の
      3種のみで、Quokka独自のシアン(#00CFFE)に完全一致する配色は無い。
      今回はdefault(青)を採用。Zorin OSの既定も青系のため方向性としては近いが、
      「らしさ」としてのシアンはカーソルと壁紙・ロゴのみに残る形になる
- [ ] 未着手: パネル(タスクバー)の配置は現状Kali/Parrot的な上部パネルのまま。
      Zorin/Mintのような下部パネル+中央寄せレイアウトへの変更は別途方針確認が必要
- [ ] 実施済みの`quokka-dark-gtk`(自作CSSテーマ)は削除せず残置(将来的な
      アクセントカラー調整用の参考資料として)

## Milestone 15: パネルを下部に変更(Mintスタイル)
- [x] ユーザー確認の上、パネル位置を上部から下部に変更
      (`position`プロパティを`p=6`→`p=12`に変更。span-monitors=true・length=100%は維持し
      画面解像度に依存しない全幅パネルとした)
- [x] プラグイン順序(メニュー→ランチャー→タスクリスト→…→時計→アクション)は
      そのまま維持。これはLinux Mint(Cinnamon)の下部パネルと同じ並び方
- [ ] 正直な制約: `position`の`p=`値(ゲート位置を示す数値)はXFCEのバージョンや
      情報源によって記載が一致しないことがあり(複数のフォーラム情報で`p=10`〜`p=12`と
      揺れがあった)、`p=12`は「フル幅の下部パネルで動作したという実例」を根拠にした
      best-effort。実機でパネルが画面外に出る等の不具合があれば、この値の再調整が必要
- [ ] Zorin OS本来の「中央に寄った浮遊ドック」スタイルは、画面解像度を前提にした
      固定x座標が必要になり解像度非依存にできないため見送り、Mint的な全幅下部パネルを採用

## Milestone 16: Calamaresインストーラーの配色をQogir方針に合わせて調整
- [x] `branding.desc`の`sidebarTextSelect`/`sidebarTextCurrent`をシアン(`#00CFFE`)から
      新方針の青(`#4C8DFF`、Qogir default系)に変更。サイドバー背景・ロゴは従来通り
      (シアンはロゴマークのみに残す)
- [ ] 実機・実際のCalamares起動画面での確認は未実施(このサンドボックスでは検証不可、
      branding.desc冒頭のコメントに記載済みの制約と同じ)

## Milestone 17: GRUB/Plymouthの配色もQogir方針に統一
- [x] GRUBテーマ(`theme.txt`)のタイトル・選択項目・プログレスバー色をシアンから
      青(`#4C8DFF`)に変更。ロゴ自体は従来通りシアンのまま
- [x] Plymouth起動スプラッシュ(`quokka.script`)のプログレスバー塗りつぶし色も同様に青へ変更
- [ ] 実機での起動確認は未実施

## Milestone 18: システム管理系GUIツールを追加(「ちゃんとしたOS」感の底上げ)
- [x] **Timeshift**(システム復元ポイント。Linux Mintの代表機能)を追加
- [x] **Synaptic**(GUIパッケージ管理)を追加
- [x] **GUFW**(ファイアウォール設定GUI)を追加。既定では`ufw`を有効化せず出荷し、
      有効化はユーザーの判断に委ねる
- [x] **quokka-about**(「Quokka OSについて」パネル)を新規実装。ロゴ・OS/カーネル情報を
      表示するzenityダイアログで、アプリケーションメニューと`quokka-tweaks`両方から起動可能
- [x] `quokka-tweaks`に「about」「system-tools」項目を追加、`quokka-welcome`にも案内を追加
- [ ] 正直な制約: `quokka-vpn-killswitch`は独自のnftablesテーブル(`inet quokka_vpn`)を
      直接操作しており、`ufw`は別途自分のルールセットを管理する設計。理論上は競合しないが、
      両方を同時に有効化した場合の実機での相互作用は未検証
- [ ] 正直な制約: `quokka-tweaks`から呼んでいる`timeshift-gtk`/`pkexec synaptic`/`pkexec gufw`
      などの起動コマンド名・特権昇格の扱いは各パッケージの実際の`.desktop`ファイル実装に
      依存する部分があり、実機での動作確認は未実施(コマンド名が違えば要修正)

## Milestone 19: 初回起動画面の確認
- ライブISOの起動メニュー(Try Quokka OS / Install Quokka OS 等)は、live-build標準の
  ブートローダーテンプレートがそのまま使われており、テキスト自体はQuokka専用に
  書き換えていない(配色・ロゴはGRUBテーマ経由で反映される想定)
- 「Forensic mode」起動メニュー項目は既存の制約通り未着手のまま
  (Milestone 8参照。ブートローダーテンプレート書き換えは実機検証なしでは
  起動不能リスクがあるため見送り継続)

## Milestone 20: Quokka Fire(独自Tor強制ルーティングツール)を本プロジェクトに実装
- 以前チャット内で標準的な成果物として提示していた「Fire Quokka」(iptables版)は
  今回アップロードされたプロジェクト本体には未反映だったため、`quokka-vpn-killswitch`と
  同じnftablesの作法に揃えて`quokka-fire`として新規実装
- [x] `quokka-fire`(CLIバックエンド): start/stop/status/change/panic
- [x] `quokka-fire-gui`(Python3 + GTK3によるGUIフロントエンド): 状態表示・トグル・
      回線変更・パニックボタンをウィンドウで操作可能に。特権操作はpkexec経由
- [x] アプリケーションランチャー・`quokka-welcome`への案内を追加
- [ ] 正直な制約: GTK3 Python実装は実際のXFCEセッションで起動確認できておらず、
      pkexecの認証プロンプトの挙動・nftables NATチェーンの実際の動作は実機検証が必要

## Milestone 21: 他OSとの比較調査(Parrot OS由来のギャップ)
- Parrot OSとの比較調査により、Quokka OSに無い代表的な独自ツールを2点特定し追加:
  - [x] **Wifiphisher** — GUI操作可能なWi-Fiソーシャルエンジニアリング/不正AP作成ツール
  - [x] **ZuluCrypt** — LUKS/VeraCrypt/TrueCrypt対応のGUI暗号化ツール
- [ ] 未着手(backlog): Parrot/多くの現代ディストロは**インストール時のディスク暗号化を
      既定で有効/推奨**にしている。現状Quokka OSは`calamares-settings-debian`の
      Debian既定設定に任せたままで、暗号化がデフォルトでオンではない可能性が高い。
      Calamaresのpartitionモジュール設定(`partition.conf`)のカスタマイズが必要だが、
      ブートローダー同様にインストーラーの中核設定であり、実機検証なしに変更すると
      インストール自体が壊れるリスクがあるため、今回は変更せず調査結果の記録のみに留めた

## Milestone 22: UI改善の続き(欠落アセット修正・メニュー刷新・日本語フォント)
- [x] **欠落アセットの発見・修正**: `quokka-fire-indicator`(genmonパネル表示)自体は
      既に実装済みだったが、そこから参照される`logo-gray.png`(無効時アイコン)の
      実体が無かった。グレースケール版を新規生成して補完
- [x] アプリケーションメニューを基本の`applicationsmenu`から検索機能付きの
      **Whiskermenu**(`xfce4-whiskermenu-plugin`)に変更。Mint/Zorinのような
      使い勝手に近づけた
- [x] **日本語表示の欠落に気づき修正**: これまで大量の日本語UI文言(zenityダイアログ等)を
      追加してきたにもかかわらず、CJK対応フォントパッケージが一つも入っていなかった。
      `fonts-noto-cjk`を追加し、`xsettings.xml`・LightDMグリーターのフォント指定を
      `Noto Sans CJK JP`に変更(この修正が無いと日本語が文字化け/豆腐表示になっていた
      可能性が高い)
- [ ] 検討したが見送り: Plank等のドック追加。パネルを下部に変更した(Milestone 15)ことで
      タスクバーと役割が重複し、Mint的な「パネル1本で完結」という落ち着いた方向性から
      外れると判断したため
- [ ] 次の候補(未着手): 通知ポップアップ(xfce4-notifyd)のテーマ・配色は未確認
- [ ] 正直な制約: genmonプラグインの`update-interval`等のxfconfプロパティ名は
      xfce4-genmon-pluginの実際のスキーマに基づくbest-effortで、実機での動作は未検証

## Milestone 23: 通知ポップアップ(xfce4-notifyd)の設定を追加
- [x] `xfce4-notifyd.xml`を新規作成。表示時間(10秒)・Do Not Disturb初期値(オフ)・
      スライドアウトアニメーションを設定
- [x] 通知の見た目自体はGTKテーマ(Qogir-Dark)を自動継承するため、テーマ関連の
      プロパティは明示的に指定していない
- [ ] 意図的に指定しなかった: 表示位置(`notify-location`)。パネル位置(Milestone 15)と
      同様、xfconfの数値enumがバージョン/ディストロで意味が揺れている実例が複数あり、
      誤指定のリスクの方が大きいと判断し、xfce4-notifyd自身の既定値に委ねた

## Milestone 24: 実用機能・ドキュメント整備・遊び心
- [x] **印刷(CUPS)・Bluetooth(blueman)・電源管理(TLP)・夜間モード(Redshift)・
      クリップボード履歴(xfce4-clipman-plugin)**を追加。cups/bluetooth/tlpは
      サービスを有効化するフックも追加(`0150-quokka-desktop-essentials.hook.chroot`)
- [x] **manページ**の欠落分3件を新規作成: `quokka-hash` / `quokka-evidence-add` /
      `quokka-fire-indicator`。他の主要コマンド(quokka-report / quokka-fire /
      quokka-fire-gui / quokka-vpn-killswitch / quokka-monitor / quokka-tweaks /
      quokka-about / quokkafetch / quokka-undercover / quokka-welcome)には
      既にmanページが揃っていた
- [x] トップレベル`README.md`の古い記述(xfwm4=Arc-Dark等)を修正し、
      独自ツール群への導線を追記(詳細な変更履歴は本roadmap.mdに集約する方針を明記)
- [発見] **遊び心**: 隠しコマンド `quokka` が既に実装済みだった。ターミナルで実行すると
      ランダムなひとことメッセージを表示し、1/20の確率でレア演出(ASCIIアート)が出る
- [ ] 未着手のまま(backlog): 手動でパネルに追加した`clipman`のクリップボード履歴保持数
      (デフォルト値)や、ホットキー割り当てのカスタマイズは未調整

## Milestone 25: 遊び心の追加第2弾
- [x] **quokka-wisdom**(新規隠しコマンド): `fortune`+`cowsay`でクオッカが一言くれる。
      専用の一言集(`/usr/share/games/fortunes/quokka`、ペンテスト/セキュリティ文化+
      クオッカネタ)と、quokkafetchと同じ顔モチーフの`cowsay`用ASCIIアート
      (`quokka.cow`)を新規作成
- [x] `sl`(定番のタイポジョークパッケージ)を追加
- [x] `sudo`の`insults`オプションを有効化(パスワード間違い時に軽口を叩く、
      sudoの正式な古典機能)
- [x] fortuneデータベースのコンパイル(`strfile`)をビルドフックに追加
      (`0160-quokka-fun.hook.chroot`)
- [ ] 正直な制約: `strfile`のフォーマットや`cowsay`の`.cow`ファイル記法の細部は
      実際に`fortune`/`cowsay`コマンドを実行して確認できておらず、構文ミスの
      可能性はゼロではない

## Milestone 26: 日本語入力(IME)の欠落を発見・修正
- [x] **重大な見落としを発見**: 表示側(Noto CJKフォント、Milestone 22)は直したが、
      日本語を「入力する」ためのIME(fcitx5等)が一つも入っておらず、日本語の
      文字が読めても打てない状態だった。`fcitx5` + `fcitx5-mozc`一式を追加し、
      `/etc/environment`でGTK_IM_MODULE等を設定、autostartエントリも追加
- [x] `quokka-tweaks`に**USBGuardの初回設定導線**を追加(「USBGuardに今のUSB機器構成を
      許可登録する」)。Milestone 10で残っていた手動運用の課題を解消
- [ ] 正直な制約: fcitx5のautostart・環境変数設定は実機のXFCEセッションで動作確認できておらず、
      Debianパッケージが独自に用意する設定(im-config等)と重複・競合する可能性はゼロではない

## Milestone 27: Kali/Ubuntuとの比較調査
- [x] **exploitdb(searchsploit)** — Kaliでは標準搭載だが未導入だったオフライン
      エクスプロイト検索ツールを追加
- [x] **gnome-disk-utility** — Ubuntu(usb-creator)/Mint(mintstick)相当の
      USBイメージ書き込み機能。Debian標準リポジトリでの可用性を優先しこちらを採用
- [x] **ライブUSB永続化(persistence)の手順書**(`docs/persistence.md`)を新規作成。
      Kali/Ubuntuにある機能(live-boot標準機能)だが、Quokka OS側では手順書のみで
      自動化ツールは未実装
- [ ] 検討したが見送り: Kaliの`kali-tweaks`(リポジトリ切り替え・ハードニングモード等)
      相当の機能。Quokka OSは独自のリポジトリ運用方針のため直接の対応物は不要と判断

## Milestone 28: 【重要】Kali標準カテゴリの大きな見落としを発見・修正
- これまでの比較調査は個別ツール単位(Wifiphisher、searchsploit等)で行っていたが、
  改めて**Kaliの標準メタパッケージカテゴリを網羅的に棚卸し**したところ、
  主要カテゴリが複数丸ごと抜け落ちていたことが判明した
- [x] **kali-tools-exploitation**(Metasploit Framework等) — これまで一切導入されて
      いなかった。ペンテスト用OSとして最も基本的なカテゴリの欠落
- [x] **kali-tools-wireless**(aircrack-ng等) — これも未導入だった。既存の
      `quokka-monitor`(モニターモード切り替えツール)と対になる実行部隊が
      無い状態だったことになる
- [x] kali-tools-social-engineering(SET等)
- [x] kali-tools-post-exploitation
- [x] kali-tools-database
- [x] kali-tools-crypto-stego
- [x] kali-tools-fuzzing
- [x] kali-tools-gpu(hashcat等。実際のGPUアクセラレーションには別途ドライバ対応が必要)
- [ ] 正直な制約: これでKali公式の主要カテゴリはほぼ網羅したはずだが、「本当に
      漏れが無いか」の最終確認(Kali公式のカテゴリ一覧との一対一突き合わせ)は
      未実施。今後さらに漏れが見つかる可能性は残る

## Milestone 29: Kali公式メタパッケージ一覧との最終突き合わせ(完了)
- `https://www.kali.org/tools/kali-meta/` を実際に取得し、Kali公式の全カテゴリ一覧
  (kali-tools-*)と現状のパッケージリストを一対一で突き合わせた
- [x] **kali-tools-detect**(NIST CSF: DETECT)
- [x] **kali-tools-hardware**(ハードウェア攻撃・JTAG/ファームウェア解析)
- [x] **kali-tools-identify**(NIST CSF: IDENTIFY。amass/spiderfoot/maltego等)
- [x] **kali-tools-protect**(NIST CSF: PROTECT。ClamAV等の防御系も含む)
- [x] **kali-tools-recover**(NIST CSF: RECOVER。データ復旧系)
- [x] **kali-tools-respond**(NIST CSF: RESPOND)
- [x] **kali-tools-voip**(VoIP攻撃系)
- [x] **kali-tools-top10**(定番ツールの安全網。burpsuite/netexec等の取りこぼし防止)
- [x] **kali-tools-windows-resources**(mimikatz/powercat等、Windows/AD侵入用)
- 確認事項: kali-tools-802-11 / kali-tools-bluetooth / kali-tools-rfid / kali-tools-sdr は
  既存の`kali-tools-wireless`が依存関係として自動的に含むため、個別追加は不要と判断
- **これでKali公式の`kali-tools-*`カテゴリは全て網羅した**(kali-linux-arm/nethunter/wsl等の
  プラットフォーム別メタパッケージは既存の対象外方針の通り除外)

## Milestone 30: 効果音パックの拡充(全6ジャンル)
- [x] ログイン効果音を1種類から**6ジャンル**に拡充(ffmpegによる合成音):
      標準(2音チャイム) / chiptune(8bit) / orchestral(オーケストラ風) /
      synth(EDM風上昇音) / rock(パワーコード) / ambient(パッド音)
- [x] `quokka-tweaks`に選択項目を追加。選んだジャンルは`~/.config/quokka/login-sound`に
      保存され、選択時にプレビュー再生もされる
- [x] `quokka-fire panic`実行時に専用の警告音(`panic.ogg`)を鳴らすようにした
- [ ] 検討したが見送り: 本物のMIDI再生(`.mid`ファイル)。fluidsynth+サウンドフォントが
      追加で必要になり依存関係が重くなること、実機での音質・遅延を確認できないことから、
      軽量なffmpeg合成音のバリエーションで対応する方針とした
- [ ] 正直な制約: `quokka-fire panic`はroot権限で動作するため、`paplay`が一般ユーザーの
      PulseAudioセッションに届かず鳴らない可能性がある(実機での動作未検証)
- [ ] 正直な制約: 全ての音はffmpegの正弦波合成によるシンプルな効果音であり、
      本格的な「楽器の音」ではない(このサンドボックス環境で本物の音源/
      サウンドフォントを試すことができないため)

## Milestone 31: ドキュメントサイト(docs/site/)の刷新
- これまでOS本体のテーマはQogir方針に転換してきたが、`docs/site/`の11ページは
  旧来のシアン発光デザインのまま放置されていた(旧デザインの「顔」を差し替え忘れていた)
- [x] 全11ページのCSSを一括置換: グロー/text-shadow効果を除去、アクセントカラーを
      シアンから青(`#4C8DFF`)に、フォントをJetBrains Mono一本槍から
      `Noto Sans CJK JP`(本文)+等幅(コードのみ)に変更
- [x] `palette.html`のデザイン方針セクションを実際の方針(Qogir採用・restrained cyan)に
      書き換え(旧内容は「グロー/ネオンをシグネチャに」という今と矛盾する記述だった)
- [x] `roadmap.html`を最新の`roadmap.md`(Milestone 30まで)から`pandoc`で再生成
- [x] `index.html`の内容を全面更新(Quokka独自ツール一覧・秘匿性/ハードニング・
      現在のディレクトリ構成を反映。旧内容はMilestone 9相当で止まっていた)
- [ ] 未着手(backlog): `desktop-environment.html` / `distro-decision.html` /
      `installer.html` / `live-build.html` / `openvpn.html` / `pentest-config.html` /
      `tool-selection.html` / `vm-build.html` の8ページは**CSS(見た目)のみ**更新済みで、
      本文の内容そのもの(Qogir採用やquokka-fire等への言及)はまだ古いまま。
      全ページの内容を最新化するには対応するdocs/*.mdの本文更新も含めた
      まとまった作業が必要
- [ ] 正直な制約: `wkhtmltoimage`で簡易的に見た目は確認したが、実際のブラウザでの
      表示・リンク遷移の網羅的な確認はできていない

## 修正: GitHub Actionsワークフローの構文エラー
`.github/workflows/build.yml` の `if:` 条件式で `secrets.QUOKKA_GPG_PRIVATE_KEY != ''` を
直接使っていたが、GitHub公式ドキュメント記載の通り **`secrets`コンテキストは`if:`条件式内では
参照できない**制約に引っかかっていた(`Unrecognized named-value: 'secrets'`)。
job-level `env:` に `HAS_GPG_PRIVATE_KEY` / `HAS_GPG_KEY_ID` という真偽値を一度経由させ、
`if:` 側はそちらを参照するように修正した。
