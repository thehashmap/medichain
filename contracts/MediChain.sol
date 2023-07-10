// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MediChain {
    struct Record {
        string recordData;
        address owner;
    }

    mapping(uint256 => Record) private records;
    mapping(uint256 => mapping(address => bool)) private recordAccess;
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

    function createRecord(string memory _recordData) public {
        recordCount++;
        records[recordCount] = Record(_recordData, msg.sender);
        emit RecordCreated(recordCount, msg.sender);
    }

    function grantAccess(uint256 recordId, address user)
        public
        onlyRecordOwner(recordId)
    {
        recordAccess[recordId][user] = true;
        emit RecordAccessGranted(recordId, user);
    }

    function revokeAccess(uint256 recordId, address user)
        public
        onlyRecordOwner(recordId)
    {
        recordAccess[recordId][user] = false;
        emit RecordAccessRevoked(recordId, user);
    }

    function updateRecord(uint256 recordId, string memory _recordData)
        public
        onlyRecordOwner(recordId)
    {
        records[recordId].recordData = _recordData;
        emit RecordUpdated(recordId, msg.sender);
    }

    function getRecord(uint256 recordId) public view returns (string memory) {
        require(
            records[recordId].owner == msg.sender ||
                recordAccess[recordId][msg.sender],
            "Unauthorized access to record"
        );
        return records[recordId].recordData;
    }
}
