# Vehicle Ownership Registry

A decentralized application built on the Stacks blockchain for registering and transferring vehicle ownership.

## Overview

This project provides a transparent and immutable record of vehicle ownership using blockchain technology. It allows users to register vehicles, transfer ownership, and verify the ownership history of any registered vehicle.

## Features

- Register vehicles with VIN, make, model, and year
- Transfer vehicle ownership securely
- View complete ownership history for any vehicle
- Admin controls for system management

## Smart Contract Functions

### Admin Functions
- `set-admin`: Update the contract administrator

### User Functions
- `register-vehicle`: Register a new vehicle on the blockchain
- `transfer-ownership`: Transfer vehicle ownership to another user
- `get-vehicle-info`: Get detailed information about a vehicle
- `get-vehicle-owner`: Get the current owner of a vehicle

## Development

This project is built using Clarity, the smart contract language for the Stacks blockchain.

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet)
- [Stacks CLI](https://github.com/blockstack/stacks.js)