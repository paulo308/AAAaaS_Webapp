from pymongo import MongoClient

import os

_CODE_CREATE_USER = 
db.getSiblingDB('$external').runCommand(
  {
    createUser: 'OU=mongo_client,O=BIGSEA,L=Coimbra,ST=CB,C=PT',
    roles: [
             { role: 'readWrite', db: 'AAADB' },
             { role: 'userAdminAnyDatabase', db: 'AAADB' }
           ],
    writeConcern: { w: 'majority' , wtimeout: 5000 }
  }
)


PWD="H1DiZeMWdU4UmA=="
"""_DEFAULT_DB_HOST = 'mongo'
_DEFAULT_DB_PORT = 27017"""

_DEFAULT_DB_HOST = os.getenv('AUTH_DB_HOST')
_DEFAULT_DB_PORT = int(os.getenv('AUTH_DB_PORT'))

"""_DEFAULT_DB_HOST = dbhost
_DEFAULT_DB_PORT = dbport"""

_DEFAULT_DB_NAME = 'AAADB'
_DEFAULT_CLIENT_CERT = 'certs/mongo_client_crt.pem'
_DEFAULT_CA_CERT = 'certs/root_ca.pem'
_DEFAULT_USER = 'OU=mongo_client,O=BIGSEA,L=Coimbra,ST=CB,C=PT'
_DEFAULT_MECHANISM = 'MONGODB-X509'

if __name__ == '__main__':
    client = MongoClient(_DEFAULT_DB_HOST, _DEFAULT_DB_PORT)
    db = client["admin"]
    db.add_user("admin", pwd=PWD,
            roles=[{'role':'readWrite', 'db':'AAADB'},
                   {'role':'userAdminAnyDatabase', 'db': 'admin'}])
    db.authenticate("admin", PWD)
    db.eval(_CODE_CREATE_USER)
