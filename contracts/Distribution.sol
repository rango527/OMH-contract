// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./OMHERC20.sol";

contract Distribution {
  using SafeERC20 for IERC20;

  struct OMH {
    uint256 percent;
    uint256 startAfter;
    uint256 months;
    uint256 numOfTimes;
    uint256 numOfWithdraws;
  }

  address public OMHToken;
  address public admin;

  uint256 public startDate;

  mapping (address => OMH) public holders;

  event Withdraw(
    address indexed caller,
    uint256 amount,
    uint256 withdrawDate
  );

  modifier onlyAdmin {
    require(msg.sender == admin, "caller is not admin");
    _;
  }

  constructor(uint256 _startDate) {
    admin = msg.sender;
    startDate = _startDate;
  }

  function withdraw() external {
    require(holders[msg.sender].percent > uint256(0), "invalid holder");

    (uint256 num, uint256 withdrawalAmount) = getWithdrawalAmount(msg.sender);
    require(num > uint256(0), "not time to withdraw or caller has already all withdrawn");

    IERC20(OMHToken).safeTransfer(msg.sender, withdrawalAmount);
    holders[msg.sender].numOfWithdraws += num;

    emit Withdraw(msg.sender, withdrawalAmount, block.timestamp);
  }

  function getWithdrawalAmount(address _holder) public view returns (uint256, uint256) {
    OMH memory _info = holders[_holder];

    if (_info.percent == uint256(0) || _info.numOfWithdraws >= _info.numOfTimes) {
      return (uint256(0), uint256(0));
    }

    uint256 num = 1;
    // 2628029: one month per seconds
    uint256 withdrawTime = startDate + 2628029 * (_info.startAfter + _info.months * _info.numOfWithdraws);
    if (block.timestamp < withdrawTime) {
      return (uint256(0), uint256(0));
    } else {
      num += (block.timestamp - withdrawTime) / 2628029 / _info.months;
    }

    if (num > _info.numOfTimes - _info.numOfWithdraws) {
      num = _info.numOfTimes - _info.numOfWithdraws;
    }

    uint256 withdrawalAmount = IERC20(OMHToken).totalSupply() * _info.percent * num / 1_000_000;
    
    return (num, withdrawalAmount);
  }

  function changeAdmin(address _newAdmin) external onlyAdmin() {
    admin = _newAdmin;
  }

  function changeStartDate(uint256 _newDate) external onlyAdmin() {
    startDate = _newDate;
  }

  function setOMHToken(address _newToken) external onlyAdmin() {
    OMHToken = _newToken;
  }

  function setHolders(address _user, OMH memory _newSet) external onlyAdmin() {
    holders[_user] = _setDist(_newSet);
  }

  function _setDist(OMH memory _newSet) private pure returns (OMH memory) {
    return OMH({
      percent: _newSet.percent,
      startAfter: _newSet.startAfter,
      months: _newSet.months,
      numOfTimes: _newSet.numOfTimes,
      numOfWithdraws: _newSet.numOfWithdraws
    });
  }
}
