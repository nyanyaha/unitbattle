var UnitFactory = artifacts.require("./UnitFactory.sol");

module.exports = function(deployer) {
  deployer.deploy(UnitFactory);
};
