# OpenVPN 運用メモ

## 推奨手順
1. `.ovpn` を `/etc/openvpn/client/` に配置する
2. 資格情報が必要なら `/etc/openvpn/client/<name>.auth` を `chmod 600` で作る
3. CLI: `sudo openvpn --config /etc/openvpn/client/<name>.ovpn`
4. NetworkManager GUI を使う場合は `network-manager-openvpn` を利用する

## kill switch 併用例
```bash
sudo quokka-vpn-killswitch enable \
  --uplink wlan0 \
  --endpoint vpn.example.com \
  --vpn-if tun0 \
  --port 1194 \
  --proto udp
```

## 備考
- kill switch は VPN サーバーの到達先のみ uplink 側へ許可し、それ以外の平文外向き通信を遮断する設計
- 実運用では接続先 IP 変更・IPv6・社内 DNS などの要件に応じて nftables ルールを調整すること
