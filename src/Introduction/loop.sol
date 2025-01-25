// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract checkPrime {

    // to check if a number is prime or not 
    function isPrime(uint x) public pure returns (bool p) {
        p = true;

        // loop part 
        assembly {
            // usualy we write uint halfx = x/2 + 1
            let halfx := add(div(x, 2), 1)
            // in the for part i can write it without specifyting the iniatialisation and icremnet statement inside the loop
            // provided i initialise outside the loop 
            // let i := 2
            // for {} lt(i, halfx) {} {
            // }
            for {let i := 2} lt(i,halfx) {i := add(i, 1)} {
                // other way is if eq(mod(x,i), 0) {}
                if iszero(mod(x,i)) {
                    p := 0
                    break
                }

                // the increment condition if i didnt give it inside the loop condition 
                // i := add(i,1)  
            }
        }
    }

    function testprime() external pure returns(bool p){
        p = false;
        if (p == false) {
            require(isPrime(3));
            require(isPrime(5));
            require(isPrime(7));
            require(!isPrime(10)); // here this is regular solidity thats y i used the negation(!)
            p = true;
        } 
    }
}
/*
---------------------------------------------------------NOTE------------------------------------------
--> Yul has for loops and it is a language that is one level above assembly

--> In Yul every operation is called as a function

--> add(x, y) => x + y
    div(x, y)  => x / y or 0 if y == 0
    lt(x, y)  => 1 if x < y, 0 otherwise
    iszero(x) => 1 if x == 0, 0 otherwise

--> there is no "!" operator Yul for negation 
*/
