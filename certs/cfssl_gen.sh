#!/bin/bash

initca() {
    ## Generate root certificate 
    /Users/paulosilva/go/bin/cfssl genkey -initca root_ca.json | /Users/paulosilva/go/bin/cfssljson -bare root_ca
}

mongo() {
    ## Generate mongo certificate using the root
     /Users/paulosilva/go/bin/cfssl gencert -ca root_ca.pem -ca-key root_ca-key.pem -hostname=bsserver,10.0.0.21 mongo_csr.json |  /Users/paulosilva/go/bin/cfssljson -bare mongo
    cat mongo-key.pem mongo.pem > mongo_crt.pem
    ## Generate mongo_client certificate using the CA
     /Users/paulosilva/go/bin/cfssl gencert -ca root_ca.pem -ca-key root_ca-key.pem -hostname=bsserver,10.0.0.21 mongo_client_csr.json |  /Users/paulosilva/go/bin/cfssljson -bare mongo_client
    cat mongo_client-key.pem mongo_client.pem > mongo_client_crt.pem
}



web() {
    ## Generate demo web client using the root (must be installed on browser)
     /Users/paulosilva/go/bin/cfssl gencert -ca root_ca.pem -ca-key root_ca-key.pem web_csr.json |  /Users/paulosilva/go/bin/cfssljson -bare web
    cat web-key.pem web.pem > web_crt.pem
    cat web.pem root_ca.pem > web-bundle.pem
    openssl pkcs12 -inkey web-key.pem -in web-bundle.pem -export -out web.pfx
}

case $1 in
   "all") initca
          mongo
         ;;
   "mongo") mongo
         ;;
   "web") web
         ;;
   *) echo "Usage:    ./cfssl_gen [OPTIONS]"
        echo ""
        echo "Options:"
        echo ""
        echo "  all               Generate CA certificate, init CFSSL and generate mongo, client and web certificates"
        echo "  mongo             Generate Mongo server and client certificates"
        echo "  web               Generate web interface certificate"
        echo ""
        exit 1
        ;;
esac
