# Generating Self-Signed Certificates

These instructions pertain to the generation of self-signed certificates used to encrypt interactions between a server and a client application/container (such as Alembic, DBV, the listener, etc) via SSL/TLS.

You can either run a container with `openssl` to generate certificates, or use a program like git bash for windows users.

These instructions are based on the official MySQL Documentation on [Creating SSL Certificates](https://dev.mysql.com/doc/refman/8.0/en/creating-ssl-files-using-openssl.html#creating-ssl-files-using-openssl-unix-command-line).

Run a container with `alpine` that has access to a directory for the certs on the host:

```shell
docker run --rm -it -v $PWD/certs:/certs alpine:latest sh
```

Install `openssl`:

```shell
apk add openssl
```

Note: Execute the following commands inside the `/certs` directory or move the required files there at the end to make them available on your host.

Generate the certificate authority (CA) certificates:

```shell
# Create CA private key
openssl genrsa 4096 > ca-key.pem
# Create CA public key
# 
# Country Name: CA
# State: QC
# Locality: Montreal
# Organization Name: Opal Med Apps CA
# Common Name: ca.opalmedapps.dev
# Email Address: <your email>
# the rest can be left empty
openssl req -new -x509 -nodes -days 3600 -key ca-key.pem -out ca.pem
```

Generate the server certificate:

```shell
# Create the server's private key and a certificate request for the CA
# 
# Country Name: CA
# State: QC
# Locality: Montreal
# Organization Name: Opal Med Apps
# Common Name: db
# Email Address: <your email>
# the rest can be left empty (the challenge password has to be empty)
openssl req -newkey rsa:2048 -days 3600 -nodes -keyout server-key.pem -out server-req.pem
# let the CA issue a certificate for the server
openssl x509 -req -in server-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-cert.pem
```

These server certificates are meant to be used by your database for authenticating incoming requests while the `ca.pem` file is used by clients to make requests to the database.

Verify that the server certificate is valid:

```shell
openssl verify -CAfile ca.pem server-cert.pem
```
