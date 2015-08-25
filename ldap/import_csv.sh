#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage : $0 csv_file" 1>&2
  exit 1
fi

echo -n "Enter LDAP password: "
read -s ldap_pass
echo

ldapsearch -x -H "ldap://10.0.0.2 " -D "cn=admin, dc=ares, dc=ensiie" -w $ldap_pass -s base  -b '' > /dev/null

if [ $? -ne 0 ]; then
  echo "Cannot contact ldap server. Aborting!" 1>&2
  exit 1
fi

export LDAP_PASSWORD=$ldap_pass

errored=""

while read line; do
  last_name=$(echo $line | cut -d',' -f1)
  first_name=$(echo $line | cut -d',' -f2)
  email=$(echo $line | cut -d',' -f3)
  promo=$(echo $line | cut -d',' -f4)
  ./add_ldap_user.sh $first_name $last_name $email $promo
  if [ $? -ne 0 ]; then
    errored=$errored", $last_name $first_name"
  fi
done < $1

if ! [ -z "$errored" ]; then
  echo "Cannot add the following users :"
  echo $errored
fi
