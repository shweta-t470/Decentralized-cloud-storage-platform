// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DecentraStore - A decentralized file storage metadata manager
/// @author 
/// @notice This contract allows users to register, retrieve, and reward file storage on a decentralized network.

contract DecentraStore {

    struct File {
        string fileHash;      // IPFS or decentralized storage hash
        string fileName;      // Name of the file
        uint256 fileSize;     // Size in bytes
        address owner;        // File uploader
        uint256 timestamp;    // Upload time
    }

    mapping(string => File) private files; // fileHash => File
    mapping(address => uint256) public userUploads; // Track how many uploads per user

    event FileUploaded(address indexed owner, string fileHash, string fileName, uint256 fileSize, uint256 timestamp);
    event FileDeleted(address indexed owner, string fileHash, uint256 timestamp);

    /// @notice Upload a new file’s metadata to the blockchain
    /// @param _fileHash The unique hash (e.g., IPFS CID)
    /// @param _fileName The name of the file
    /// @param _fileSize The file size in bytes
    function uploadFile(string memory _fileHash, string memory _fileName, uint256 _fileSize) public {
        require(bytes(_fileHash).length > 0, "File hash required");
        require(_fileSize > 0, "Invalid file size");

        files[_fileHash] = File({
            fileHash: _fileHash,
            fileName: _fileName,
            fileSize: _fileSize,
            owner: msg.sender,
            timestamp: block.timestamp
        });

        userUploads[msg.sender] += 1;

        emit FileUploaded(msg.sender, _fileHash, _fileName, _fileSize, block.timestamp);
    }

    /// @notice Retrieve metadata for a given file hash
    function getFile(string memory _fileHash) public view returns (File memory) {
        require(bytes(files[_fileHash].fileHash).length > 0, "File not found");
        return files[_fileHash];
    }

    /// @notice Delete your uploaded file (metadata only)
    function deleteFile(string memory _fileHash) public {
        File memory file = files[_fileHash];
        require(file.owner == msg.sender, "Only owner can delete file");
        delete files[_fileHash];
        emit FileDeleted(msg.sender, _fileHash, block.timestamp);
    }
}
