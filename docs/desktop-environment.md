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

- `package-lists/quokka.list.chroot` で `task-xfce-desktop` を導入
- GTKテーマは `Quokka-Dark` を維持
- xfwm4 のウィンドウ枠は自作せず **Arc-Dark** を採用
- 既定パネルは **上部シングルパネル** にする

## Milestone 4 実装内容 (`branding/desktop/`)

| 資産 | 内容 | 配置先 |
|---|---|---|
| `quokka-dark-gtk/` | GTK3テーマ `Quokka-Dark` | `/usr/share/themes/Quokka-Dark/` |
| `xfce4-terminal/quokka.theme` | ターミナル配色スキーム | `/usr/share/xfce4/terminal/colorschemes/` |
| `xfce4-terminal/terminalrc` | 既定ターミナル設定 | `/etc/xdg/xfce4/terminal/` |
| `quokkafetch/` | 自作システム情報バナー | `/usr/local/bin/` + `/etc/profile.d/` |
| `lightdm/` | ログイン画面テーマ | `/etc/lightdm/` |
| `xfce4-defaults/xsettings.xml` | GTK/アイコン/フォントの既定 | `/etc/skel/.config/xfce4/xfconf/...` |
| `xfce4-defaults/xfwm4.xml` | Arc-Dark を使う xfwm4 既定値 | `/etc/skel/.config/xfce4/xfconf/...` |
| `xfce4-defaults/xfce4-panel.xml` | 上部シングルパネルの xfconf | `/etc/skel/.config/xfce4/xfconf/...` |
| `xfce4-panel/` | ランチャー/時計/セパレータ設定 | `/etc/skel/.config/xfce4/panel/` |

## 未検証事項

- `arc-theme` の xfwm4 見た目は実機/X11 環境で要確認
- パネル plugin ID / 初回ログイン時レイアウト復元は XFCE 実機で要確認
- `papirus-icon-theme` の availability はネットワーク環境で要確認
