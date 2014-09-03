ipforme
=======

Very simple Sinatra app to pass around IP addresses

Tested with Ruby 1.9.3-p547 and 2.1.2

#### Dependencies

``` gem install sinatra redis ```

Then start the app using `rackup`.

#### Usage: 

``` curl -sF 'hostip=ident_4.3.3.3' http://domain/ > /dev/null
    # and to get the result 
    curl http://domain/ident
```
