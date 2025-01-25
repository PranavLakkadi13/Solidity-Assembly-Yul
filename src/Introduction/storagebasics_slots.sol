// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract StorageBasics {
    // lets see how to store and access variables using yul 
    uint x; // index 0
    uint y = 13; // index 1
    uint z = 3443; // index 2

    function setX(uint newval) external {
       x = newval;
    }

    function setvalYUL(uint num,uint value) external {
        assembly {
            // here we are setting the value at a particular location specified by the user            
            sstore(num,value)
        }
    }

    // getter function using YUL using the index of slot method 
    function getvarYUL(uint num) external view returns(uint ret) {
        assembly {
            // after calling setX() use this function to get the value of at a index of memory 
            // give index 0 to get the value of x , and so on.....
            ret := sload(num)
        }
    }
    // getter function using YUL using .slot method 
    function getX_yul() external view returns (uint ret){
        assembly {
            // ret := x // wont work as yul cant assess global variable directly
            // ret := x.slot // this will give us the address of the variable x
            // the below call helps us navigate the address of x and load the value of x and assign to ret
            ret := sload(x.slot)
        }
    }

    function getX() external view returns(uint){
        return x;
    }
     
}
/*
-------------------------------------------------NOTE--------------------------------------------
--> sload(p) = storage[p] => Load word from storage => p is the memory location 
    sstore(p,v) = storage[p] := v  => Save word to storage

--> we know that the data is stored as an array of 32bytes(each index) , and when we use the "slot" keyword 
    we can access the data at a particular index 
    so when we specified th slot index we get the location of any varible(if given) at that index
    ret := slot(0) ==> this also gives us the location of x

    variable_name.slot helps get the location of that particular variable

    since it is an array, the variable is data is stored sequentially i.e :-
    x is stored at index 0
    y is stored at index 1 ..... so and so forth 

--> the .slot method of a variable is determined at compile time and cannot be changed 

--> when we are giving the location to set the value manually, YUL doesnt care if that specific 
    location is already taken by a variable it will still make the change 
    note:- is the location of a contract owner can be changed then we have severe vulnerability 

*/
