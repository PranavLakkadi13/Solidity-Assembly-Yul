// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract YulTypes {
    // this is how we write a function in general and return a uint
    // execution cost 381 gas
    function getNumber() external pure returns (uint) {
        return 42;
    }

    // here i have used the inline assembly to set the value of x 
    // inline assembly can read the value of x directly bcoz it is a local variable 
    // execution cost 350 gas 
    function setValue() external pure returns(uint) {
        uint x;

        assembly {
            x := 42
            // x := 0x2a // this is 42 in hex
        }

        // since i am returning a uint i get it as a uint irrespective of the setting type in assembly
        return x; 
    }

    // here it is similar to the above example in hex
    function sethex() external pure returns(uint) {
        uint x;

        assembly {
            x := 0x2a
        }

        // same as the above function used a hex setter which is converted to a uint and returned
        return x;
    }

    // it runs out of gas 
    // since each type in assembly is stored on stack and is of bytes32 
    // the string is stored in memory and therefore uses a pointer to the stack and writes on memory
    // function setString() external pure returns (string memory) {
    //     string memory mystring = "";

    //     assembly {
    //         mystring := "hello world"
    //     }

    //     return mystring;
    // }

    // here i am giving the string input as a bytes array and then conerting it 
    // execution costs 336 gas 
    function setString() external pure returns (bytes32 /*string memory*/) {
        bytes32 mystring ="";

        assembly {
            mystring := "hello world" // length < 33
        }

        return mystring; // it returns a hex value of hello world and returns should be bytes32
        // return string(abi.encode(mystring)); // returns a string "hello world"
    }

    // execution cost is 465 gas  for address
    // execution cost is 422 gas for uint8
    // execution cost is 416 for uint256
    // execution cost is 422 gas for bool
    function representation() external pure returns (bool) {
        bool x;

        assembly {
            // x := 123 // input for address
            
            // o == false
            // 1 == true
            
            x := 0 // input for bool 
            // x := 123 // input for uint
        }

        return x; //address: 0x000000000000000000000000000000000000007B => 7B in hex = 123 in dec
        // return x // bool: false 
        // return x // uint: 123
    }


    // execution cost is 394 gas 
    function testBytes() external pure returns(bytes32) {
       bytes32 x;

       assembly {
           x := 12
           //x = 0xa // => is a hex input 
       } 

       // here the return is of bytes, therefore the int input is coverted to hex and returned bcoz return 
       // type is of byte     
       return x;   
    }
    

}
/*
-------------------------------------------NOTE------------------------------------------------
--> Yul has only 1 type it is the 32byte or 256bit word that we are used to seeing
    therefore, a int will be converted to a byte(hex)

--> using inline assembly will sometimes help u save gas 

--> a string by default is not a bytes32 

--> x in the function scope was refered by the x in assembly scope, only local variable can be accesed directly 

--> Yul just makes a interpretation when u use a string,int,address etc since it is of bytes32 

--> Incase of integer i can give the input in the assembly code in the form of uint or a hex but the output will 
    depend on the return type eg like return type is int therefore the input type of hex is converted to int and
    then returned 
*/
