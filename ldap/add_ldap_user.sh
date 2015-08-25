#!/bin/bash

last_uid=$(cat last_uid 2>/dev/null)
gid=$(cat gid 2>/dev/null)

if [ -z $last_uid ]; then
  echo "Uid file not found" 1>&2
  exit 1
fi

if [ -z $gid ]; then
  echo "Gid file not found" 1>&2
  exit 1
fi

if [ $# -lt 4 ]; then
  echo "Usage : $0 first_name last_name email promo [login]" 1>&2
  exit 1
fi

if [ ! -z $LDAP_PASSWORD ]; then
  if ! [ -z $DEBUG ]; then
    echo "Authentication: Using environment's LDAP password"
  fi
  auth="-w "$LDAP_PASSWORD
else
  if ! [ -z $DEBUG ]; then
    echo "Authentication: Asking user"
  fi
  auth="-W"
fi

if [ ! -z $LDAP_GROUP ]; then
  ou=$LDAP_GROUP
else
  ou="students"
fi

first_name=$1
last_name=$2
email=$3
password=$(openssl rand -base64 8 | rev | cut -c 2-)
promo=$4
login=$last_name$promo
uid=$((last_uid+1))

if [ ! -z $6 ]; then
  login=$6
fi

login=$(echo $login | tr '[:upper:]' '[:lower:]')

mkdir -p users/$ou
filepath=users/$ou/$login.ldiff

if ! [ -z $DEBUG ]; then 
  echo "Creating user: "
  echo " - First name : "$first_name
  echo " - Last name  : "$last_name
  echo " - Email      : "$email
  echo " - Login      : "$login
  echo " - Password   : "$password
  echo " - Promotion  : "$promo
  echo " - FilePath   : "$filepath
  echo " - GID        : "$gid
  echo " - UID        : "$uid
  echo " - OU         : "$ou
fi

if [ -e $filepath ]; then
  echo "The user "$login" is already present in the ldap registry. Please set a custom login with: " 1>&2
  echo $0 $first_name $last_name $email $promo $password "my_custom_login" 1>&2
  exit 1
else 
  cat << EOT >> $filepath
dn: uid=$login, ou=$ou, dc=ares, dc=ensiie
objectClass: top
objectClass: posixAccount
objectClass: person
objectClass: organizationalPerson
objectClass: inetOrgPerson
uid:$login
cn:$last_name $first_name
sn:$last_name
uidNumber: $uid
gidNumber: $gid
givenName: $first_name
homeDirectory: /home/$login
userPassword: $password
mail: $email
roomNumber: $promo
l: France
ou: students
EOT
  echo "$uid" > last_uid
  ldapadd -D "cn=admin, dc=ares, dc=ensiie" -H "ldap://10.0.0.2" $auth -f $filepath
  if [ $? -ne 0 ]; then
    rm $filepath
    echo "Error while adding $login." 1>&2
    exit 1
  else
    ./sendmail.sh "$email" "$first_name" "$last_name" "$password" "$login"
  fi
fi
