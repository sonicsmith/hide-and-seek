pragma solidity ^0.5.2;

import "./SafeMath.sol";

contract HideAndSeek {

  using SafeMath for uint;

  address owner;
  uint public NUM_ROOMS = 8;
  uint public PRICE_TO_PLAY = 20 finney;

  uint numRoomsOccupied = 0;
  uint shareHoldings = 0;
  uint devHoldings = 0;
  mapping (uint => address payable) rooms;

  event Log (
    string message,
    uint number
  );

  modifier onlyByOwner() {
    require(msg.sender == owner);
    _;
  }

  constructor() public {
    owner = msg.sender;
  }

  function setNumRooms(uint numRooms) public onlyByOwner {
    NUM_ROOMS = numRooms;
  }

  function setPriceToPlay(uint priceToPlay) public onlyByOwner {
    PRICE_TO_PLAY = priceToPlay;
  }

  function getEmptyRoomIds() public view returns (uint[] memory) {
    uint[] memory ids = new uint[](NUM_ROOMS - numRoomsOccupied);
    uint counter = 0;
    for (uint i = 0; i < NUM_ROOMS; i++) {
      if (rooms[i] == address(0)) {
        ids[counter] = i;
        counter++;
      }
    }
    return ids;
  }

  function getRoomOccupier(uint id) public view returns (address) {
    return rooms[id];
  }

  function hideInRoom(uint roomId) public payable {
    require(msg.value >= PRICE_TO_PLAY);
    require(roomId < NUM_ROOMS);
    require(rooms[roomId] == address(0));
    rooms[roomId] = msg.sender;
    numRoomsOccupied++;
    if (numRoomsOccupied == NUM_ROOMS) {
      endRound();
    }
  }

  function endRound() internal {
    rewardWinner();
    giveOutSeekToken();
    emptyHouse();
  }

  function random(uint maxValue) internal view returns (uint) {
    bytes memory seed = abi.encodePacked(
      block.timestamp, 
      block.difficulty, 
      rooms[0]
    );
    return uint(uint(keccak256(seed)) % maxValue);
  }

  function rewardWinner() internal {
    uint rnd = random(NUM_ROOMS);
    address payable winner = rooms[rnd];
    uint totalFromRound = NUM_ROOMS.mul(PRICE_TO_PLAY);

    uint devTakings = totalFromRound.div(100).mul(5);   // 5 percent for dev
    uint shareTakings = totalFromRound.div(100).mul(5); // 5 percent for shares
    shareHoldings = shareHoldings.add(shareTakings);
    devHoldings = devTakings.add(devTakings);

    uint winnings = totalFromRound.sub(devTakings).sub(shareTakings);
    winner.transfer(winnings);
  }

  function giveOutSeekToken() internal {
    uint numTokens = getSeekAllocation();
    for (uint i = 0; i < NUM_ROOMS; i++) {
      transfer(rooms[i], numTokens);
    }
    totalSupplySeek = totalSupplySeek.add(numTokens.mul(NUM_ROOMS));
  }

  function emptyHouse() internal {
    for (uint i = 0; i < NUM_ROOMS; i++) {
      rooms[i] = address(0);
    }
    numRoomsOccupied = 0;
  }

  /*
  ** SEEK Calculations
  */

  function getSeekTokenPrice() public view returns (uint price) {
    if (shareHoldings == 0 || totalSupplySeek == 0) {
      return 0;
    }
    return shareHoldings.div(totalSupplySeek);
  }

  function getSeekAllocation() public view returns (uint allocation) {
    uint seekPrice = getSeekTokenPrice(); // 1 percent of the going price
    if (seekPrice == 0) { // if no holdings or seek tokens
      return 1;
    }
    return seekPrice.div(100);
  }

  function cashInSeekForEth(uint amount) public payable {
    require(balanceOf(msg.sender) >= amount);
    uint seekPrice = getSeekTokenPrice();
    totalSupplySeek -= amount;
    seekBalances[msg.sender] -= amount;
    msg.sender.transfer(seekPrice.mul(amount));
  }


  /*
  **
  ** SEEK TOKEN INTERFACE: ERC20 COMPLIANT
  **
  */
  // Public variables
  string public name = "Seek Token";
  string public symbol = "SEEK";
  uint8 public decimals = 18;
  //
  uint totalSupplySeek = 0;
  mapping (address => uint) seekBalances;
  mapping(address => mapping (address => uint256)) allowed;


  function totalSupply() public view returns (uint) {
    return totalSupplySeek;
  }
  function balanceOf(address tokenOwner) public view returns (uint balance) {
    return seekBalances[tokenOwner];
  }
  function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
    return allowed[tokenOwner][spender];
  }
  function transfer(address to, uint tokens) public returns (bool success) {
    seekBalances[to] = seekBalances[to].add(tokens);
    emit Transfer(address(this), to, tokens);
    return true;
  }
  function approve(address spender, uint tokens) public returns (bool success) {
    allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }
  function transferFrom(address from, address to, uint tokens) public returns (bool success) {
    seekBalances[from] = seekBalances[from].sub(tokens);
    allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
    seekBalances[to] = seekBalances[to].add(tokens);
    emit Transfer(from, to, tokens);
    return true;
  }

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

}
