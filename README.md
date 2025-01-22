# GoFundMe (but on chain 😉)

This is a proof of concept I built while working my way through the Cyfrin Updraft Solidity Smart Contract Development course. 
One of the exercises was built around this funding concept so I decided to take it a couple steps further with my own spin and add some stuff

- added the opening logic to prevent people from accidentally sending funds to the contract after the deployer has stopped looking.
- added the balance and balanceUsd functions to allow for easy checking of the donations collected so far by the owner
- added the collection delegation logic to allow the contract owner to set an alternative address to recieve the donations to