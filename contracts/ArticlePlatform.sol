// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ArticlePlatform is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Article {
        string title;
        string summary;
        bytes compressedContent;
        address author;
        uint256 timestamp;
    }

    mapping(uint256 => Article) private _articles;
    event ArticlePosted(uint256 id, string title, string summary, address author, uint256 timestamp);

    constructor() ERC721("ArticleNFT", "ANFT") {}

    function mint(string memory title, string memory summary, bytes memory compressedContent) public {
        _tokenIds.increment();
        uint256 newArticleId = _tokenIds.current();

        _articles[newArticleId] = Article({
            title: title,
            summary: summary,
            compressedContent: compressedContent,
            author: msg.sender,
            timestamp: block.timestamp
        });

        _mint(msg.sender, newArticleId);
        emit ArticlePosted(newArticleId, title, summary, msg.sender, block.timestamp);
    }

    function get(uint256 id) public view returns (string memory title, string memory summary, bytes memory compressedContent, address author, uint256 timestamp) {
        require(_exists(id), "Article does not exist");
        Article storage article = _articles[id];
        return (article.title, article.summary, article.compressedContent, article.author, article.timestamp);
    }

    function getList(uint256 start, uint256 count) public view returns (uint256[] memory ids, string[] memory titles, string[] memory summaries, address[] memory authors, uint256[] memory timestamps) {
        uint256 length = _tokenIds.current();
        require(start < length, "Start index out of bounds");
        uint256 end = start + count > length ? length : start + count;

        ids = new uint256[](end - start);
        titles = new string[](end - start);
        summaries = new string[](end - start);
        authors = new address[](end - start);
        timestamps = new uint256[](end - start);

        for (uint256 i = start; i < end; i++) {
            Article storage article = _articles[i + 1];
            ids[i - start] = i + 1;
            titles[i - start] = article.title;
            summaries[i - start] = article.summary;
            authors[i - start] = article.author;
            timestamps[i - start] = article.timestamp;
        }
    }

    function getCount() public view returns (uint256) {
        return _tokenIds.current();
    }

    function transfer(address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Caller is not owner nor approved");
        _transfer(msg.sender, to, tokenId);
    }
}
