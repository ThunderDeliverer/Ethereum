/// @title Blind auction v0.3
pragma solidity ^0.4.13;

contract BlindAuction{
	struct Bid {
		bytes32 blindedBid;
		uint deposit;
	}
	//Defines the number of auctions that were ever present in the auction.
	//Also used for automatic auction identifier upon deploy.
	uint256 currentNumberOfAuctions;
	//The first uint256 is always the auction identifier for auction instance.
	//Allows for mapping beneficiaries to auctions.
	mapping (uint256 => address) public beneficiaries;
	//address public beneficiary;
	//Descriptions of the auctions.
	mapping (uint256 => string) public descriptions;
	//Defines time limits and statuses of individual auctions.
	mapping (uint256 => uint) public auctionsStart;
	mapping (uint256 => uint) public biddingsEnd;
	mapping (uint256 => uint) public revealsEnd;
	mapping (uint256 => bool) public auctionsEnded;
	/*uint public auctionStart;
	uint public biddingEnd;
	uint public revealEnd;
	bool public ended;*/

	//Mapping to hold all the bids for an auction.
	mapping(address => Bid[]) bids;

	//Mapping to hold all ste bids for all the auctions.
	mapping (uint256 => bids) public auctionBids;

	//Displays winning conditions and stats.
	mapping (uint256 => address) public highestBidders;
	mapping (uint256 => uint) public highestBid;
	mapping (uint256 => uint) public numberOfAuctionParticipants;
	/*address public highestBidder;
	uint public highestBid;
	uint public numberOfParticipants;*/

	//Allowed withdrawals of previous bids in auction.
	mapping (address => uint) pendingReturns;
	//Allowed withdrawals of previous bids in all auctions.
	mapping (uint256 => pendingReturns) pendingReturnsPerAuction;
	//Maps all of the participating addresses in a single auction in order to make the contract reusable.
	mapping (uint => address) participatingAddresses;
	//Maps all of the participating addresses in all the auctions.
	mapping (uint256 => participatingAddresses) public allParticipatingAddresses;

	//Event to notify nodes that auction started and what is being acutioned.
	event AuctionStarted(uint256 auctionIdentifier, address whereToDirectBids, string description);
	//Event to notify nodes about auction ending and who won.
	event AuctionEnded(uint256 auctionIdentifier, address winner, uint highestBid);

	// Modifiers are a convenient way to validate inputs to functions. "onlyBefore" is applied
	// to "bid" below:
	// the new function body is the modifier's body there "_" is replaced by the old function body.
	modifier onlyBefore(uint _time){
		if(now >= _time) revert();
		_;
	}
	modifier onlyAfter(uint _time){
		if(now <= _time) revert();
		_;
	}

//🤔 === Feature in testing phase.
//🤠 === Feature tamed.
//😵 === Test failed.
//🚧 === Under construction.

//Reuse feature 🤠
//Remove existing bid data and prepare to reuse auction contract. 🤠
//Build all of the necessary mapping in order to support multithreading. 🤔
//Create the ability for multiple instances of auctions to run at the same time. 🚧

	//Remember that one time unit is one second.
	function BlindAuction(uint biddingTime, uint revealTime, address contractBeneficiary, bool startNow, string descriptionOfAuction){
		if(contractBeneficiary == 0){
			beneficiaries[currentNumberOfAuctions] = msg.sender;
		}
		else{
			beneficiaries[currentNumberOfAuctions] = contractBeneficiary;
		}
		if(startNow){
			auctionsStart[currentNumberOfAuctions] = now;
			biddingsEnd[currentNumberOfAuctions] = now + biddingTime;
			revealsEnd[currentNumberOfAuctions] = biddingsEnd[currentNumberOfAuctions] + revealTime;
			/*auctionStart = now;
			biddingEnd = now + biddingTime;
			revealEnd = biddingEnd + revealTime;*/
			AuctionStarted(currentNumberOfAuctions, this, descriptionOfAuction);

			currentNumberOfAuctions = 1;
		}
		else{
			currentNumberOfAuctions = 0;
		}
		numberOfAuctionParticipants[currentNumberOfAuctions] = 0;
	}

	function startAuction(uint _biddingTime, uint _revealTime, address _beneficiary, string descriptionOfAuction){
		if(_beneficiary == 0){
			beneficiaries[currentNumberOfAuctions] = msg.sender;
		}
		else{
			beneficiaries[currentNumberOfAuctions] = _beneficiary;
		}
		auctionsStart[currentNumberOfAuctions] = now;
		biddingsEnd[currentNumberOfAuctions] = now + _biddingTime;
		revealsEnd[currentNumberOfAuctions] = biddingsEnd[currentNumberOfAuctions] + _revealTime;
		/*auctionStart = now;
		biddingEnd = auctionStart + _biddingTime;
		revealEnd = biddingEnd + _revealTime;*/
		AuctionStarted(currentNumberOfAuctions, this, descriptionOfAuction);
		//No need for clearing current auctions, since we support multithreading.
		/*for(uint i = 0; i < numberOfParticipants; i++){
			delete bids[participatingAddresses[i]];
			delete participatingAddresses[i];
		}
		numberOfParticipants = 0;
		highestBidder = 0x0;
		highestBid = 0;*/
	}

	//Place a blinded bid with "_blindedbid" = sha3(value, fake, secret).
	//The sent ether is only refunded if the bid is correctly revealed in the revealing phase.
	//The bid is valid if the Ether sent together with the bid is at least "value" and "fake" is not
	//true. Setting "fake" to true and sending not the exact amount are ways to hide the real bid
	//but still make the required deposit. The same address can place multiple bids.
	//Use http://emn178.github.io/online-tools/keccak_256.html for calculating hash.
	//Value in the hashing mechanism is entered in wei, so take that into account when sending Ether.
	function bid(uint256 auctionIdentifier, bytes32 _blindedBid) onlyBefore(biddingsEnd[auctionIdentifier]) payable{
		//if(bids[msg.sender][0].blindedBid == 0x0){
				auctionBids[auctionIdentifier].bids[msg.sender].push(Bid({
					blindedBid: _blindedBid,
					deposit: msg.value
				}));
		/*	}
		else{
			bids[msg.sender][0].blindedBid = _blindedBid;
			bids[msg.sender][0].deposit = msg.value;
		}*/
		allParticipatingAddresses[auctionIdentifier].participatingAddresses[numberOfParticipants] = msg.sender;
		numberOfAuctionParticipants[auctionIdentifier] += 1;
	}

	// Reveal your blinded bids. You will get a refund for all correctly blinded invalid bids and for
	// all bids except for the totally highest one.
	//Value here is entered in wei, so be sure to take that into account when calculating hash for blindedBid.
	function reveal(uint256 auctionIdentifier, uint _value, bool _fake, string _secret) onlyAfter(biddingsEnd[auctionIdentifier]) onlyBefore(revealsEnd[auctionIdentifier]){
		uint refund;
		var bid = auctionBids[auctionIdentifier].bids[msg.sender][0];
		if(auctionBids[auctionIdentifier].bids[msg.sender][0].blindedBid == sha3(_value, !_fake, _secret)){
			refund += bid.deposit;
			if(!_fake && bid.deposit >= _value){
				if(placeBid(msg.sender, _value))
					refund -= _value;
			}
			//Make it impossible fot sender to reclaim the same deposit.
			bid.blindedBid = 0x0;
			if(!msg.sender.send(refund)){revert();}
		}
	}

	//This is an internal function and can only be called upon form the contract itself (or from derived contracts).
	function placeBid(uint256 auctionIdentifier, address bidder, uint value) internal returns (bool success){
		if(value <= highestBid[auctionIdentifier]){
			return false;
		}
		if(highestBidder != 0){
			//Refund the previously highest bidder.
			pendingReturns[highestBidder] += highestBid;
		}
		highestBid = value;
		highestBidder = bidder;
		return true;
	}

	// Withdraw a bid that was overbid.
	function withdraw(){
		var amount = pendingReturns[msg.sender];
		// It is important to set this to zero because the recipient can call this function again as a part of the receiving call
		// before "send" returns (see the remark about conditions ---> effects ---> interaction).
		pendingReturns[msg.sender] = 0;
		if(!msg.sender.send(amount)) revert(); // If anything fails, this will revert the changes above
	}

	// End the auction and send the highest bid to the beneficiary.
	function auctionEnd() onlyAfter(revealEnd){
		if(ended) revert();
		if(highestBidder != 0x0){
			AuctionEnded(highestBidder, highestBid);
		}
		ended = true;
		//We send all the money we have, because some of the refunds might have failed.
		if(!beneficiary.send(this.balance)) revert();
	}

	//Refuse to collect any Ether sent to the Auction without it being part of the function.
	function(){
		revert();
	}
}
