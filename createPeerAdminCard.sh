Usage() {

echo ""
echo "Usage: ./createPeerAdminCard.sh [-h host] [-n]"
echo ""
echo "Options:"
echo -e "\t-h or --host:\t\t(Optional) name of the host to specify in the connection profile"
echo -e "\t-n or --noimport:\t(Optional) don't import into card store"
echo ""
echo "Example: ./createPeerAdminCard.sh"
echo ""
exit 1
}
Parse_Arguments() {
while [ $# -gt 0 ]; do
case $1 in
--help)
HELPINFO=true
;;
--host-h)
shift
HOST="$1"
;;
--noimport-n)
NOIMPORT=true
;;
esac
shift
done
}
HOST=localhost
Parse_Arguments $@

if [ "${HELPINFO}" == "true" ];then
Usage
fi

# Grab the current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



if [ -z "${HL_COMPOSER_CLI}" ]; then
HL_COMPOSER_CLI=$(which composer)
fi
echo
# check that the composer command exists at a version >v0.16
COMPOSER_VERSION=$("${HL_COMPOSER_CLI}" --version 2>/dev/null)
COMPOSER_RC=$?



echo "qwd"

cat << EOF > DevServer_connection.json
{
    "name": "hlfv1",
    "x-type": "hlfv1",
    "version": "1.0.0",
    "client": {
        "organization": "Org1",
        "connection": {
            "timeout": {
                "peer": {
                    "endorser": "300",
                    "eventHub": "300",
                    "eventReg": "300"
                },
                "orderer": "300"
            }
        }
    },
	"channels": {
        "mychannel": {
            "orderers": [
                "orderer.example.com"
            ],
            "peers": {
                "peer0.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                },
                "peer1.org1.example.com": {
                    "endorsingPeer": true,
                    "chaincodeQuery": true,
                    "eventSource": true
                }
            }
        }
    },
    "organizations": {
        "Org1": {
            "mspid": "Org1MSP",
            "peers": [
                "peer0.org1.example.com",
                "peer1.org1.example.com"
            ],
            "certificateAuthorities": [
                "ca.example.com"
            ]
        }
    },
    "orderers": {
        "orderer.example.com": {
            "url": "grpc://120.108.204.39:7050",
            "grpcOptions": {
                "ssl-target-name-override": "orderer.example.com"
            },
            "tlsCACerts": {
                "pem": "-----BEGIN CERTIFICATE-----\nMIICRDCCAeqgAwIBAgIRAKVqvACJqz/vNfv3aT4Fkv0wCgYIKoZIzj0EAwIwbDEL\nMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNhbiBG\ncmFuY2lzY28xFDASBgNVBAoTC2V4YW1wbGUuY29tMRowGAYDVQQDExF0bHNjYS5l\neGFtcGxlLmNvbTAeFw0xOTA3MDUwODQzMDBaFw0yOTA3MDIwODQzMDBaMGwxCzAJ\nBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQHEw1TYW4gRnJh\nbmNpc2NvMRQwEgYDVQQKEwtleGFtcGxlLmNvbTEaMBgGA1UEAxMRdGxzY2EuZXhh\nbXBsZS5jb20wWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASWmGbcc/1js2sucy32\nF4/nVvtk53/LFL3U4g/gnYl8vokXBc0BJiRlTYynqdptiphVd+XG2rph/XCFYjvE\ny4g6o20wazAOBgNVHQ8BAf8EBAMCAaYwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsG\nAQUFBwMBMA8GA1UdEwEB/wQFMAMBAf8wKQYDVR0OBCIEILqSLAiVY91jO7Y2zkRe\nWr3SqGYqKjQk3GlB8jrm+GjOMAoGCCqGSM49BAMCA0gAMEUCIQCkEGllr4aoFGf7\npheUD/5FAcmP7mOkjMTtWc2KGOpYQQIgTHornLv9232oYJFR3inT44PnnjMTdcNB\ntudOwVqIqYI=\n-----END CERTIFICATE-----\n"
            }
        }
    },
    "peers": {
        "peer0.org1.example.com": {
            "url": "grpc://120.108.204.39:7051",
            "eventUrl": "grpc://120.108.204.39:7053",
            "grpcOptions": {
                "ssl-target-name-override": "peer0.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "-----BEGIN CERTIFICATE-----\nMIICVjCCAf2gAwIBAgIQSjH7vLGHcDL+kY4Hw8awFDAKBggqhkjOPQQDAjB2MQsw\nCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy\nYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0GA1UEAxMWdGxz\nY2Eub3JnMS5leGFtcGxlLmNvbTAeFw0xOTA3MDUwODQzMDBaFw0yOTA3MDIwODQz\nMDBaMHYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH\nEw1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBvcmcxLmV4YW1wbGUuY29tMR8wHQYD\nVQQDExZ0bHNjYS5vcmcxLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0D\nAQcDQgAEKPz/OfZhdwX8E7yAfJ86TxIvfpIsxEa/L1BwZK0YdGhqEgjMS5QS/5tP\nVmXU6duOn/aZq/oiw/SJtD1GltJdhqNtMGswDgYDVR0PAQH/BAQDAgGmMB0GA1Ud\nJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MCkGA1Ud\nDgQiBCCUDgkRvWzhDqP4K7pGX9ZqxQQWOwIhGU1kdR0YLVTOfDAKBggqhkjOPQQD\nAgNHADBEAiBMvsoC+1XgrjpS31OTsSTQcsB7pD9deIBAtgp8Vukx7gIgFMjAwgba\nyBXQfQ+x6i5NaXYvpqcGnzszjMIJ01Dub70=\n-----END CERTIFICATE-----\n"
            }
        },
        "peer1.org1.example.com": {
            "url": "grpc://120.108.204.47:8051",
            "eventUrl": "grpc://120.108.204.47:8053",
            "grpcOptions": {
                "ssl-target-name-override": "peer1.org1.example.com"
            },
            "tlsCACerts": {
                "pem": "-----BEGIN CERTIFICATE-----\nMIICVjCCAf2gAwIBAgIQSjH7vLGHcDL+kY4Hw8awFDAKBggqhkjOPQQDAjB2MQsw\nCQYDVQQGEwJVUzETMBEGA1UECBMKQ2FsaWZvcm5pYTEWMBQGA1UEBxMNU2FuIEZy\nYW5jaXNjbzEZMBcGA1UEChMQb3JnMS5leGFtcGxlLmNvbTEfMB0GA1UEAxMWdGxz\nY2Eub3JnMS5leGFtcGxlLmNvbTAeFw0xOTA3MDUwODQzMDBaFw0yOTA3MDIwODQz\nMDBaMHYxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMRYwFAYDVQQH\nEw1TYW4gRnJhbmNpc2NvMRkwFwYDVQQKExBvcmcxLmV4YW1wbGUuY29tMR8wHQYD\nVQQDExZ0bHNjYS5vcmcxLmV4YW1wbGUuY29tMFkwEwYHKoZIzj0CAQYIKoZIzj0D\nAQcDQgAEKPz/OfZhdwX8E7yAfJ86TxIvfpIsxEa/L1BwZK0YdGhqEgjMS5QS/5tP\nVmXU6duOn/aZq/oiw/SJtD1GltJdhqNtMGswDgYDVR0PAQH/BAQDAgGmMB0GA1Ud\nJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDATAPBgNVHRMBAf8EBTADAQH/MCkGA1Ud\nDgQiBCCUDgkRvWzhDqP4K7pGX9ZqxQQWOwIhGU1kdR0YLVTOfDAKBggqhkjOPQQD\nAgNHADBEAiBMvsoC+1XgrjpS31OTsSTQcsB7pD9deIBAtgp8Vukx7gIgFMjAwgba\nyBXQfQ+x6i5NaXYvpqcGnzszjMIJ01Dub70=\n-----END CERTIFICATE-----\n"
            }
        }
    },
    "certificateAuthorities": {
        "ca.example.com": {
            "url": "http://120.108.204.39:7054",
            "caName": "ca.example.com",
            "httpOptions": {
                "verify": false
            }
        }
    }
}
EOF

PRIVATE_KEY="${DIR}"/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore/69b84927e241b6902df26f48d43d9346a377973f9ec5c4e72fd35975f0187202_sk
CERT="${DIR}"/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts/Admin@org1.example.com-cert.pem

if [ "${NOIMPORT}" != "true" ]; then
CARDOUTPUT=/tmp/PeerAdmin@hlfv1.card
else
CARDOUTPUT=PeerAdmin@hlfv1.card
fi
"${HL_COMPOSER_CLI}" card create -p DevServer_connection.json -u PeerAdmin -c "${CERT}" -k "${PRIVATE_KEY}" -r PeerAdmin -r ChannelAdmin --file $CARDOUTPUT
if [ "${NOIMPORT}" != "true" ]; then
if "${HL_COMPOSER_CLI}" card list -c PeerAdmin@hlfv1 > /dev/null; then
"${HL_COMPOSER_CLI}" card delete -c PeerAdmin@hlfv1
fi
"${HL_COMPOSER_CLI}" card import --file /tmp/PeerAdmin@hlfv1.card
"${HL_COMPOSER_CLI}" card list
echo "Hyperledger Composer PeerAdmin card has been imported, host of fabric specified as '${HOST}'"
rm /tmp/PeerAdmin@hlfv1.card
else
echo "Hyperledger Composer PeerAdmin card has been created, host of fabric specified as '${HOST}'"
fi

