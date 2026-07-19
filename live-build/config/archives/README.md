# Kaliリポジトリ・オーバーレイ設定

Parrot OSと同じ方式: DebianをベースにKaliの膨大なペンテストツール群をaptソースとして追加する。
ゼロから600個以上のツールを個別にビルド/パッケージ化するのは非現実的なため。

## このディレクトリの中身

- `kali.list.chroot` — Kaliリポジトリのソースライン(kali-rolling)
- `kali.pref.chroot` — APTピン設定。Kaliのパッケージ優先度をDebianより低くし、
  Kaliリポジトリが原因でシステムの中核パッケージ(glibc, systemd等)が
  意図せず置き換わるのを防ぐ(Parrot OSも同様の思想でaptを運用している)

## 未完了: GPG鍵の追加が必要

**このサンドボックス環境はネットワークアクセスがないため、Kaliの署名鍵を取得できていません。**
実際にビルドする環境(ネットワークのあるDebianマシン)で以下を実行し、
`kali.key.chroot` としてこのディレクトリに配置してください。

```bash
wget https://archive.kali.org/archive-key.asc -O live-build/config/archives/kali.key.chroot
```

もしくは `kali-archive-keyring` パッケージのGPG鍵をエクスポートする方法でも可。
live-buildはこのディレクトリの `*.key.chroot` を自動でchroot環境のAPT鍵として登録する。
