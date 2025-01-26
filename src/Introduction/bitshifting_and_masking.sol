// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract bitshifting_masking {
    uint128 public C = 4;
    uint96 public D= 6;
    uint16 public E = 8;
    uint8 public F = 1;

    function readSlot(uint256 slot) public view returns (bytes32 value) {
        assembly {
            value:= sload(slot)
        }
    }

    function getE() public view returns (uint256 z) {
        assembly {
            // here we load the data from the slot E is stored (0th slot)
            let k := sload(E.slot)
            // 0x0001000800000000000000000000000600000000000000000000000000000004
            // E.offset is 28
            // the .offset method tells us how many bytes to right shift to get the value 
            // multiplied with 8 to get in bits since the shr() takes the value to shift by bits 
            let value := shr(mul(E.offset,8),k)
            // post shift the data looks like 
            // 0x0000000000000000000000000000000000000000000000000000000000010008

            // here we see that after the bitshift we removed all the value to the right and padded zero in the front 
            // now to remove the 8bit value in front of E we do a logical and that helps making everything 0
            // f = 1111 in binary 
            // since 0x0001 is a 8 bit value it in binary is 0000 0001
            // on the above value we do a logical and        1111 1111
            // this if u look at it after logical and should remain the same -> but the whole returned value is determined by return type
            // bcoz when returning the whole uint256 it reads the data as one uint256 value which in bits is a lot higher than
            // the individual representation
            // 0x0000000000000000000000000000000000000000000000000000000000010008 the result post doing the "AND" operation in hex representation
            // if it was returning uint256 -> 65544
            // z:= and(0xffffffff,value) -> when it was wrongly masked
            // if it is returnig uint16 -> 8 
            // since in binary 8 for uint16 ->  0000 0000 0000 1000
            
            // 0x0000000000000000000000000000000000000000000000000000000000010008
            // 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000f >> these values are and operated return just 8
            z:= and(0x0000ffff,value)
        }
    }


    // if didnt type the explicit uint16 it could override other varaibles ->
    // eg if it was uint256 and i passed  uint32 value the value would have modified E and F as well 
    function writeE(uint16 newEval) public {
        // the uint16 though passed will be understood by solc as a uint256 -->
        // 0x000000000000000000000000000000000000000000000000000000000000-(newEval - 16bits)
        // we cant use the traditional method since it will overwrite the other values that are stored in that slot 
        // first we load the slot 
        assembly {
            let c := sload(E.slot)
            // here we load the slot data onto memory 
            // 0x0001000800000000000000000000000600000000000000000000000000000004
            // it ok to hardcode since the variables of the above sizes will always start from that slot
            let cleared := and(c,0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff) 
            // mask : = 0xffff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffff
            // cval : = 0x0001000800000000000000000000000600000000000000000000000000000004
            // postmask 0x0001000000000000000000000000000600000000000000000000000000000004 // the value that is cleared
            // here we will shift the newEval to the location of current E in a 32byte representation 
            let shiftedval := shl(mul(E.offset,8),newEval) 
            // current newEval = 0x000000000000000000000000000000000000000000000000000000000000-(newEval - 16bits)
            // postshift newEval 0x0000-(newEval - 16bits)-00000000000000000000000000000000000000000000000000000000
            let newval := or(shiftedval,cleared)
            // shiftedval 0x0000  -(newEval - 16bits)- 00000000000000000000000000000000000000000000000000000000
            // cleared    0x0001      0000             00000000000000000000000600000000000000000000000000000004
            // final      0x0001  -(newEval - 16bits)- 00000000000000000000000600000000000000000000000000000004
            sstore(E.slot,newval)
        }
    }
}
/*
-------------------------------------------NOTE------------------------------------------------
--> Yul has only 1 type it is the 32byte or 256bit word that we are used to seeing
    therefore, a int will be converted to a byte(hex)

--> 1"f" is 4bit -> "ff" is 1 byte == 8 bit 

--> shifting is more cheaper but division is also another way to bitshift 

--> v and 00 -> 00
    v or 00  -> v
    v and 11 -> v

-->  This example makes it clear y uint256 should be the fixed variable size and the use of smaller size variable cost gas
*/
