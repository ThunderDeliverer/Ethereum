/*
Generated by Mix
Thu Jul 21 14:51:30 2016 GMT+0200
*/

var BlindAuction = {
	"abi": "[{\"constant\":true,\"inputs\":[{\"name\":\"\",\"type\":\"address\"},{\"name\":\"\",\"type\":\"uint256\"}],\"name\":\"bids\",\"outputs\":[{\"name\":\"blindedBid\",\"type\":\"bytes32\"},{\"name\":\"deposit\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"ended\",\"outputs\":[{\"name\":\"\",\"type\":\"bool\"}],\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"auctionEnd\",\"outputs\":[],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"beneficiary\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"withdraw\",\"outputs\":[],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"biddingEnd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"auctionStart\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_values\",\"type\":\"uint256[]\"},{\"name\":\"_fake\",\"type\":\"bool[]\"},{\"name\":\"_secret\",\"type\":\"bytes32[]\"}],\"name\":\"reveal\",\"outputs\":[],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"highestBidder\",\"outputs\":[{\"name\":\"\",\"type\":\"address\"}],\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_blindedBid\",\"type\":\"bytes32\"}],\"name\":\"bid\",\"outputs\":[],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"revealEnd\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"highestBid\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"type\":\"function\"},{\"inputs\":[{\"name\":\"_biddingTime\",\"type\":\"uint256\"},{\"name\":\"_revealTime\",\"type\":\"uint256\"},{\"name\":\"_beneficiary\",\"type\":\"address\"}],\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"winner\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"highestBid\",\"type\":\"uint256\"}],\"name\":\"AuctionEnded\",\"type\":\"event\"}]",
	"codeHex": "0x6060604052604051606080610ac5833981016040528080519060200190919080519060200190919080519060200190919050505b80600060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908302179055504260016000508190555082420160026000508190555081600260005054016003600050819055505b505050610a2e806100976000396000f3606060405236156100b6576000357c01000000000000000000000000000000000000000000000000000000009004806301495c1c146100c357806312fa6feb146101035780632a24f46c1461012857806338af3eed146101375780633ccfd60b14610170578063423b217f1461017f5780634f245ef7146101a2578063900f080a146101c557806391f90157146102a0578063957bb1e0146102d9578063a6e66477146102f1578063d57bde7914610314576100b6565b6100c15b610002565b565b005b6100e26004808035906020019091908035906020019091905050610337565b60405180836000191681526020018281526020019250505060405180910390f35b6101106004805050610381565b60405180821515815260200191505060405180910390f35b6101356004805050610394565b005b61014460048050506104d1565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b61017d60048050506104f7565b005b61018c60048050506105a1565b6040518082815260200191505060405180910390f35b6101af60048050506105aa565b6040518082815260200191505060405180910390f35b61029e60048080359060200190820180359060200191919080806020026020016040519081016040528093929190818152602001838360200280828437820191505050505050909091908035906020019082018035906020019191908080602002602001604051908101604052809392919081815260200183836020028082843782019150505050505090909190803590602001908201803590602001919190808060200260200160405190810160405280939291908181526020018383602002808284378201915050505050509090919050506105b3565b005b6102ad60048050506107f8565b604051808273ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b6102ef600480803590602001909190505061081e565b005b6102fe6004805050610919565b6040518082815260200191505060405180910390f35b6103216004805050610922565b6040518082815260200191505060405180910390f35b600560005060205281600052604060002060005081815481101561000257906000526020600020906002020160005b91509150508060000160005054908060010160005054905082565b600460009054906101000a900460ff1681565b60036000505480421115156103a857610002565b600460009054906101000a900460ff16156103c257610002565b7fdaec4582d5d9595688c8c98545fdd1c696d41c6aeaeb636737e84ed2f5c00eda600660009054906101000a900473ffffffffffffffffffffffffffffffffffffffff16600760005054604051808373ffffffffffffffffffffffffffffffffffffffff1681526020018281526020019250505060405180910390a16001600460006101000a81548160ff02191690830217905550600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1660003073ffffffffffffffffffffffffffffffffffffffff1631604051809050600060405180830381858888f1935050505015156104cd57610002565b505b565b600060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b6000600860005060003373ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000505490506000600860005060003373ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600050819055503373ffffffffffffffffffffffffffffffffffffffff16600082604051809050600060405180830381858888f19350505050151561059d57610002565b5b50565b60026000505481565b60016000505481565b600060006000600060006000600060026000505480421115156105d557610002565b60036000505480421015156105e957610002565b600560005060003373ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600050805490509850888c5114158061062f5750888b5114155b8061063b5750888a5114155b1561064557610002565b600096505b888710156107ac57600560005060003373ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060005087815481101561000257906000526020600020906002020160005b5095508b87815181101561000257906020019060200201518b88815181101561000257906020019060200201518b8981518110156100025790602001906020020151945094509450848484604051808481526020018315157f010000000000000000000000000000000000000000000000000000000000000002815260010182600019168152602001935050505060405180910390206000191686600001600050546000191614151561074e5761079f565b856001016000505488019750875083158015610771575084866001016000505410155b1561078e57610780338661092b565b1561078d57848803975087505b5b600060010286600001600050819055505b868060010197505061064a565b3373ffffffffffffffffffffffffffffffffffffffff16600089604051809050600060405180830381858888f1935050505015156107e957610002565b50505b50505050505050505050565b600660009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1681565b600260005054804210151561083257610002565b600560005060003373ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060005080548060010182818154818355818115116108c3576002028160020283600052602060002091820191016108c29190610895565b808211156108be5760006000820160005060009055600182016000506000905550600201610895565b5090565b5b5050509190906000526020600020906002020160005b6040604051908101604052808681526020013481526020015090919091506000820151816000016000505560208201518160010160005055505050505b50565b60036000505481565b60076000505481565b6000600760005054821115156109445760009050610a28565b6000600660009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff161415156109ea5760076000505460086000506000600660009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828282505401925050819055505b8160076000508190555082600660006101000a81548173ffffffffffffffffffffffffffffffffffffffff0219169083021790555060019050610a28565b9291505056",
	"name": "BlindAuction"
}

