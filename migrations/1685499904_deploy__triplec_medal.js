const triplecMedal = artifacts.require("TriplecMedal"); // 这里要使用sol文件中合约的名字

module.exports = function(_deployer,_network,_account) {
  // Use deployer to state migration tasks.
  console.info(_account);
  if(_network=="dev"){
    _deployer.deploy(triplecMedal,"MEDAL.TripleC","MEDAL",{overwrite:false});
  }else if (_network=="bsctest"){
    _deployer.deploy(triplecMedal,"MEDAL.TripleC","MEDAL",{overwrite:true});
  }
};
