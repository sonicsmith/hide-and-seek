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

  function testItFinishesGameOnceHouseIsFull() public {
    uint expectedBalance = initialBalance - 20 finney;
    for (uint i = 1; i < 8; i++) {
      hideAndSeek.hideInRoom.value(20 finney)(i);
      expectedBalance -= 20 finney;
    }
    uint[] memory numEmptyRooms = hideAndSeek.getEmptyRoomIds();
    Assert.equal(numEmptyRooms.length, 8, "It has 8 empty rooms after game over");
    uint winnings = (8 * (20 finney)) - ((8 * (20 finney)) / 10);
    expectedBalance += winnings;
    Assert.equal(address(this).balance, expectedBalance, "It gives a player winnings");
  }

  // function testItGivesOutSeekTokenCorrectly() public {
  //   uint seekAmount = hideAndSeek.balanceOf(address(this));
  //   uint SZABO = 1 szabo;
  //   Assert.equal(seekAmount, (8 * 2 * SZABO), "It gives away the right amount of SEEK");
  //   uint totalSupply = hideAndSeek.totalSupply();
  //   Assert.equal(totalSupply, (8 * 2 * SZABO), "It changes the totalSupply of SEEK");
  //   uint price = hideAndSeek.getSeekTokenPrice();
  //   Assert.equal(price, 500, "It updates the price of SEEK correctly");
  // }

  // // function testTheNextRoundCorrectlyUpdatesTokenPrice() public {
  // //   for (uint i = 0; i < 8; i++) {
  // //     hideAndSeek.hideInRoom.value(20 finney)(i);
  // //   }
  // //   uint seekAmount = hideAndSeek.balanceOf(address(this));
  // //   uint SZABO = 1 szabo;
  // //   Assert.equal(seekAmount, (((8 * 1) + (8 * 2)) * SZABO), "It gives away the right amount of SEEK");
  // //   uint price = hideAndSeek.getSeekTokenPrice();
  // //   Assert.equal(price, 666, "It updates the price of SEEK correctly");
  // // }

  // // function testTheItCorrectlyUpdatesTokenPricesAfterMoreRounds() public {
  // //   for (uint round = 0; round < 3; round++) {
  // //     for (uint i = 0; i < 8; i++) {
  // //       hideAndSeek.hideInRoom.value(20 finney)(i);
  // //     }
  // //   }
  // //   uint price = hideAndSeek.getSeekTokenPrice();
  // //   Assert.equal(price, 1666, "It updates the price of SEEK correctly");
  // // }

  // // function testTheUserCanCashOut() public {
  // //   uint balance = address(this).balance;
  // //   uint startPrice = hideAndSeek.getSeekTokenPrice();
  // //   uint amount = 23 szabo;
  // //   uint totalSupplyStart = hideAndSeek.totalSupply();
  // //   uint seekAmountStart = hideAndSeek.balanceOf(address(this));

  // //   hideAndSeek.cashInSeekForEth(amount);

  // //   uint seekAmountAfter = hideAndSeek.balanceOf(address(this));
  // //   uint gained = address(this).balance - balance;
  // //   uint totalSupplyAfter = hideAndSeek.totalSupply(); 
      
  // //   Assert.equal(gained, startPrice * amount, "It gives user eth correctly");
  // //   Assert.equal((totalSupplyStart - totalSupplyAfter), amount, "Total supply reduces");
  // //   Assert.equal((seekAmountStart - seekAmountAfter), amount, "User supply reduces");
  // //   Assert.equal(hideAndSeek.balanceOf(address(this)), 1 szabo, "Correct seek amount after");
  // //   Assert.equal(hideAndSeek.getSeekTokenPrice(), startPrice, "Correct seek/eth price after");


  // //   hideAndSeek.cashInSeekForEth(oneForth);
  // //   hideAndSeek.cashInSeekForEth(oneForth);
  // //   hideAndSeek.cashInSeekForEth(oneForth);

  // //   hideAndSeek.cashInSeekForEth(seekAmountAfter / 4);
  // //   hideAndSeek.cashInSeekForEth(seekAmountAfter / 4);
  // //   // hideAndSeek.cashInSeekForEth(hideAndSeek.balanceOf(address(this)));

  // //   Assert.equal(hideAndSeek.balanceOf(address(this)), 0, "Correct seek amount after");
  // //   Assert.equal(hideAndSeek.totalSupply(), 0, "No more tokens");
  // //   Assert.equal(hideAndSeek.getShareHoldings(), 0, "The shareholdings are all used up");
  // // }

  // function testItContinuesAfterCashoutCorrectly() public {
  //   for (uint i = 0; i < 8; i++) {
  //     hideAndSeek.hideInRoom.value(20 finney)(i);
  //   }
  //   uint seekAmount = hideAndSeek.balanceOf(address(this));
  //   uint SZABO = 1 szabo;
  //   Assert.equal(seekAmount, (((8 * 1) + (8 * 2)) * SZABO), "It gives away the right amount of SEEK");
  //   uint price = hideAndSeek.getSeekTokenPrice();
  //   Assert.equal(price, 666, "It updates the price of SEEK correctly");
  // }


  function() external payable { }

}
