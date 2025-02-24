// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract ArticlePlatform {
    struct Article {
        string title;
        string summary;
        bytes compressedContent;
        address author;
        uint256 timestamp;
    }

    Article[] public articles;
    event ArticlePosted(uint256 id, string title, string summary, address author, uint256 timestamp);

    function postArticle(string memory title, string memory summary, bytes memory compressedContent) public {
        articles.push(Article({
            title: title,
            summary: summary,
            compressedContent: compressedContent,
            author: msg.sender,
            timestamp: block.timestamp
        }));
        emit ArticlePosted(articles.length - 1, title, summary, msg.sender, block.timestamp);
    }

    function getArticle(uint256 id) public view returns (string memory title, string memory summary, bytes memory compressedContent) {
        require(id < articles.length, "Article does not exist");
        Article storage article = articles[id];
        return (article.title, article.summary, article.compressedContent);
    }

    function getArticleList() public view returns (uint256[] memory ids, string[] memory titles, string[] memory summaries, address[] memory authors, uint256[] memory timestamps) {
        uint256 length = articles.length;
        ids = new uint256[](length);
        titles = new string[](length);
        summaries = new string[](length);
        authors = new address[](length);
        timestamps = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            Article storage article = articles[i];
            ids[i] = i;
            titles[i] = article.title;
            summaries[i] = article.summary;
            authors[i] = article.author;
            timestamps[i] = article.timestamp;
        }
    }
}
