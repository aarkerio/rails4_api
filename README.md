# rails4_api

Little RESTful/JSON API for interchange data between veterinary clinics.

We are using a global user id (GUID) to identify users and Basic Auth over HTTPS for authenticaton.

Example: 
    https://4JJgHHU:s3cer3TYUiXX@api.yourcompany.com/v1/users/getinfo/fh5Uy67-E3QQ

Since the API must be:

https://api.your-company.com/v1

for all your customers, I'm adding a middleware "switcher" database.

Rspec and VCR to test the code.

Rails: 4.2.3
Ruby:  2.2.1p85

