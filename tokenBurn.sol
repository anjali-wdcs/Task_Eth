pragma solidity ^0.4.24;
 
//Safe Math Interface
 
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
 
//ERC20 Token Standard Interface
 
contract ERC20Interface {
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
 
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
//Contract function to receive approval and execute function in one call
 
contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
}
 
//Actual token contract
 
contract LYCToken is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "LYC";
        name = "LYC NodeCoin";
        decimals = 2;
        _totalSupply = 100000;
        balances[0x2692eDaacfE65Cfc074264601Dcd273e90748c9C] = _totalSupply;
        emit Transfer(address(0), 0x2692eDaacfE65Cfc074264601Dcd273e90748c9C, _totalSupply);
    }
 
    function totalSupply() public constant returns (uint) {
        return _totalSupply  - balances[address(0)];
    }
 
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    event Burn(address indexed from, uint256 value);

    function burn(uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);   
        balances[msg.sender] -= _value;            
        _totalSupply -= _value;               
        emit Burn(msg.sender, _value);
        return true;
    }
 
    
     function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                
        require(_value <= allowed[_from][msg.sender]);    
        balances[_from] -= _value;                         
        allowed[_from][msg.sender] -= _value;             
        _totalSupply -= _value;                       
        emit Burn(_from, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 toBurn = (_value *5) / 100;
        
        if (LYCToken.transfer (_to, _value - toBurn)) {
            require (burn (toBurn));
            return true;
        } else return false;
    }

 
    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
 

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 toBurn = _value / 100;
        if (LYCToken.transferFrom (_from, _to, _value - toBurn)) {
            require (burnFrom (_from, toBurn));
            return true;
        } else return false;
    }
 
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }
 
    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }
 
    function () public payable {
        revert();
    }
}
