//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract TweetContract {
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 createdAt;
    }

    struct Message {
        uint256 id;
        string content;
        address from;
        address to;
        uint256 createdAt;
    }

    mapping(uint256 => Tweet) public tweets;
    mapping(address => uint256[]) public tweetsof;
    mapping(address => Message[]) public conversations;
    mapping(address => mapping(address => bool)) public operators;
    mapping(address => address[]) public following;

    uint256 nextId;
    uint256 nextMessageId;

    function _tweet(address _from, string memory _content) internal {
        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);
        tweetsof[_from].push(nextId);
        nextId = nextId + 1;
    }

    function _sendMessage(
        address _from,
        address _to,
        string memory _content
    ) internal {
        conversations[_from].push(
            Message(nextMessageId, _content, _from, _to, block.timestamp)
        );
        nextMessageId++;
    }

    function tweet(string memory _content) public {
        _tweet(msg.sender, _content);
    }

    function tweet(address _from, string memory _content) public {
        _tweet(_from, _content);
    }

    function sendMessage(string memory _content, address _to) public {
        _sendMessage(msg.sender, _to, _content);
    }

    function sendMessage(
        address _from,
        address _to,
        string memory _content
    ) public {
        _sendMessage(_from, _to, _content);
    }

    function follow(address _followed) public {
        following[msg.sender].push(_followed);
    }

    function allow(address _operator) public {
        operators[msg.sender][_operator] = true;
    }

    function disallow(address _operator) public {
        operators[msg.sender][_operator] = false;
    }

    function getLetestTweets(uint256 count)
        public
        view
        returns (Tweet[] memory)
    {
        require(count > 0 && count <= nextId);
        Tweet[] memory _tweets = new Tweet[](count);

        uint256 j;

        for (uint256 i = nextId - count; i < nextId; i++) {
            Tweet storage _structure = tweets[i];
            _tweets[j] = Tweet(
                _structure.id,
                _structure.author,
                _structure.content,
                _structure.createdAt
            );
            j = j + 1;
        }
        return _tweets;
    }

    function getLatestofUser(address _user, uint256 count)
        public
        view
        returns (Tweet[] memory)
    {
        Tweet[] memory _tweets = new Tweet[](count);
        uint256[] memory ids = tweetsof[_user];

        require(count > 0 && count <= nextId, "count is not defined");
        uint256 j;
        for (
            uint256 i = tweetsof[_user].length - count;
            i < tweetsof[_user].length;
            i++
        ) {
            Tweet storage _structure = tweets[ids[i]];
            _tweets[j] = Tweet(
                _structure.id,
                _structure.author,
                _structure.content,
                _structure.createdAt
            );
            j = j + 1;
        }
        return _tweets;
    }
}
