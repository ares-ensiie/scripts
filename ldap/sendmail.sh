#!/bin/bash

if [ $# -ne 5 ]; then
  echo "Usage : $0 email first_name last_name password login" 1>&2
  exit 1
fi

to=$1
first_name=$2
last_name=$3
password=$4
login=$5
subject="Bienvenue sur le reseau ares"
from="ares@ares-ensiie.eu"

if ! [ -z $DEBUG ]; then
  echo "Mail info:"
  echo " - From:       "$from
  echo " - To:         "$to
  echo " - Subject:    "$subject
  echo " - Last name:  "$last_name
  echo " - First name: "$first_name
  echo " - Login:      "$login
  echo " - Password:   "$password
  echo "Mail :"
fi
mail=$(cat template_mail.txt | sed "s/{LAST_NAME}/$last_name/g" \
                      | sed "s/{FIRST_NAME}/$first_name/g" \
                      | sed "s/{LOGIN}/$login/g"\
                      | sed "s/{PASSWORD}/$password/g"
)
if ! [ -z $DEBUG ]; then
  echo "$mail"
fi

sendmail -f ares "$to" <<EOF
Subject:$subject
To: $to
From: $from

$mail
EOF
