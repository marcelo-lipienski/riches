# Riches

Riches is an ATM simulation API.

## Installation

### Dependencies

Riches requires any docker supporting docker-compose version '3.7'.

Refer to [Get Doker](https://docs.docker.com/get-docker/), if you don't already have it installed on your computer.

After installing docker, you may clone this project by running

```bash
git clone git@github.com:marcelo-lipienski/riches
```

## Usage

```bash
# Once you have cloned the repo, make sure you're inside it, if not
cd riches

# To make things easier, I already setup a .env for you.
# (yeah, I know we're not supposed to push env settings into a repository)

# Then you can start the server with
docker-compose up -d

# You may wanna check if riches is running by accessing http://localhost:3000
# I did not remove that page on purpose :)

# Then, the first time you execute the docker image, you need to setup the project's database
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate

# To run the tests (given the docker image is already up)
docker-compose exec web rspec spec

# Or maybe you want to access the rails console for the project
docker-compose exec web rails c

# Any other rails command should be preceded by `docker-compose exec web`

```

## Endpoints

### Users

#### POST /users (Creates a new user)

Request params
```json
{
  "fullname": "Your name",
  "document": "12345678901", # CPF
  "birthdate": "1988-03-03",
  "gender": "M",             # M = Male, F = Female
  "password": "super-secret-password",
  "address": {
    "country": "Brazil",
    "state": "SP",
    "city": "São Carlos",
    "district": "Cidade Jardim",
    "street": "Not sharing my address with you. haha :)",
    "number": "123",
    "complement": "Only attribute that is not mandatory",
    "zip_code": "12345678"
  }
}
```
Response
```json
# HTTP STATUS: CREATED

{
  "fullname": "Your name",
  "document": "12345678901",
  "birthdate": "1988-03-03",
  "gender": "M",
  "token: "JSON Web Token",  # You should save this somewhere
  "address": {
    "country": "Brazil",
    "state": "SP",
    "city": "São Carlos",
    "district": "Cidade Jardim",
    "street": "Not sharing my address with you. haha :)",
    "number": "123",
    "complement": "Only attribute that is not mandatory",
    "zip_code": "12345678"
  }
}

# Or HTTP STATUS: BAD REQUEST if any error has ocurred
```

All other request must be authorized with `Authorization: Bearer token`, where token is the one given in the response after you've created your user account.

### Accounts

#### GET /accounts/balance

Response
```json
# HTTP STATUS: OK

{
  "balance": "12345.98"
}

# Or HTTP STATUS: NOT FOUND if could not authorize with your Bearer token
```

#### GET /accounts/statement

Request params
```json
# Optional, if you don't provide the request param,
#   it will show your statement for the last 7 days

{
  "since": "10" # Should be a positive Integer
}
```

Response
```json
# HTTP STATUS: OK
{
  "starting_balance": "0",
  "final_balance": "500.00",
  "transactions": [{
    "timestamp": "2020-08-08 02:07:38 UTC",
    "amount": "1000.00",
    "action": "deposit",
    "from": "1000",   # account number
    "to": "1000"      # a deposit is always from an account to the same account (at least here)
  }, {
    "timestamp": "2020-08-09 02:07:38 UTC",
    "amount": "250.00",
    "action": "transfer",
    "from": "1000",   # account number
    "to": "2918"      # another account (a transfer can never be from and to the same account)
  }, {
    "timestamp": "2020-08-11 02:07:38 UTC",
    "amount": "250.00",
    "action": "withdrawal",
    "from": "1000",   # account number
    "to": "1000"      # a withdrawal is always from an to the same account
  }]
}

# starting_balance can be negative given some scenarios:
# 1. Since statement is from a given period, an account may have positive balance before
#    the period being shown.
#
# 2. An user can use their account limit to transfer and withdraw, balance does not account
#    for their account limit.

# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

#### PUT /accounts

Request params
```json
{
  "limit": "2000"
}
```

Response
```json
# HTTP STATUS: OK

{
  "number": "1000",
  "agency": "2213",
  "limit": "2000"
}

# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

### Transactions

#### POST /transactions/deposit

Request params
```json
{
  "amount": "500"
}
```

Response
```json
# HTTP STATUS: OK
# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

#### POST /transactions/withdrawal_request

Request params
```json
{
  "amount": "500"
}
```

Response
```json
# HTTP STATUS: OK

{
  "withdrawal_request": "uuid", # this is required to complete the withdrawal
  "withdrawal_options": [{
    "50": "10" # meaning it will be ten R$ 50 bills
  }, {
    "50": "8", # meaning it will be eight R$ 50
    "20": "5"  # and five R$ 20 bills
  }]
}

# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

#### POST /transactions/withdrawal

Request params
# HTTP STATUS: OK

```json
{
  "withdrawal_request": "uuid" # this is the UUID given in response to a withdrawal_request
}
```

Response
```json
# HTTP STATUS: OK

{
  "amount": "500" # the amount requested at the withdrawal_request with given UUID
}

# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

#### POST /transactions/transfer

Request params
```json
{
  "document": "12345678901", # CPF
  "number": "1234", # account number to whom you're transfering to (can't be yourself)
  "agency": "2138", # agency to whom you're transfering to
  "amount": "500"
}
```

Response
```json
# HTTP STATUS: OK

# Or HTTP STATUS: BAD REQUEST
# Or HTTP STATUS: NOT FOUND if could not authorize with Bearer token
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)