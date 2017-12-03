// This is a very simple example contract:

contract Data {

  uint public data;

  function addData(uint data_) {
    if(msg.sender == 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a)
      data = data_;
  }

}

/* this is a contract that lets a user add and read an unsigned integer.
    The acocunt number on line 8 cannot be changed. Ever. If we want to make
    the contract more flexible, we can make it like this:

    */


    contract SetOwner {

      uint public data;

      function addData(uint data_) {

        if(msg.sender == owner)
          data = data_;
      }

      function setOwner(address owner_) {
        if(msg.sender == owner)
          owner = owner_;
      }

    }


/* now we are going to make it so we can update the entire validation process.
The example is a bank deposit. When a deposit is made to an account, the bank
calls the authenticaiton contract, if it returns true, it finalizes the deposit.
*/

contract AccountValidator {

  address public owner = msg.sender;

  function validate(address addr) constant returns (bool) {
    return addr = owner;
  }

  function setOwner(address owner_) {
    if(msg.sender == owner)
      owner = owner_;
  }

}

contract DataExternalValidation {
  uint public data;

  AccountValidator _validator;

  function addData(uint data_) {
    DataExternalValidation(address validator) {
      _validator = AccountValidator(validator);
    }
  }

  function setValidator(address validator) {
    if(_validator.validate(msg.sender))
      _validator = AccountValidator(validator);
  }
}

/* This is very nice, because it is now possible to replace the contract
where the owner check is. Also, since the AccountValidator is its own
contract we could potentially use that instance to do authentication
for more contracts then just one.

One thing remains though. We still can't replace the code!
All we have done is move the validation code out of the contract.
The code of the AccountValidator contract can't be changed anymore
then that of the data contract. Fortunately, Solidity provides a very
simple and powerful solution - abstract functions. */

// Using abstract functions: We could change the validator contract to:


contract AccountValidator {
  function validate(address addr) constant returns (bool);
}

contract SingleAccountValidator is AccountValidator {
  address public owner = msg.sender;

  function validate(address addr) constant returns (bool) {
    return addr == owner;
  }

  function setOwner(address owner_) {
    if(msg.sender == owner)
      owner = owner_;
  }
}
