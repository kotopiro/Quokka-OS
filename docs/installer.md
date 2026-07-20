# Quokka OS Installer

## 方針
- ISO では `live-build` の `--debian-installer live` を使い、live filesystem をそのままターゲットへ転写する
- GUI インストーラを同梱し、ライブセッションから `debian-installer-launcher` で起動できるようにする
- Debian Installer の既定値は `live-build/config/includes.installer/preseed.cfg` で管理する

## 追加したもの
- `live-build/config/includes.installer/preseed.cfg`
- `live-build/config/includes.chroot/usr/share/applications/quokka-installer.desktop`
- `live-build/config/package-lists/quokka.list.chroot` への `debian-installer-launcher` 追加

## 注意
- インストーラ画面そのものの見た目は Debian Installer/GTK テーマ依存で、LightDM のような全面ブランド差し替えはしていない
- 実機/VM で、ライブセッション起動 → インストーラ起動 → ディスク書き込み → 再起動までを要通し確認
