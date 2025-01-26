// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract Variable {
    uint256 a = 2;
    uint256 b = 32;
    uint256 c = 77;
    uint128 d = 12; // in hex it is c 
    uint128 e = 1;

    function getslot_d() external pure returns (uint num){
        assembly {
            num := d.slot
        }
    }

    function getslot_e() external pure returns (uint num){
        assembly {
            num := e.slot
        }
    }

    // to check the value stored at a particular slot 
    function getval(uint slot) external view returns(bytes32 val){
        assembly {
            val := sload(slot)
            // output = val 0x000000000000000000000000000000010000000000000000000000000000000c
        }
    }
}
/*
-------------------------------------------------NOTE--------------------------------------------
--> in solidity we have variable packing, that is in some cases more than 1 variable can have the
    same location slot. example:- uint128 d, uint128 e

--> inside the storage array, the variable is loaded from the left side that is why even tho the 
    variable d is stored first the value is found in the left side 

    00000000000000000000000000000001 => value of e
    0000000000000000000000000000000c => value of d

*/
