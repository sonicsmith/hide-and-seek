pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HideAndSeek.sol";

contract TestHideAndSeek {

  HideAndSeek public hideAndSeek;
  uint public initialBalance = 1000 finney;

  function beforeAll() public {
    hideAndSeek = HideAndSeek(DeployedAddresses.HideAndSeek());
  }

  function testItStartsWithAllEmptyRooms() public {
    uint[] memory numEmptyRooms = hideAndSeek.getEmptyRoomIds();
    address occupier = hideAndSeek.getRoomOccupier(3);
    Assert.equal(numEmptyRooms.length, 8, "It should start with 8 empty rooms");
    Assert.equal(occupier, address(0), "It should have no player in a room");
  }

  function testItLetsPlayerHideInRoom() public {
    hideAndSeek.hideInRoom.value(20 finney)(0);
    uint[] memory numEmptyRooms = hideAndSeek.getEmptyRoomIds();
    address occupier = hideAndSeek.getRoomOccupier(0);
    Assert.equal(numEmptyRooms.length, 7, "It have 7 empty rooms after one is occupied");
    Assert.notEqual(occupier, address(0), "It should have player in correct room");
  }

  // function testARoomCantBeDoubleBooked() public {
  //   bool hideAgain = hideAndSeek.hideInRoom.value(20 finney)(0);
  //   Assert.isFalse(hideAgain, "Can't hide in occupied room");
  // }

  function testItFinishesGameOnceHouseIsFull() public {
    hideAndSeek.hideInRoom.value(20 finney)(1);
    hideAndSeek.hideInRoom.value(20 finney)(2);
    hideAndSeek.hideInRoom.value(20 finney)(3);
    hideAndSeek.hideInRoom.value(20 finney)(4);
    hideAndSeek.hideInRoom.value(20 finney)(5);
    hideAndSeek.hideInRoom.value(20 finney)(6);
    hideAndSeek.hideInRoom.value(20 finney)(7);
    uint[] memory numEmptyRooms = hideAndSeek.getEmptyRoomIds();
    Assert.equal(numEmptyRooms.length, 8, "It has 8 empty rooms after game over");
  }

  function testItGivesOutSeekTokenCorrectly() public {
    uint seekAmount = hideAndSeek.balanceOf(address(this));
    Assert.equal(seekAmount, 8, "It gives away the right amount of SEEK");
    uint totalSupply = hideAndSeek.totalSupply();
    Assert.equal(totalSupply, 8, "It changes the totalSupply of SEEK");
    uint price = hideAndSeek.getSeekTokenPrice();
    Assert.equal(price, 1 finney, "It updates the price of SEEK correctly");
  }

  function testTheNextRoundCorrectlyUpdatesTokenPrice() public {
    hideAndSeek.hideInRoom.value(20 finney)(0);
    hideAndSeek.hideInRoom.value(20 finney)(1);
    hideAndSeek.hideInRoom.value(20 finney)(2);
    hideAndSeek.hideInRoom.value(20 finney)(3);
    hideAndSeek.hideInRoom.value(20 finney)(4);
    hideAndSeek.hideInRoom.value(20 finney)(5);
    hideAndSeek.hideInRoom.value(20 finney)(6);
    hideAndSeek.hideInRoom.value(20 finney)(7);
    uint price = hideAndSeek.getSeekTokenPrice();
    Assert.equal(price, 1 finney, "It updates the price of SEEK correctly");
    uint seekAmount = hideAndSeek.balanceOf(address(this));
    Assert.equal(seekAmount, 0, "It gives away the right amount of SEEK");
    uint totalSupply = hideAndSeek.totalSupply();
    Assert.equal(totalSupply, 0, "It changes the totalSupply of SEEK");
  }

  function() external payable { }

}
