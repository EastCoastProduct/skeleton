#!/bin/bash

if [ ! -d 'node_modules' ]; then
  npm install
fi

echo 'Generate the documentation:'
echo '  1 - Generate all routes'
echo '  2 - Do not generate superadmin routes'

if [[ $# == 0 ]]; then
  read documentationType
fi

echo 'Generating documentation...'

cat api.raml > temp.raml

if [[ $1 -eq 1 || documentationType -eq 1 ]]; then
  echo '/superAdmin: !include routes/superAdmin/base.raml' >> temp.raml
fi

node_modules/raml2html/bin/raml2html temp.raml > api-docs.html
rm temp.raml
echo 'Done!'
