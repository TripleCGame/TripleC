安装nodejs
1.vscode安装solidity插件和SCStudio安全分析插件，按F5可以快速编译
2.安装solc编译环境   npm install -g solc
3.安装truffle  npm install -g truffle
4.安装ganache本地链，官网https://trufflesuite.com/ganache/下载安装，直接启动即可
5.安装truffle-flattener npm intall -g truffle-flattener



准备工作：
1.将钱包私钥放到.env文件中
2.修改truffle-config.js,将私钥写入变量priviteKeys中，配置网络环境等
3.执行truffle create migration develop_triplec_medal，自动创建deploy脚本，修改脚本


开始部署：
1. 部署到本地网络
truffle migrate --network dev
2. 部署到公链
truffle migrate --network bsc/bsctest
3.truffle-flattener ./contracts/medal/TriplecMedal.sol --output ./deployment/TriplecMedal.full.sol 
然后删除fullsol中的多余的//SPDX-License-Identifier: MIT，最后将full.sol文件通过区块链浏览器上传到合约源码中
