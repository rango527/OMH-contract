// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OMHERC20 is ERC20, Ownable {
  uint256 public constant FEEDOMINATOR = 10000;
  uint32 public burnFee = 200;

  mapping(address => bool) public isExcludedFromBurn;

  constructor(address _pool) ERC20("OMVERIAS", "OMH") {
    _mint(_pool, 17 * 10**9 * 10**18);   // 17 billion

    isExcludedFromBurn[_pool] = true;
  }

  function _transfer(address _from, address _to, uint256 _amount) internal override {
    if (_from.code.length == 0 && !isExcludedFromBurn[_from]) {
      uint256 burnAmount = calculateTokenFee(_amount, burnFee);
      uint256 tokensToTransfer = _amount - burnAmount;

      if (burnAmount > 0) 
        _burn(_from, burnAmount); 
      
      super._transfer(_from, _to, tokensToTransfer);
    } else {
      super._transfer(_from, _to, _amount);
    }
  }

  function calculateTokenFee(uint256 _amount, uint32 _fee) public pure returns (uint256 feeAmount) {
    feeAmount = (_amount * _fee) / FEEDOMINATOR;
  }

  function excludeFromBurn(address _account, bool _value) public onlyOwner {
    isExcludedFromBurn[_account] = _value;
  }

  function transferOwnership(address _newOwner) public override onlyOwner {
    super.transferOwnership(_newOwner);
    isExcludedFromBurn[_newOwner] = true;
  }
}