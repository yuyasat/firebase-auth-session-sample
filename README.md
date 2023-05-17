# README
* Ruby version
3.2.0

* System dependencies

* Configuration

* Database creation
```
bin/rails db:create db:migrate
```

# Curl command examples
## register user
```
curl -XPOST -i -H "Content-Type: application/json" -d '{ "token": "TOKEN_FROM_FirebaseAuth_HERE" }' http://localhost:3000/users
#=> get JWT from Authorization Header
```

## sign in user
```
curl -XPOST -i -H "Content-Type: application/json"  -d '{ "token": "TOKEN_FROM_FirebaseAuth_HERE" }' http://localhost:3001/users/sign_in
#=> get JWT from Authorization Header
```

## check whether private data
```
curl -XGET -H "Authorization: Bearer TOKEN_FROM_devise-jwt_HERE" -H "Content-Type: application/json" http://localhost:3000/member-dat
```

## logout
```
curl -XDELETE -i -H "Content-Type: application/json" -H "Authorization: Bearer TOKEN_FROM_devise-jwt_HERE" http://localhost:3000/users/sign_out
```
