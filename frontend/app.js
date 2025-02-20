document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('publishForm');
    form.addEventListener('submit', async (event) => {
        event.preventDefault();
        const contractAddress = document.getElementById('contractAddress').value;
        const title = document.getElementById('title').value;
        const content = document.getElementById('content').value;
        const algo = document.getElementById('algo').value;

        if (window.ethereum) {
            const web3 = new Web3(window.ethereum);
            try {
                await window.ethereum.enable();
                const accounts = await web3.eth.getAccounts();
                const account = accounts[0];

                const contractABI = [
                    {
                        "inputs": [
                            {"internalType": "string", "name": "_title", "type": "string"},
                            {"internalType": "bytes[]", "name": "_content", "type": "bytes[]"},
                            {"internalType": "string", "name": "_algo", "type": "string"}
                        ],
                        "name": "pub",
                        "outputs": [],
                        "stateMutability": "nonpayable",
                        "type": "function"
                    }
                ];

                const contract = new web3.eth.Contract(contractABI, contractAddress);
                const contentBytes = web3.utils.utf8ToHex(content);

                const result = await contract.methods.pub(title, [contentBytes], algo).send({ from: account });
                document.getElementById('result').innerText = `Transaction successful: ${result.transactionHash}`;
            } catch (error) {
                console.error(error);
                document.getElementById('result').innerText = `Error: ${error.message}`;
            }
        } else {
            alert('Please install MetaMask!');
        }
    });
});
