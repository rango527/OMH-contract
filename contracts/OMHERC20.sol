// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OMHERC20 is ERC20 {
  constructor() ERC20("OMH", "OMH") {
    _mint(msg.sender, 17_000_000_000 * 10**18);
  }
}
