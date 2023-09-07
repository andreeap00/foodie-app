# Food App after Translation to API

## API endpoints where token is not required:
- authentication endpoints:
  - log in;
  - log out;
  - sign up;
  - see all products in home.
  
## API endpoints where token is used:
- add the product to the basket, only with a user token;
- remove the product from the order, only with a user token / decrease quantity;
- see all the products in order, only with a user token;
- note an order as pending/handled/delivered, only with an admin token;
- display all users in the app, only with an admin token;
- modify a product from the list (except for images), only with an admin token;
- tests for 2 action endpoints;
- tests for 2 get endpoints;
- tests for unauthorized actions.
  
When a user is not authorized to perform a certain action depending on his/her role, 401 is returned.
In Postman Collection every endpoint is checked, both for authorized and unauthorized users.
