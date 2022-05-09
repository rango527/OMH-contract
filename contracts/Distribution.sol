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
  address public OMHOwner;
  address public admin;
  uint256 public startDate;

  mapping (address => OMH) public teams;
  mapping (address => OMH) public advisor;
  mapping (address => OMH) public seed;
  mapping (address => OMH) public privates;
  mapping (address => OMH) public marketing;
  mapping (address => OMH) public liquidity;
  mapping (address => OMH) public staking;
  mapping (address => OMH) public bounty;
  mapping (address => OMH) public treasury;
  mapping (address => OMH) public distribution;

  event Withdraw(
    address indexed caller,
    uint256 amount,
    uint256 withdrawDate
  );

  modifier onlyAdmin {
    require(msg.sender == admin, "caller is not admin");
    _;
  }

  constructor(address _OMHToken, address _OMHOwner, uint256 _startDate) {
    admin = msg.sender;
    OMHToken = _OMHToken;
    OMHOwner = _OMHOwner;
    startDate = _startDate;
  }

  function withdrawTeam() external {
    require(teams[msg.sender].percent != uint256(0), "caller is not team member");
    uint256 num = _withdraw(msg.sender, teams[msg.sender]);
    teams[msg.sender].numOfWithdraws += num;
  }

  function withdrawAdvisor() external {
    require(advisor[msg.sender].percent != uint256(0), "caller is not advisor");
    uint256 num = _withdraw(msg.sender, advisor[msg.sender]);
    advisor[msg.sender].numOfWithdraws += num;
  }

  function withdrawSeed() external {
    require(seed[msg.sender].percent != uint256(0), "caller is not seed");
    uint256 num = _withdraw(msg.sender, seed[msg.sender]);
    seed[msg.sender].numOfWithdraws += num;
  }

  function withdrawPrivates() external {
    require(privates[msg.sender].percent != uint256(0), "caller is not privates");
    uint256 num = _withdraw(msg.sender, privates[msg.sender]);
    privates[msg.sender].numOfWithdraws += num;
  }

  function withdrawMarketing() external {
    require(marketing[msg.sender].percent != uint256(0), "caller is not marketing");
    uint256 num = _withdraw(msg.sender, marketing[msg.sender]);
    marketing[msg.sender].numOfWithdraws += num;
  }

  function withdrawLiquidity() external {
    require(liquidity[msg.sender].percent != uint256(0), "caller is not liquidity");
    uint256 num = _withdraw(msg.sender, liquidity[msg.sender]);
    liquidity[msg.sender].numOfWithdraws += num;
  }

  function withdrawStaking() external {
    require(staking[msg.sender].percent != uint256(0), "caller is not staking");
    uint256 num = _withdraw(msg.sender, staking[msg.sender]);
    staking[msg.sender].numOfWithdraws += num;
  }

  function withdrawBounty() external {
    require(bounty[msg.sender].percent != uint256(0), "caller is not bounty");
    uint256 num = _withdraw(msg.sender, bounty[msg.sender]);
    bounty[msg.sender].numOfWithdraws += num;
  }

  function withdrawTreaseury() external {
    require(treasury[msg.sender].percent != uint256(0), "caller is not treasury");
    uint256 num = _withdraw(msg.sender, treasury[msg.sender]);
    treasury[msg.sender].numOfWithdraws += num;
  }

  function _withdraw(address _user, OMH memory _info) private returns (uint256) {
    require(_info.numOfWithdraws < _info.numOfTimes, "caller has already all withdrawn.");
    uint256 timeNow = block.timestamp;
    uint256 _startDate = startDate;
    uint256 monthTime = 2628029; // seconds
    uint256 num = 1;
    if (_info.numOfWithdraws == uint256(0)) {
      if (_info.startAfter != uint256(0)) {
        require(timeNow > _startDate + monthTime * _info.startAfter, "not withdraw time");
      }
      num += (timeNow - _startDate - monthTime * _info.startAfter) / monthTime / _info.months;
    } else {
      uint256 withdrawTime = _startDate + _info.startAfter * monthTime + _info.months * _info.numOfWithdraws;
      require(timeNow > withdrawTime, "not withdraw time");
      num += (timeNow - withdrawTime) / monthTime / _info.months;
    }

    if (num > _info.numOfTimes - _info.numOfWithdraws) {
      num = _info.numOfTimes - _info.numOfWithdraws;
    }

    uint256 DENOMINATER = 1_000_000;
    uint256 withdrawalAmount = IERC20(OMHToken).totalSupply() * _info.percent * num / DENOMINATER;
    IERC20(OMHToken).safeTransferFrom(OMHOwner, _user, withdrawalAmount);

    emit Withdraw(_user, withdrawalAmount, timeNow);
    return num;
  }

  function changeAdmin(address _newAdmin) external onlyAdmin() {
    admin = _newAdmin;
  }

  function changeOMHToken(address _newToken) external onlyAdmin() {
    OMHToken = _newToken;
  }

  function changeOMHOwner(address _newOwner) external onlyAdmin() {
    OMHOwner = _newOwner;
  }

  function changeStartDate(uint256 _newDate) external onlyAdmin() {
    startDate = _newDate;
  }

  function setTeams(address _user, OMH memory _newSet) public onlyAdmin() {
    teams[_user] = _setDist(_newSet);
  }

  function setAdvisor(address _user, OMH memory _newSet) public onlyAdmin() {
    advisor[_user] = _setDist(_newSet);
  }

  function setSeed(address _user, OMH memory _newSet) public onlyAdmin() {
    seed[_user] = _setDist(_newSet);
  }

  function setPrivates(address _user, OMH memory _newSet) public onlyAdmin() {
    privates[_user] = _setDist(_newSet);
  }

  function setMarketing(address _user, OMH memory _newSet) public onlyAdmin() {
    marketing[_user] = _setDist(_newSet);
  }

  function setLiquidity(address _user, OMH memory _newSet) public onlyAdmin() {
    liquidity[_user] = _setDist(_newSet);
  }

  function setStaking(address _user, OMH memory _newSet) public onlyAdmin() {
    staking[_user] = _setDist(_newSet);
  }

  function setBounty(address _user, OMH memory _newSet) public onlyAdmin() {
    bounty[_user] = _setDist(_newSet);
  }

  function setTreasury(address _user, OMH memory _newSet) public onlyAdmin() {
    treasury[_user] = _setDist(_newSet);
  }

  function _setDist(OMH memory _newSet) private pure returns (OMH memory) {
    return OMH({
      percent: _newSet.percent,
      startAfter: _newSet.startAfter,
      months: _newSet.months,
      numOfTimes: _newSet.numOfTimes,
      numOfWithdraws: uint256(0)
    });
  }
}
