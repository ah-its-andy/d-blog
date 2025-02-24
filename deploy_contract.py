import os
import subprocess
import json
from solcx import compile_standard, install_solc, get_installable_solc_versions, set_solc_version
from web3 import Web3

# Check if necessary dependencies are installed
def check_dependencies():
    print("Checking dependencies...")
    try:
        import solcx
    except ImportError:
        print("Dependency solcx is not installed. Installing...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "py-solc-x"])
    try:
        import web3
    except ImportError:
        print("Dependency web3 is not installed. Installing...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "web3"])
    print("Dependencies are up to date.")

# Compile the smart contract
def compile_contract():
    print("Compiling the smart contract...")
    contract_path = './contracts/ArticlePlatform.sol'
    with open(contract_path, 'r') as file:
        contract_source = file.read()
    
    # available_versions = get_installable_solc_versions()
    # print(f"Available Solidity versions: {available_versions}")
    # print("Solidity version 0.8.5 not found. Installing...")
    # install_solc('0.8.5')
    set_solc_version('0.8.28')
    compiled_sol = compile_standard({
        "language": "Solidity",
        "sources": {
            "ArticlePlatform.sol": {
                "content": contract_source
            }
        },
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "evm.bytecode"]
                }
            }
        }
    })
    
    output_path = './build/ArticlePlatform.json'
    with open(output_path, 'w') as file:
        json.dump(compiled_sol, file, indent=2)
    
    contract = compiled_sol['contracts']['ArticlePlatform.sol']['ArticlePlatform']
    print("Smart contract compiled successfully.")
    return contract

# Deploy the smart contract
def deploy_contract(contract, rpc_url, private_key):
    print("Deploying the smart contract...")
    w3 = Web3(Web3.HTTPProvider(rpc_url))
    account = w3.eth.account.from_key(private_key)
    w3.eth.default_account = account.address
    
    bytecode = contract['evm']['bytecode']['object']
    abi = contract['abi']
    
    Contract = w3.eth.contract(abi=abi, bytecode=bytecode)
    transaction = Contract.constructor().build_transaction({
        'from': account.address,
        'nonce': w3.eth.get_transaction_count(account.address),
        'gas': 2000000,
        'gasPrice': w3.to_wei('50', 'gwei')
    })
    
    signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
    tx_hash = w3.eth.send_raw_transaction(signed_txn.raw_transaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
    
    print(f'Contract deployed at address: {tx_receipt.contractAddress}')

# Main function
def main():
    print("Starting deployment script...")
    check_dependencies()
    contract = compile_contract()
    rpc_url = "https://ethereum-sepolia-rpc.publicnode.com"
    
    # Read private key from local file
    with open('private_key.txt', 'r') as file:
        private_key = file.read().strip()
    
    deploy_contract(contract, rpc_url, private_key)
    print("Deployment script completed.")

if __name__ == "__main__":
    main()
