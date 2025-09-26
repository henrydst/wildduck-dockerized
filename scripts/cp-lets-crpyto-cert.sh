#!/bin/bash

cd config-generated
rm certs/*.*
cp certs-lets/certificate.crt certs/nurokmail.com.pem
cp certs-lets/fullchain.crt certs/fullchain.pem
cp certs-lets/chain.crt certs/chain.pem
cp certs-lets/nurokmail.com-key.pem certs/nurokmail.com-key.pem
cd ..