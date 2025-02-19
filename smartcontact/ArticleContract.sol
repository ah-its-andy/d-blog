// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArticleContract {
    enum Type { Article, Revision }

    struct Article {
        Type ct;
        string title;
        bytes32 revTx;
        string algo;
        bytes[] content;
    }

    Article private art;

    function pub(string memory _title,  bytes[] memory _content,  string memory _algo) public {
        Article storage a = art;
        a.ct = Type.Article;
        a.content = _content;
        a.title = _title;
        a.algo = _algo;
    }

    function revise(bytes32 _revTx, bytes[] memory _content, string memory _algo) public {
        Article storage a = art;
        a.ct = Type.Revision;
        a.revTx = _revTx;
        a.content = _content;
        a.algo = _algo;
    }

    function getContent() public view returns (bytes[] memory) {
        return art.content;
    }

    function getType() public view returns (Type) {
        return art.ct;
    }

    function getRevTx() public view returns (bytes32) {
        return art.revTx;
    }

    function getAlgo() public view returns (string memory) {
        return art.algo;
    }

    function getTitle() public view returns (string memory) {
        return art.title;
    }
}
