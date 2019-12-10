#!/bin/bash

array=();

getCurlArray () {
   array=();
   for i in $(seq 1 $1)
   do
      array+=(--next --output /dev/null --silent --request GET $4 );
   done
   seq $2 | parallel -j$3 curl ${array[@]} &
   #echo ${array[@]};
   #return "${array[@]}";
}

#array=();
#for i in {1..2}; do
#  array+=(--next --output /dev/null --silent --request GET $2/pega/member/$4 ) ;
#done;
# echo ${array[@]};
# seq $1 | parallel -j$8 curl ${array[@]} &
# arr=$( getCurlArray $1 $2 localhost/pega/member );
echo $( getCurlArray $1 $2 $3 localhost/pega/member )
