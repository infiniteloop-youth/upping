# upping

uppingはpingベースのシンプルな死活管理システムです。
実行されると、pingを用いて相手との疎通を確認し、Slackに状態を投稿します。

## 前提

- ping
- awk
- sh
- SlackのIncomingWebhook
- cron or systemd-timer

upping単体では自動起動などは出来ませんのでご注意ください。

## 設定

設定は環境変数でおこないます。
uppingの本体である`upping.sh`に書いてもよし、`upping.sh`に書いてある設定をコメントアウトして環境変数で設定してもよし、です。

| キー | 内容  |
| ------- | -------- |
| TARGET_IP | 対象のIPアドレス |
| TARGET_NAME | 対象の名前 |
| CHANNEL | 状態を通知するSlackのチャンネル |
| COUNT | ICMP echo requestパケットの送信回数 |
| WEBHOOK | SlackのIncomingWebhookアドレス |
| PING | pingコマンドへの絶対パス |
