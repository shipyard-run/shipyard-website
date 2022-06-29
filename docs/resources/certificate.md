---
id: certificate
title: Certificate
---

The Certificate resource is split into two sub resources `certificate_ca` that allows you to create x509 Root Certificates and the associated Private Key.
`certificate_leaf` that allows the creation of self-signed x509 Leaf Certificates and associated Private Keys

## Minimal example

The following example shows how to create a root certificate and leaf certificate that could be used to enable TLS for a HTTP API.

```javascript
certificate_ca "cd_consul_ca" {
  output = data("certs")
}

certificate_leaf "cd_consul_server" {
  # Ensure the CA has been created before generating the leaf
  depends_on = ["certificate_ca.cd_consul_ca"]

  ca_key = "${data("certs")}/cd_consul_ca.key"
  ca_cert = "${data("certs")}/cd_consul_ca.cert"

  ip_addresses = ["127.0.0.1"]

  dns_names = [
    "localhost",
    "server.${var.cd_consul_dc}.consul",
    "1.consul.server.container.shipyard.run",
    "2.consul.server.container.shipyard.run",
    "3.consul.server.container.shipyard.run"
  ]

  output = data("certs")
}
```

# Root Certificates

The following parameters are available for creating `certificate_ca` resources, when a new resource is created Shipyard will create the certificate
and associated private key and write them to the `output` folder. Certificates do not perisist the lifecycle of a blueprint, when a blueprint is destroyed the created certs and keys are removed from the output folder.

**Root Certificates have a pre-set Common Name corresponding to the name of the resource**


## Parameters **certificate_ca**

### output
**Type: `string`**  
**Required: true**  

The location to write the certificate to, the certificate and the associated RSA private key will be written to the output folder
using the following convention.

```
[output]/[resource_name].cert
[output]/[resource_name>].key

e.g.
myfolder/cd_consul_ca.cert
myfolder/cd_consul_ca.key
```

# Leaf Certificates

The following parameters are available for creating `certificate_leaf` resources, when a new resource is created Shipyard will create the certificate
and associated private key and write them to the `output` folder. Certificates do not perisist the lifecycle of a blueprint, when a blueprint is destroyed the created certs and keys are removed from the output folder.

To create a leaf certificate Shipyard needs a valid CA certificate and private key, these can be generated using the `certificate_ca` resource or
can be an existing x509 certificate and associated RSA private key.

**Leaf Certificates have a pre-set Common Name corresponding to the name of the resource**

## Parameters **certificate_leaf**

### ca_key
**Type: `string`**  
**Required: true**  

Path to the Private Key that was used to create the Root Certificate

### ca_cert
**Type: `string`**  
**Required: true**  

Path to the Root certificate that will be used to sign the Leaf

### ip_address
**Type: `[]string`**  
**Required: false**  

Array of IP addresses to be added to the certificate

### dns_names
**Type: `[]string`**  
**Required: false**  

Array of DNS names to be added to the certificate as a DNS SAN

### output
**Type: `string`**  
**Required: true**  

The location to write the certificate to, the certificate and the associated RSA private key will be written to the output folder
using the following convention.

```
[output]/[resource_name].cert
[output]/[resource_name>].key

e.g.
myfolder/cd_consul_ca.cert
myfolder/cd_consul_ca.key
```

## Examples

### Root Certificate

The following resource defining a Root Certiifcate

```shell
certificate_ca "cd_consul_ca" {
  output = data("certs")
}

```

Would create the following certificate, to examine created certificates you can use OpenSSL   
e.g. `openssl x509 -in file.cert -text`.

```shell
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            48:c3:64:e8:84:68:3b:d0:f6:7e:25:58:04:01:3f:e4
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = Shipyard, CN = cd_consul_ca
        Validity
            Not Before: Jun 29 06:44:43 2022 GMT
            Not After : Mar 21 06:44:43 2023 GMT
        Subject: O = Shipyard, CN = cd_consul_ca
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (4096 bit)
                Modulus:
                    00:ca:53:b9:21:17:a9:29:be:43:c1:6a:88:ae:bd:
                    44:96:8c:d4:a4:b5:16:db:94:33:9c:0b:a0:30:33:
                    b3:df:21:e7:4e:8c:57:61:90:e8:ef:27:f0:04:7b:
                    b4:7f:9e:e9:2e:61:d2:1d:29:e0:a8:33:fd:2a:a1:
                    f7:a1:e5:0b:bc:95:a7:bd:76:b5:da:b8:a9:26:5f:
                    03:78:e7:93:00:27:d4:16:20:06:34:26:97:1f:21:
                    41:08:c4:4b:1f:25:03:18:b9:8a:57:02:ee:59:44:
                    e0:fe:b7:eb:47:be:64:be:e4:b6:5a:21:d0:ee:0d:
                    ae:68:37:b1:68:ac:18:0b:b3:b1:e8:5e:2b:1a:db:
                    bb:07:a0:63:11:fd:f2:6d:7b:34:23:b8:5f:e3:f7:
                    7a:56:49:9c:0d:2e:be:2c:9f:f0:0d:e0:3e:45:da:
                    f4:fd:ff:64:a2:32:b9:d7:a6:14:df:4d:04:fd:47:
                    b3:57:0d:3f:2c:5b:d6:54:2b:e0:4f:ce:a5:d3:40:
                    be:f5:34:4e:7c:1b:e9:5e:af:8e:33:74:64:2c:3c:
                    9d:1d:14:92:c0:c9:25:d0:15:c9:9b:41:84:4e:7e:
                    d2:bd:91:69:ac:62:0c:d7:07:e6:90:c1:b0:70:fe:
                    00:6f:3e:8b:39:07:88:49:4a:c8:f7:13:63:94:19:
                    44:09:2b:d1:9f:32:38:dc:6e:25:c4:f5:c1:ce:95:
                    56:ea:3b:d7:33:be:43:5e:8e:76:c6:e3:c6:57:ca:
                    92:86:f5:71:24:d5:ab:91:a6:60:c5:e1:63:23:0d:
                    96:38:d9:c6:9f:98:b9:b1:23:62:4c:83:ab:ff:d5:
                    8d:29:0a:9e:43:bb:89:a9:78:ed:77:29:de:5f:5b:
                    d4:cd:14:8c:27:8a:52:24:28:22:bb:a9:6b:c7:7d:
                    a9:48:58:e1:a9:e7:8d:a2:b1:76:17:cc:a7:35:04:
                    56:f8:e5:4a:41:be:5a:31:d5:37:4c:61:8e:d7:8b:
                    b1:a8:fc:9d:69:6b:0f:85:36:27:1b:30:c1:bb:62:
                    bf:2b:cc:55:26:cd:d4:d9:22:63:af:6f:a7:8b:f4:
                    7f:51:20:bf:09:61:10:f0:96:cf:c8:59:4d:27:57:
                    f4:64:1f:de:21:37:f4:9e:ea:95:98:1f:8f:d0:f0:
                    fa:83:3c:52:f4:f2:a5:a4:4f:f9:32:00:91:02:56:
                    26:0b:fe:2e:5b:f1:ea:f1:36:db:98:f6:90:4a:c4:
                    d4:ef:8c:f7:94:19:7d:74:a0:63:b4:4e:c7:2d:f2:
                    50:93:59:6d:39:58:49:30:13:86:70:7b:3a:1e:f7:
                    b4:a9:be:aa:82:94:8a:74:95:fd:5b:34:3a:2f:24:
                    2f:d4:19
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Certificate Sign
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                66:0B:00:F3:5B:E1:69:B6:1C:A3:BB:68:0E:2C:69:B8:28:F3:E7:55
    Signature Algorithm: sha256WithRSAEncryption
         0a:03:85:5b:f7:cc:10:e9:33:46:86:85:a6:ae:be:14:66:fb:
         62:44:ba:79:38:88:41:b1:05:cd:45:c0:bc:e5:96:6a:a5:19:
         c6:6c:da:54:47:8c:38:ba:78:9e:03:cd:0e:fe:fc:48:c2:ae:
         ac:2f:60:f7:41:7c:af:40:10:14:ca:fc:58:50:16:09:fe:74:
         11:c3:26:42:4c:05:4f:12:1f:a2:3d:8a:06:18:e2:a3:32:34:
         96:18:7f:af:23:15:3c:df:dd:8c:50:ed:09:e3:0e:8a:5f:cd:
         77:a5:7e:bf:c5:22:df:5b:ba:1a:6e:b5:cf:53:e7:08:3d:d3:
         1c:7f:4e:81:29:57:32:24:8f:4a:e1:20:b2:39:f4:f0:83:19:
         52:63:cb:e9:b7:57:3f:92:b2:86:15:59:8c:71:b9:e0:4a:74:
         52:12:2e:3b:93:6d:0b:59:cf:84:7d:ea:78:55:e9:0d:53:74:
         f8:2a:d6:69:ea:3b:73:36:cc:12:35:03:42:e1:b2:68:5a:b4:
         d4:51:8a:fd:49:37:04:82:d6:24:9c:0a:f8:a2:74:02:4e:54:
         1d:88:2f:df:59:00:c1:60:d5:d3:a2:27:98:d7:35:f4:ef:7a:
         65:03:ef:87:c6:6f:aa:c8:4f:ac:3a:4c:80:ae:aa:df:b1:4e:
         12:c5:38:57:f5:74:db:84:d8:2b:0c:2a:62:c1:b6:00:4e:6b:
         11:45:d0:13:1c:09:c7:7c:e5:7f:b5:80:67:57:5e:ae:c5:29:
         91:65:30:82:06:a7:77:fb:f6:be:30:34:a4:0a:1e:cc:eb:22:
         7b:41:fe:13:33:bf:da:d0:50:a5:44:ca:66:2d:57:73:90:4b:
         15:5d:50:43:aa:a3:46:4b:af:41:de:0d:9c:98:60:97:43:e8:
         13:ce:ff:b5:e6:7a:5c:a7:b4:91:5e:36:18:04:11:85:e5:b4:
         be:18:76:bd:ea:9a:37:94:9e:25:17:52:aa:0a:f5:4e:2d:b4:
         2e:a5:b5:49:10:cb:a9:5d:ea:b4:66:96:d1:22:93:8b:b0:71:
         58:45:9c:f1:6f:53:79:f1:d9:aa:39:77:2d:aa:53:0c:40:e4:
         10:7f:f6:0a:33:47:7d:58:b4:6f:06:ae:6e:5c:94:a3:67:11:
         6f:99:2e:86:48:57:a5:c1:25:67:f0:cc:48:6b:b0:1b:01:4a:
         85:32:86:08:93:5a:40:a3:81:33:25:ed:1e:96:37:64:de:5b:
         d2:0e:4b:90:c2:65:c8:51:24:4a:9d:4f:7e:b5:de:97:f8:9f:
         1c:00:6a:bb:66:33:de:7a:38:8a:0b:a7:72:60:f4:61:ee:bd:
         55:62:f8:53:dc:67:6b:9c
-----BEGIN CERTIFICATE-----
MIIFIDCCAwigAwIBAgIQSMNk6IRoO9D2fiVYBAE/5DANBgkqhkiG9w0BAQsFADAq
MREwDwYDVQQKEwhTaGlweWFyZDEVMBMGA1UEAwwMY2RfY29uc3VsX2NhMB4XDTIy
MDYyOTA2NDQ0M1oXDTIzMDMyMTA2NDQ0M1owKjERMA8GA1UEChMIU2hpcHlhcmQx
FTATBgNVBAMMDGNkX2NvbnN1bF9jYTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCC
AgoCggIBAMpTuSEXqSm+Q8FqiK69RJaM1KS1FtuUM5wLoDAzs98h506MV2GQ6O8n
8AR7tH+e6S5h0h0p4Kgz/Sqh96HlC7yVp712tdq4qSZfA3jnkwAn1BYgBjQmlx8h
QQjESx8lAxi5ilcC7llE4P6360e+ZL7ktloh0O4Nrmg3sWisGAuzseheKxrbuweg
YxH98m17NCO4X+P3elZJnA0uviyf8A3gPkXa9P3/ZKIyudemFN9NBP1Hs1cNPyxb
1lQr4E/OpdNAvvU0Tnwb6V6vjjN0ZCw8nR0UksDJJdAVyZtBhE5+0r2RaaxiDNcH
5pDBsHD+AG8+izkHiElKyPcTY5QZRAkr0Z8yONxuJcT1wc6VVuo71zO+Q16Odsbj
xlfKkob1cSTVq5GmYMXhYyMNljjZxp+YubEjYkyDq//VjSkKnkO7ial47Xcp3l9b
1M0UjCeKUiQoIrupa8d9qUhY4annjaKxdhfMpzUEVvjlSkG+WjHVN0xhjteLsaj8
nWlrD4U2JxswwbtivyvMVSbN1NkiY69vp4v0f1EgvwlhEPCWz8hZTSdX9GQf3iE3
9J7qlZgfj9Dw+oM8UvTypaRP+TIAkQJWJgv+Llvx6vE225j2kErE1O+M95QZfXSg
Y7ROxy3yUJNZbTlYSTAThnB7Oh73tKm+qoKUinSV/Vs0Oi8kL9QZAgMBAAGjQjBA
MA4GA1UdDwEB/wQEAwIChDAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBRmCwDz
W+Fpthyju2gOLGm4KPPnVTANBgkqhkiG9w0BAQsFAAOCAgEACgOFW/fMEOkzRoaF
pq6+FGb7YkS6eTiIQbEFzUXAvOWWaqUZxmzaVEeMOLp4ngPNDv78SMKurC9g90F8
r0AQFMr8WFAWCf50EcMmQkwFTxIfoj2KBhjiozI0lhh/ryMVPN/djFDtCeMOil/N
d6V+v8Ui31u6Gm61z1PnCD3THH9OgSlXMiSPSuEgsjn08IMZUmPL6bdXP5KyhhVZ
jHG54Ep0UhIuO5NtC1nPhH3qeFXpDVN0+CrWaeo7czbMEjUDQuGyaFq01FGK/Uk3
BILWJJwK+KJ0Ak5UHYgv31kAwWDV06InmNc19O96ZQPvh8ZvqshPrDpMgK6q37FO
EsU4V/V024TYKwwqYsG2AE5rEUXQExwJx3zlf7WAZ1dersUpkWUwggand/v2vjA0
pAoezOsie0H+EzO/2tBQpUTKZi1Xc5BLFV1QQ6qjRkuvQd4NnJhgl0PoE87/teZ6
XKe0kV42GAQRheW0vhh2veqaN5SeJRdSqgr1Ti20LqW1SRDLqV3qtGaW0SKTi7Bx
WEWc8W9TefHZqjl3LapTDEDkEH/2CjNHfVi0bwaublyUo2cRb5kuhkhXpcElZ/DM
SGuwGwFKhTKGCJNaQKOBMyXtHpY3ZN5b0g5LkMJlyFEkSp1PfrXel/ifHABqu2Yz
3no4iguncmD0Ye69VWL4U9xna5w=
-----END CERTIFICATE-----
```

### Leaf Certificate

The following Leaf Certificate resource
```javascript
certificate_leaf "cd_consul_server" {
  # Ensure the CA has been created before generating the leaf
  depends_on = ["certificate_ca.cd_consul_ca"]

  ca_key = "${data("certs")}/cd_consul_ca.key"
  ca_cert = "${data("certs")}/cd_consul_ca.cert"

  ip_addresses = ["127.0.0.1"]

  dns_names = [
    "localhost",
    "server.${var.cd_consul_dc}.consul",
    "1.consul.server.container.shipyard.run",
    "2.consul.server.container.shipyard.run",
    "3.consul.server.container.shipyard.run"
  ]

  output = data("certs")
}
```

Would create the following x509 certificate

```shell
Cerificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            a5:c9:71:ec:77:80:84:6b:eb:c0:16:5d:ac:cd:c0:9f
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: O = Shipyard, CN = cd_consul_ca
        Validity
            Not Before: Jun 29 06:45:00 2022 GMT
            Not After : Mar 21 06:45:00 2023 GMT
        Subject: O = Shipyard, CN = cd_consul_server
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                RSA Public-Key: (4096 bit)
                Modulus:
                    00:9e:55:a2:75:34:41:9c:b4:91:f6:4d:a5:be:fd:
                    69:b8:d4:b1:28:49:8d:2c:62:2e:40:b8:78:e7:f0:
                    4e:01:21:09:20:86:22:e3:85:f7:33:35:a5:4e:5c:
                    7a:52:fd:bd:de:3c:df:6f:fc:f1:44:6d:57:69:32:
                    30:ae:88:43:d6:dc:46:56:18:bb:62:7a:5e:ad:56:
                    76:15:03:aa:6d:55:90:7b:a3:c8:ad:62:10:77:a2:
                    a8:8b:03:94:7a:2c:a9:85:ae:6c:fc:0a:d8:5b:3d:
                    e2:8c:f3:35:37:a3:8d:6f:ec:c5:3b:69:2f:d8:67:
                    46:2d:2e:07:5c:6d:2a:e8:21:70:b0:52:1a:c4:97:
                    a8:67:cf:23:00:b5:9b:2b:cb:d1:61:cf:29:7d:4d:
                    79:39:b2:da:92:89:57:87:06:d4:c4:46:bb:00:fb:
                    7e:83:23:a4:63:f9:52:31:e0:a8:b8:15:9b:e2:28:
                    0a:96:ac:b7:50:74:86:80:b0:d1:69:a8:f7:a2:a2:
                    59:9a:9b:b8:34:47:0d:c2:cd:ed:86:29:5c:31:01:
                    6c:a7:bb:23:30:65:a3:5f:fc:0b:8f:52:fe:62:d8:
                    98:e9:d9:ea:18:4a:c6:a2:51:3a:ac:cf:8b:0c:8d:
                    22:0b:ab:f8:14:df:43:fe:d8:55:01:9d:eb:2e:c3:
                    00:e6:21:71:6e:a9:90:82:37:3d:4e:9d:32:52:4d:
                    02:af:ee:92:2e:4c:df:0f:44:e7:59:c3:72:7d:7d:
                    e0:7c:8e:db:87:a2:1d:af:13:02:b5:52:3a:56:35:
                    86:dc:cf:c7:d1:cd:0c:4d:26:57:c6:31:ac:24:59:
                    11:60:7a:9d:97:fc:87:ce:40:33:50:4f:b4:29:1b:
                    9e:d6:29:4d:46:21:45:70:77:cc:91:2d:c6:3e:fe:
                    16:52:54:66:a0:99:c3:33:d7:bd:aa:79:0b:c5:9d:
                    d7:e3:21:1a:05:43:a6:56:70:d7:46:86:fb:60:79:
                    44:6e:f3:82:50:2a:aa:e5:8a:f2:5a:de:c4:25:7b:
                    9b:e0:8a:62:ae:15:50:f3:c4:8c:73:a7:c5:4c:06:
                    39:24:25:15:72:cb:04:ca:b4:b9:b7:b8:2c:27:79:
                    43:0a:65:7c:1c:4f:3e:64:c2:62:76:73:76:72:24:
                    1c:85:f9:99:a0:af:ab:7d:4e:b3:29:97:10:38:42:
                    ed:a0:b6:91:66:c2:74:8a:5d:80:5e:5e:4a:55:a1:
                    bc:06:0e:41:d2:42:af:8e:fb:60:e3:5d:18:1e:79:
                    72:7a:50:24:4d:32:92:31:bf:40:0d:1c:37:5a:02:
                    db:e2:99:bd:61:53:89:52:e9:30:3e:7d:c9:34:6d:
                    6b:24:65
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature
            X509v3 Extended Key Usage:
                TLS Web Server Authentication, TLS Web Client Authentication
            X509v3 Basic Constraints: critical
                CA:FALSE
            X509v3 Authority Key Identifier:
                keyid:66:0B:00:F3:5B:E1:69:B6:1C:A3:BB:68:0E:2C:69:B8:28:F3:E7:55

            X509v3 Subject Alternative Name:
                DNS:localhost, DNS:server.dc1.consul, DNS:1.consul.server.container.shipyard.run, DNS:2.consul.server.container.shipyard.run, DNS:3.consul.server.container.shipyard.run, IP Address:127.0.0.1
    Signature Algorithm: sha256WithRSAEncryption
         3a:07:47:20:08:2f:37:e0:40:91:85:bc:c9:1a:e2:24:e5:04:
         1b:3b:1a:b0:45:b1:fe:38:68:3a:cc:83:c5:0e:0b:88:57:31:
         f5:25:73:f3:df:77:a8:f3:bd:49:70:dc:61:c8:17:6f:bf:29:
         39:8d:cc:a8:8f:24:64:59:e6:cc:28:4c:6a:b1:c9:63:f3:b7:
         47:09:d5:39:b7:4f:83:1a:30:00:1e:6b:ac:c1:35:78:50:6e:
         72:20:d8:a5:2e:bd:63:37:a0:2d:ea:e0:98:f5:61:59:c9:d8:
         e5:22:3e:d4:e0:72:96:86:ba:4d:8b:50:6e:10:9d:58:eb:91:
         0a:be:35:bd:73:4c:85:06:98:13:65:33:5f:b6:7c:0d:28:1f:
         60:68:82:2f:53:e9:d6:ca:a6:4c:f7:08:43:3e:d5:b5:3d:f1:
         e3:a4:ec:0e:00:d3:b1:c1:c3:f2:81:9f:cc:fa:cb:fe:92:36:
         7b:f5:48:60:58:39:da:b8:ae:5a:1e:1a:8c:35:06:e3:2c:90:
         e4:f4:65:3b:8c:cd:37:b9:e9:a4:94:30:b5:e3:3a:f3:c2:db:
         c6:11:dc:eb:45:f9:41:4f:d5:3b:4f:9b:cb:a1:10:9e:cf:69:
         1e:6b:03:a6:00:3d:6c:42:b1:a7:f2:4a:4d:c4:5c:ab:ed:1f:
         f0:ab:63:35:94:44:51:07:dd:a3:b3:58:42:92:99:87:96:25:
         11:4f:e6:72:44:22:72:f3:28:bc:f9:d4:31:30:8a:40:24:f5:
         39:35:cf:b3:a1:db:78:41:cc:be:4f:d4:15:2f:fd:a1:ec:a7:
         ef:db:07:ae:ce:13:81:3b:07:44:72:1f:26:c9:20:3f:a3:a2:
         4f:35:3e:a9:87:31:21:84:ae:04:4c:f1:a0:f3:24:95:8c:77:
         4d:85:da:9e:6d:94:73:20:2d:3c:be:13:e0:b2:49:26:25:f4:
         0e:97:0e:9f:3f:1c:a9:2b:2e:61:27:3f:08:cd:f9:bd:57:59:
         3b:0a:95:f4:f7:1e:1e:b8:5f:64:af:25:dc:d9:7a:01:45:91:
         78:59:c4:cb:01:b7:32:e5:1d:a3:8a:48:8a:ce:dc:f6:37:3c:
         a6:99:14:80:6f:17:79:55:eb:bd:04:9b:84:1e:4d:7b:c6:ce:
         4c:c5:fc:94:59:0a:1b:6b:09:36:66:13:22:4f:d4:b4:fe:b3:
         b8:3e:20:eb:34:17:0c:5b:90:3e:7d:2d:7f:61:6d:6c:2e:6a:
         cf:6f:76:e4:49:23:70:77:0a:f0:a4:10:59:4b:22:4b:84:c3:
         3a:5e:a9:e2:71:f6:f1:12:75:9c:76:8c:f7:04:c9:40:ea:f6:
         9c:3a:d9:3e:73:91:74:f6
-----BEGIN CERTIFICATE-----
MIIF8TCCA9mgAwIBAgIRAKXJcex3gIRr68AWXazNwJ8wDQYJKoZIhvcNAQELBQAw
KjERMA8GA1UEChMIU2hpcHlhcmQxFTATBgNVBAMMDGNkX2NvbnN1bF9jYTAeFw0y
MjA2MjkwNjQ1MDBaFw0yMzAzMjEwNjQ1MDBaMC4xETAPBgNVBAoTCFNoaXB5YXJk
MRkwFwYDVQQDDBBjZF9jb25zdWxfc2VydmVyMIICIjANBgkqhkiG9w0BAQEFAAOC
Ag8AMIICCgKCAgEAnlWidTRBnLSR9k2lvv1puNSxKEmNLGIuQLh45/BOASEJIIYi
44X3MzWlTlx6Uv293jzfb/zxRG1XaTIwrohD1txGVhi7YnperVZ2FQOqbVWQe6PI
rWIQd6KoiwOUeiypha5s/ArYWz3ijPM1N6ONb+zFO2kv2GdGLS4HXG0q6CFwsFIa
xJeoZ88jALWbK8vRYc8pfU15ObLakolXhwbUxEa7APt+gyOkY/lSMeCouBWb4igK
lqy3UHSGgLDRaaj3oqJZmpu4NEcNws3thilcMQFsp7sjMGWjX/wLj1L+YtiY6dnq
GErGolE6rM+LDI0iC6v4FN9D/thVAZ3rLsMA5iFxbqmQgjc9Tp0yUk0Cr+6SLkzf
D0TnWcNyfX3gfI7bh6IdrxMCtVI6VjWG3M/H0c0MTSZXxjGsJFkRYHqdl/yHzkAz
UE+0KRue1ilNRiFFcHfMkS3GPv4WUlRmoJnDM9e9qnkLxZ3X4yEaBUOmVnDXRob7
YHlEbvOCUCqq5YryWt7EJXub4IpirhVQ88SMc6fFTAY5JCUVcssEyrS5t7gsJ3lD
CmV8HE8+ZMJidnN2ciQchfmZoK+rfU6zKZcQOELtoLaRZsJ0il2AXl5KVaG8Bg5B
0kKvjvtg410YHnlyelAkTTKSMb9ADRw3WgLb4pm9YVOJUukwPn3JNG1rJGUCAwEA
AaOCAQwwggEIMA4GA1UdDwEB/wQEAwIHgDAdBgNVHSUEFjAUBggrBgEFBQcDAQYI
KwYBBQUHAwIwDAYDVR0TAQH/BAIwADAfBgNVHSMEGDAWgBRmCwDzW+Fpthyju2gO
LGm4KPPnVTCBpwYDVR0RBIGfMIGcgglsb2NhbGhvc3SCEXNlcnZlci5kYzEuY29u
c3VsgiYxLmNvbnN1bC5zZXJ2ZXIuY29udGFpbmVyLnNoaXB5YXJkLnJ1boImMi5j
b25zdWwuc2VydmVyLmNvbnRhaW5lci5zaGlweWFyZC5ydW6CJjMuY29uc3VsLnNl
cnZlci5jb250YWluZXIuc2hpcHlhcmQucnVuhwR/AAABMA0GCSqGSIb3DQEBCwUA
A4ICAQA6B0cgCC834ECRhbzJGuIk5QQbOxqwRbH+OGg6zIPFDguIVzH1JXPz33eo
871JcNxhyBdvvyk5jcyojyRkWebMKExqsclj87dHCdU5t0+DGjAAHmuswTV4UG5y
INilLr1jN6At6uCY9WFZydjlIj7U4HKWhrpNi1BuEJ1Y65EKvjW9c0yFBpgTZTNf
tnwNKB9gaIIvU+nWyqZM9whDPtW1PfHjpOwOANOxwcPygZ/M+sv+kjZ79UhgWDna
uK5aHhqMNQbjLJDk9GU7jM03uemklDC14zrzwtvGEdzrRflBT9U7T5vLoRCez2ke
awOmAD1sQrGn8kpNxFyr7R/wq2M1lERRB92js1hCkpmHliURT+ZyRCJy8yi8+dQx
MIpAJPU5Nc+zodt4Qcy+T9QVL/2h7Kfv2weuzhOBOwdEch8mySA/o6JPNT6phzEh
hK4ETPGg8ySVjHdNhdqebZRzIC08vhPgskkmJfQOlw6fPxypKy5hJz8Izfm9V1k7
CpX09x4euF9kryXc2XoBRZF4WcTLAbcy5R2jikiKztz2NzymmRSAbxd5Veu9BJuE
Hk17xs5MxfyUWQobawk2ZhMiT9S0/rO4PiDrNBcMW5A+fS1/YW1sLmrPb3bkSSNw
dwrwpBBZSyJLhMM6XqnicfbxEnWcdoz3BMlA6vacOtk+c5F09g==
-----END CERTIFICATE-----
```
