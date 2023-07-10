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

    function grantAccess(uint256 recordId, address user)
        public
        onlyRecordOwner(recordId)
    {
        records[recordId].access[user] = true;
        emit RecordAccessGranted(recordId, user);
    }

    function revokeAccess(uint256 recordId, address user)
        public
        onlyRecordOwner(recordId)
    {
        records[recordId].access[user] = false;
        emit RecordAccessRevoked(recordId, user);
    }

    function updateRecord(uint256 recordId, string memory _data)
        public
        onlyRecordOwner(recordId)
    {
        records[recordId].data = _data;
        emit RecordUpdated(recordId, msg.sender);
    }

    function getRecord(uint256 recordId)
        public
        view
        returns (
            uint256,
            string memory,
            address
        )
    {
        require(
            records[recordId].owner == msg.sender ||
                records[recordId].access[msg.sender],
            "Unauthorized access to record"
        );
        Record memory record = records[recordId];
        return (record.id, record.data, record.owner);
    }
}
