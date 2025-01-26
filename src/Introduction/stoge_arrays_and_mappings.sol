// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

contract StorageComplex {
    // see the below example     
    uint256[3] private fixedarray; // for fixed size array it is like going through normal uint256 value 
    // uint256 a -> location of the start of the fixed array 
    // uint256 b -> index 0 storage slot 
    // uint256 c -> index 1 storage slot 
    // uint256 d -> index 2 storage slot 
    uint256[] private bigarray; // where as in the cae of dynamic array it stores the length of the array at the storage slot
    uint8[] private smallarray; 

    mapping(uint256 => uint256) private myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) private nestedMapping;
    mapping(address => uint256[]) private addressToList;

    constructor() {
        fixedarray = [99,999,9999];
        bigarray= [43,34,543,998,55755];
        smallarray = [2,3,5];

        myMapping[10] = 123;
        myMapping[123] = 10;
        nestedMapping[1][1] = 2;
        addressToList[address(0x01)] = [22];
    }

    function getFixedArrayValue(uint256 index) public view returns (uint256 x) {
        // since the variable of fixed array are stored immediately after the slot of the array 
        // this operation has a small issue since after the slot 4 (aka index number 3) -> the next slot will have details of other storage variable
        assembly {
            x := sload(add(fixedarray.slot,index))
        }
    }

    function getBigArraySlot() public view returns (uint256) {
        // here i am returning the value of the stored data manually 
        assembly {
            let x := sload(bigarray.slot) // the storage slot stores the length of the dynamic array 
            mstore(0,x)
            return (0,0x20)
        }
    }

    function getBigArrayindexValue(uint256 index) public view returns (uint256) {
        // so to access an index of a dynamic array 
        // we basically take the hash of the slot where the dynamicarray is stored 
        // and then we add the index to the hash value (bytes32 hash + bytes32 index) => this location the index is stored
        // here using my custom method  
        assembly {
            let x := bigarray.slot
            mstore(0,x)
            let y := keccak256(0,0x20)
            let z := add(y,index)
            let xx := sload(z)
            mstore(0x40,xx)
            return(0x40,0x20)
        }
    }
    
}
/*
---------------------------------------------------------NOTE------------------------------------------
--> 

--> 

--> 

--> 
*/
