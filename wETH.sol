// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract cETH is ERC20{
    address endAcceptor;
    constructor() ERC20("CopperETH","cETH"){
        endAcceptor = msg.sender;
    }

    function deposit() payable public{
        _mint(msg.sender,msg.value);
    }

    function depositTo(address to) payable public{
        _mint(to,msg.value);
    }
    
    function _withdraw(address payer,address payable getter,uint256 value) private{
        uint256 fromBalance = balanceOf(payer);
        if(fromBalance <= value){
            revert ERC20InsufficientBalance(payer, fromBalance, value);
        }
        _burn(payer,value);
        getter.transfer(value);
    }

    function withdraw(uint256 value) public{
        _withdraw(msg.sender,payable(msg.sender),value);
    }

    function withdrawTo(address payable to,uint256 value) public{
        _withdraw(msg.sender,to,value);
    }

    function withdrawFrom(address from, uint256 value) public {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _withdraw(from,payable(msg.sender),value);
    }

    function withdrawFromTo(address from, address payable to, uint256 value) public {
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        _withdraw(from,payable(to),value);
    }

    function burn(uint256 value) public{
        if(msg.sender == endAcceptor){
            _withdraw(endAcceptor,payable(endAcceptor),value);
        }else{
            _transfer(msg.sender,endAcceptor, value);
        }
    }

    function burnFrom(address from, uint256 value) public{
        address spender = msg.sender;
        _spendAllowance(from, spender, value);
        if(msg.sender == endAcceptor){
            _withdraw(endAcceptor,payable(endAcceptor),value);
        }else{
            _transfer(from,endAcceptor, value);
        }
    }
}
