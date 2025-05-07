#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  name=$($PSQL "select name from elements where name='$1'")
  if [[ -z $name ]]
  then
    symbol=$($PSQL "select symbol from elements where symbol='$1'")
    if [[ -z $symbol ]]
    then
      atomic_number=$($PSQL "select atomic_number from elements where atomic_number='$1'")
      if [[ -z $atomic_number ]]
      then  
        echo "I could not find that element in the database."
      fi
    else
      atomic_number=$($PSQL "select atomic_number from elements where symbol='$symbol'")
    fi
    else
      atomic_number=$($PSQL "select atomic_number from elements where name='$name'")
  fi
  if [[ ! -z $atomic_number ]]
  then
    symbol=$($PSQL "select symbol from elements where atomic_number=$atomic_number")
    name=$($PSQL "select name from elements where atomic_number=$atomic_number")
    type_id=$($PSQL "select type_id from properties where atomic_number=$atomic_number")
    type=$($PSQL "select type from types where type_id=$type_id")
    atomic_mass=$($PSQL "select atomic_mass from properties where atomic_number=$atomic_number")
    melting_point_celsius=$($PSQL "select melting_point_celsius from properties where atomic_number=$atomic_number")
    boiling_point_celsius=$($PSQL "select boiling_point_celsius from properties where atomic_number=$atomic_number")
    echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
  fi
else
  echo "Please provide an element as an argument."
fi