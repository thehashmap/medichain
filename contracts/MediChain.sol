// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MediChain {
    struct Record {
        uint256 id;
        string data;
        address owner;
        mapping(address => bool) access;
    }

    mapping(uint256 => Record) private records;
    uint256 private recordCount;

    event RecordCreated(uint256 indexed recordId, address indexed owner);
    event RecordAccessGranted(uint256 indexed recordId, address indexed user);
    event RecordAccessRevoked(uint256 indexed recordId, address indexed user);
    event RecordUpdated(uint256 indexed recordId, address indexed owner);

    modifier onlyRecordOwner(uint256 recordId) {
        require(
            records[recordId].owner == msg.sender,
            "Only record owner can perform this operation"
        );
        _;
    }

    function createRecord(string memory _data) public {
        recordCount++;
        records[recordCount] = Record(recordCount, _data, msg.sender);
        emit RecordCreated(recordCount, msg.sender);
    }
}
