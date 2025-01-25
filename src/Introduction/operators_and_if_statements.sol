// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract conditional {
    //  bool case 
    function istruth() public pure returns (uint result) {
        result = 3;
        // if the function runs the result is set to 1 and is returned 
        // therefore we know that the condition is true
        // It should return 1 as the result 
        assembly {
            if 2 {
                result := 1
            }
        }
    }

    // bool case
    function isFalse() public pure returns(uint result) {
        result = 3;
        // since the condition is of 0 all the bits of the 32byte word is 0 
        // Therefore the condition is false, the result returned is 3 
        assembly {
            if 0 {
                result := 1 // the block is not executed
            }
        }
    }

    function negation() public pure returns(uint result) {
        result = 1;
        assembly {
            // iszero(x) checks if x == 0
            // since true result is set to 2
            // look at the unsafe negation to understand y we dont use not 
            if iszero(0) {
                result := 2
            }
        }
    }

    function unsafeNegationPart1() external pure returns(uint result) {
        result = 1;
        assembly {
            // not() basiclly negates every bit of the given value, Therfore 0 => 1 which is true
            if not(0) {
                result := 2
            }
        }
    }

    function bitflip() external pure returns (bytes32 result) {
        assembly {
            // since we know the not negates every bit of the given value 
            // the last value of the 32bit output is d(the negation of 2)
            result := not(2)
            // output is result 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffd
        }
    }

    function unsafenegation2() external pure returns(uint result) {
        result = 1;
        assembly {
            // there now we know y the not condition is not a false statement 
            // and it is always true and that y we dont use not() to bool check 
            // iszero(2) is a better option 
            if not(2) {
                result := 3
            }
        }
    }

    // to get the greater number of the two 
    function getMax(uint x, uint y) external pure returns(uint max) {
        assembly {
            if lt(x,y) {
                max := y
            }
            // we have easily way to write this but this is just to give a gist of how to use iszero
            // since there is no else statement 
            if iszero(lt(x,y)) {
                max := x
            }
        }   
    }

    

}
/*
---------------------------------------------NOTE--------------------------------------------
--> In Yul since everything is a 32byte word it doesnt have boolean,
    Therefore it checks the if condition such that if 2 is a true or a false number

--> in Yul to check if a number is false all the bits of the 32 byte word is 0

--> It is better to use iszero rather than not to check a bool condition 

--> iszero(x) checks if x == 0
*/
