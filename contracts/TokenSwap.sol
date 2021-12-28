// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
pragma abicoder v2;

import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract TokenSwap is Ownable{

    ISwapRouter public immutable swapRouter;
    uint256 public poolFee = 3000;
    mapping (string => address) public storage allowedTokens;

    error InsufficientBalance(uint256 available, uint256 required);

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter; 
    }

    mapping (string => address) public allowedTokens; 
        function addAllowedToken(string memory _tokenName, address _token) public {
        allowedTokens[_tokenName] = _token;
    }

    function modifyPoolFee(uint256 _poolFee) public onlyOwner{
        poolFee = _poolFee;
    }

    function swapExactInputSingle(uint256 amountIn, string memory inputToken, string memory outputToken ) external returns (uint256 amountOut){
        IERC20(allowedTokens[inputToken]).approve(address(this), amountIn);
        // before this, give the owner of the contract his commission
        TransferHelper.safeApprove(allowedTokens[inputToken],  address(this), amountIn);
    }

}