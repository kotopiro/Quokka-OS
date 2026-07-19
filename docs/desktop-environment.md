# デスクトップ環境の決定

## 結論: **XFCE**

## 理由

| 観点 | XFCE | 他候補との比較 |
|---|---|---|
| 軽量性 | Live USB起動・低スペックVMでも動く | KDEは重め、GNOMEはリソース消費が大きい |
| Kali/Parrot標準 | 両方ともXFCEが標準DE | ユーザーの移行コストが最小 |
| テーマ適用の柔軟性 | GTKテーマで細かくカスタム可能、パネル構成も自由 | GNOMEはカスタマイズに拡張機能依存で壊れやすい |
| pentestツールとの親和性 | ターミナル多用のワークフローとの相性が良い、パネルにターミナル/ツールランチャーを並べやすい | - |

## 適用方針

- `package-lists/quokka.list.chroot` で `task-xfce-desktop` を導入(設定済み)
- パネルレイアウト・アイコンテーマは別途 `branding/desktop/` で定義予定(未着手)
- ログイン画面(LightDM想定)のテーマも `branding/palette/palette.md` のカラーに合わせる(未着手)
- GTKテーマは `branding/palette/palette.md` のCSS変数を `gtk.css` に落とし込む形で実装予定(未着手)

## 未決定事項

- ログインマネージャはLightDM(Kali/Parrot標準)を踏襲する想定だが未確定
- パネルの初期レイアウト(上下どちらに配置するか等)は未検討
