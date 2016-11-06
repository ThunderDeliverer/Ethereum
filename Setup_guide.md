Ethereum installation

Installation of MIX IDE and AlethZero
At link https://github.com/ethereum/webthree-umbrella/releases/tag/v1.2.9 you can find Windows, OS X/ Mac OS and Linux download links. At this moment it still contains AlethZero, which will be probably phased out in future releases.

Installation of resources
Described process is designed for OS X El Capitan 10.11.5. Linux installation guide can be found here: http://solidity.readthedocs.io/en/latest/installing-solidity.html.
Installing npm / Node.js provides C++ source code compilation into JavaScript using Emscripten fir browser-solidity.

	npm install solc

We use Homebrew, Package manager for OS X (http://brew.sh/), to install a few other resources needed to fully utilise solidity.

	brew update
	brew upgrade

	brew install boost --c++11             # this takes a while
	brew install cmake cryptopp miniupnpc leveldb gmp libmicrohttpd libjson-rpc-cpp
		# For Mix IDE and Alethzero only
	brew install xz d-bus
	brew install homebrew/versions/v8-315
	brew install llvm --HEAD --with-clang
	brew install qt5 --with-d-bus          # add --verbose if long waits with a stale screen drive you crazy as well

And finally we can run Solidity with.

	git clone --recursive https://github.com/ethereum/webthree-umbrella.git
	cd webthree-umbrella && mkdir -p build && cd build
	cmake ..

Some of the commands take a while to load. Using “--verbose” command enables us to see all processes that are running.
The indented lines are Terminal commands. You can just copy-paste them into it and it will run them one after the other.
