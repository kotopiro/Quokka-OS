# Quokka OS — VMイメージビルド (Milestone 6)

`live-build` で作った Quokka OS の ISO から、VirtualBox(.ova) と QEMU(.qcow2) 向けの
VM専用イメージを自動生成する [Packer](https://www.packer.io/) テンプレート。

**ここもサンドボックスでは実行不可**(仮想化・ネットワーク不可のため)。実機/CI環境で実行する前提。

## 前提

- `live-build/` で ISO をビルド済み(`live-build/live-image-amd64.hybrid.iso` 等)
- Packer 本体 + `qemu` / `virtualbox` プラグイン
- QEMU/KVM ビルドの場合は KVMが使えるLinuxホスト、VirtualBoxビルドの場合はVirtualBox本体

## 使い方

```bash
cd vm-build
packer init .

ISO=../live-build/live-image-amd64.hybrid.iso
SUM=$(sha256sum "$ISO" | awk '{print "sha256:"$1}')

packer build \
  -var "iso_path=$ISO" \
  -var "iso_checksum=$SUM" \
  .
```

- `output/qemu/` に `.qcow2` が生成される
- VirtualBoxビルダーの出力先に `.ova` が生成される(VMware Workstation/Fusionでもインポート可能)

## 中身

| ファイル | 役割 |
|---|---|
| `variables.pkr.hcl` | ISOパス、VMスペック(メモリ/CPU/ディスク)などの変数定義 |
| `build.pkr.hcl` | QEMU/VirtualBoxの2ビルダー定義 + Guest Additions/QEMU Guest Agentの導入 |
| `http/preseed.cfg` | Debianインストーラの無人インストール定義(VM専用。パーティション全消去前提なのでISO直接インストールには使わないこと) |

## 未確定・要検討

- デフォルトの `quokka`/`quokka` というユーザー名・パスワードは検証用の仮値。
  配布用イメージでは初回起動時にパスワード変更を強制する仕組みを入れるべき
- VMware専用の `.vmx` 直接出力(vmware-isoビルダー)は未対応。今はVirtualBoxの `.ova` を
  VMwareでもインポートする方式でカバーしている
- ARM版(Apple Silicon Mac等)のVMイメージは未検討
