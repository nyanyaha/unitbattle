# DAppsゲーム
ブロックチェーン（Ethereum）上で動作する簡単なゲームプロジェクトです。  
任意の文字列からランダムにパラメータを設定したユニットを生成し、他のユニットと対戦が行えます。  
以下の環境での動作を確認しております。

## version
solidity ^0.5.8  
Truffle v5.0.34  
Ganache v2.1.0  
-ブラウザCLを使用する場合
Vue.js 2.9.6
MetaMask 7.1.1
web3
truffle-contract

## セットアップ（macOS）

``` bash
# install npm
brew install npm

# Truffle
npm install -g truffle

# serve with hot reload at localhost:8080
npm run dev

# build for production with minification
npm run build
```

``` bash
# vue環境 install
npm install vue
npm install --global vue-cli
npm install web3
npm install truffle-contract

# 実行
npm run dev
# localhost:8080にブラウザでアクセス
```

