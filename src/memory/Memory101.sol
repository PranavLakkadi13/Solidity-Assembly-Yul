// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Memory101 {
    
}
/*
---------------------------------------------------------NOTE------------------------------------------
-->  You need memory access to do the following tasks:
    * Return values
    * setting function argumnets for external calls
    * get values from external calls 
    * Reverting with an error message 
    * log messages 

--> It is like the heap in other languages but doesnt have a garbage collector 
    
--> It is laid out in 32 byte slots eg: [0x00-0x20][0x20-0x40][0x40-0x60]

--> It is like a dynamic sized array but the longer the array is the more it costs to be read and it is quadratic 
    
*/
