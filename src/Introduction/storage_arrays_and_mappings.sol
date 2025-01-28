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
    uint8[] private smallarray2;

    mapping(uint256 => uint256) private myMapping;
    mapping(uint256 => mapping(uint256 => uint256)) private nestedMapping;
    mapping(address => uint256[]) private addressToList;

    constructor() {
        fixedarray = [99,999,9999];
        bigarray= [43,34,543,998,55755];
        smallarray = [1,2,3,4,5];
        smallarray2 = [2,3,5,7,11,13,15,17,19,21,23,25,27,28,30,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1];

        myMapping[10] = 123;
        myMapping[123] = 10;
        nestedMapping[1][1] = 2;
        nestedMapping[2][4] = 123;
        addressToList[address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)] = [22,234,2313,213773];
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

    function getBigArrayindexValue(uint256 index) public view returns (uint256 ret) {
        // so to access an index of a dynamic array 
        // we basically take the hash of the slot where the dynamicarray is stored 
        // and then we add the index to the hash value (bytes32 hash + bytes32 index) => this location the index is stored
        // here using my custom method  ->>>>>>>>
        // assembly {
        //     let x := bigarray.slot
        //     mstore(0,x)
        //     let y := keccak256(0,0x20)
        //     let z := add(y,index)
        //     let xx := sload(z)
        //     mstore(0x40,xx)
        //     return(0x40,0x20)
        // }

        // the jeffery method 
        uint256 slot;
        assembly {
            slot := bigarray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            ret := sload(add(location,index))
        }
    }
    
    // when reading it for uint8[] it happens to be the same way 
    // we need a small workaround to deal with it and the value can be returned using bitshifting
    // uint8 array at index 0 will store the uint8 values untill 32 instances and then move to the next index 
    // the below example will demonstrate on how it works
    function getsmallArray1IndexValue(uint256 index) public view returns (bytes32 ret) {
        uint256 slot;
        assembly {
            slot := smallarray.slot
        }
        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            ret := sload(add(location,index))
        }
    }

    function getsmallArray2IndexValue(uint256 index) public view returns (bytes32 ret) {
        uint256 slot;
        assembly {
            slot := smallarray2.slot
        }
        bytes32 location = keccak256(abi.encode(slot));
        assembly {
            ret := sload(add(location,index))
        }
    }

    function getMapping(uint256 key) public view returns (uint256 x) {
        // the mappings work similar to an arry but just concat the slot to the key and then take the hash and the 
        // hash is the location where the value of a particular key is stored  
        uint256 slot;
        assembly {
            slot := myMapping.slot
        }
        bytes32 location = keccak256(abi.encode(key,slot));
        assembly {
            x := sload(location)
        }
    }

    function getNestedMapping(uint256 innerkey,uint256 outerkey) public view returns (uint256 ) {
        assembly {
            let slot := nestedMapping.slot
            mstore(0x80,slot)
            mstore(0x60,outerkey)
            let location := keccak256(0x60,0x40)
            mstore(0xa0,innerkey)
            mstore(0xc0,location)
            let data_loc := keccak256(0xa0,0x40)
            let val := sload(add(data_loc,0))
            mstore(0xe0,val)
            return(0xe0,0x20)
        }
        // uint256 slot;
        // assembly {
        //     slot := nestedMapping.slot
        // }
        // bytes32 location = keccak256(abi.encode(innerkey, keccak256(abi.encode(outerkey,slot))));
        // assembly {
        //     x := sload(add(location,0))
        // }
    }

    function getAddressMapArrayLen() public view returns (uint256) {
        // assembly {
        //     let slot := addressToList.slot 
        //     mstore(0x60,0x5B38Da6a701c568545dCfcB03FcB875f56beddC4)
        //     mstore(0x80,slot)
        //     let location := keccak256(0x60,0x34)
        //     mstore(0xa0,sload(location))
        //     return(0xa0,0x20)
        // }
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }
        bytes32 location = keccak256(abi.encode(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4),slot));
        assembly {
            mstore(0xa0,sload(location))
            return (0xa0, 0x20)
        }
    }

    function getAddressMappingListIndexValue(uint256 index) public view returns (uint256 ) {
        uint256 slot;
        assembly {
            slot := addressToList.slot
        }
        bytes32 locationwithIndex = keccak256(abi.encode(keccak256(abi.encode(address(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4),slot))));
        assembly {
            let x := sload(add(locationwithIndex,index))
            mstore(0x60,x)
            return(0x60,0x20)
        }
    }
}
/*
---------------------------------------------------------NOTE------------------------------------------
--> The reason why we take hash of the storage slot is becoz we get some big random number and we can be sure that
    the slot value is too big to be hit using any storage slots and to maintain the continuity we add the index to the 
    hash(slot) 

--> When dealing with uint8 we usually take the hash of the storage slot and then add the index to it but that location can store
    32 uint8 values and then move to the next slot when the previous location is filled up... and then we need to bitshift accrodingly
    
--> In the case of mappings we take the hash of the key and the storage slot then we get the location 
    where the value is stored

--> 
*/
