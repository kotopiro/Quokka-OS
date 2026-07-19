# Quokka OS — カラーパレット

ロゴ画像からピクセルサンプリングして抽出した正式カラー。

## コアカラー

| 用途 | Hex | 説明 |
|---|---|---|
| Background (base) | `#000410` | ほぼ黒に近いネイビー。ロゴの背景色そのもの |
| Background (elevated) | `#0A0F1E` | パネル・ターミナル背景・カード面 |
| Background (elevated 2) | `#111A2E` | ホバー状態・選択行 |
| **Primary Accent (Cyan)** | `#00CFFE` | ロゴのライン色。ブランドの顔 |
| Accent Dim | `#0088AF` | 非アクティブなアイコン、罫線 |
| Accent Glow | `#7BEFFF` | ハイライト・グロー効果・アクティブカーソル |
| Text Primary | `#E8FBFF` | 本文（純白ではなく僅かにシアン寄り） |
| Text Muted | `#5C7A8A` | 補助テキスト、コメント |

## セマンティックカラー（ツール表示・アラート用）

| 用途 | Hex | 説明 |
|---|---|---|
| Critical / Alert | `#FF3B5C` | 脆弱性: Critical、エラー |
| Warning | `#FFB020` | 脆弱性: Medium、警告 |
| Success / Open Port | `#39FF88` | スキャン成功、Up状態 |
| Info | `#00CFFE` | 通常情報（プライマリと共用） |

## デザイン方針

- 背景は常に `#000410` 系のニアブラックネイビーで統一（Kali の紫、Parrot の緑とは明確に差別化）
- シアン一色を基調としたモノクロマティック配色 + セマンティックカラーのみ例外
- グロー/ネオン表現（box-shadow / drop-shadow で `#00CFFE` を薄く発光させる）をUI全体のシグネチャに
- フォントは等幅系（例: JetBrains Mono / Fira Code）でターミナル文化との親和性を優先

## CSS変数（GTKテーマ・Webダッシュボード共通で使う想定）

```css
:root {
  --quokka-bg: #000410;
  --quokka-bg-elevated: #0A0F1E;
  --quokka-bg-elevated-2: #111A2E;
  --quokka-cyan: #00CFFE;
  --quokka-cyan-dim: #0088AF;
  --quokka-cyan-glow: #7BEFFF;
  --quokka-text: #E8FBFF;
  --quokka-text-muted: #5C7A8A;
  --quokka-critical: #FF3B5C;
  --quokka-warning: #FFB020;
  --quokka-success: #39FF88;
}
```
