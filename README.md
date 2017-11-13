# DMM.comのAPIを叩いてからw2vをやるスクリプト群
## 事前に導入するものなど
* mecab
* R

## 使い方
1. 00-settings.Rを実行、必要なライブラリを入れる
2. 01-collect-actress-data.Rを実行、女優のマスターを作る(結局使わなかったので省略可能)。
3. 02-collect-title-data.Rを実行、タイトルと女優の名前を収集する。
4. ./scriptで03_wakati.shを実行、mecabでタイトルを分かち書きする
5. 04-w2v.Rで学習、分散表現を得る。
