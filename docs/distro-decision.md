# ベースディストリビューション決定

## 結論: **Debian (testing/bookworm系)** をベースにする

Kali Linux・Parrot OS と同じ選択。理由は以下の通り。

## 比較

| 候補 | メリット | デメリット |
|---|---|---|
| **Debian** ✅採用 | ・Kali/Parrotの資産(ツールのapt化ノウハウ、live-buildレシピ)がほぼそのまま流用できる<br>・`debian-live` (live-build) がISO/VM両対応で成熟<br>・Kaliリポジトリをオーバーレイすれば1000+のpentestツールを即座にaptで使える<br>・情報量・フォーラム・ドキュメントが最も豊富 | ・パッケージがやや古い(testingを使えば緩和可) |
| Arch (BlackArch方式) | ・ローリングリリースで常に最新ツール<br>・AURで柔軟 | ・ISO/VMビルドの定型ワークフローがDebianほど整備されていない<br>・初心者ユーザーへの敷居が上がる |
| Fedora | ・SELinuxなどセキュリティ機能が強い | ・pentestツールのパッケージ資産がKali/Parrotほど無く、自前ビルドが激増する |

## 実装方針

- ビルドツール: `live-build` (Debianの公式ライブイメージビルドシステム。Kaliもこれを使用)
- パッケージソース: Debian本体 + **Kaliのツールリポジトリをオプトインでオーバーレイ**(車輪の再発明を避ける)
- カーネル: Debianのbackports kernelもしくはKali kernel(無線パケットインジェクション対応パッチ入り)を採用予定
- 配布形態:
  - **ISO**: `live-build` で直接生成 (Live USB / インストーラ両対応)
  - **VM版**: 同じISOを `packer` でVirtualBox/VMware/QEMU向けにビルドし、`.ova` / `.qcow2` として配布
- デスクトップ環境: 未定(次マイルストーンで検討。候補: XFCE=軽量・Kali標準、もしくはKDE)

この決定はブランディング作業には影響しないため、マイルストーン1と並行して次フェーズで着手可能。
