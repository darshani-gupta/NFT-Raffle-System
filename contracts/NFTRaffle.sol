// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTRaffle is Ownable(msg.sender) {
    IERC721 public nft;
    uint256 public ticketPrice;
    address[] public participants;
    bool public raffleEnded;

    event TicketPurchased(address indexed buyer);
    event RaffleEnded(address indexed winner, uint256 indexed tokenId);

    constructor() {
        nft = IERC721(address(0xa0Ee7A142d267C1f36714E4a8F75612F20a79720)); // Replace with your NFT contract address
        ticketPrice = 0.01 ether;
        raffleEnded = false;
    }

    function buyTicket() external payable {
        require(!raffleEnded, "Raffle already ended");
        require(msg.value == ticketPrice, "Incorrect ticket price");
        participants.push(msg.sender);
        emit TicketPurchased(msg.sender);
    }

    function getParticipants() external view returns (address[] memory) {
        return participants;
    }

    function endRaffle(uint256 _tokenId) external onlyOwner {
        require(!raffleEnded, "Raffle already ended");
        require(participants.length > 0, "No participants");

        uint256 winnerIndex = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao))
        ) % participants.length;

        address winner = participants[winnerIndex];
        nft.transferFrom(msg.sender, winner, _tokenId);
        raffleEnded = true;

        emit RaffleEnded(winner, _tokenId);
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
