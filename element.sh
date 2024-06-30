#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]] #test if there is an input
then
  echo Please provide an element as an argument.
else
  #test input
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    SEARCH_ELEMENT_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
  fi
  SEARCH_ELEMENT_SYMBOL=$($PSQL "SELECT * FROM elements WHERE symbol = '$1'")
  SEARCH_ELEMENT_NAME=$($PSQL "SELECT * FROM elements WHERE name = '$1'")
  if [[ -n $SEARCH_ELEMENT_NUMBER ]]
  then
    ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
  elif [[ -n $SEARCH_ELEMENT_SYMBOL ]]
  then
    ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
  elif [[ -n $SEARCH_ELEMENT_NAME ]]
  then
    ELEMENT_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
  else
    echo I could not find that element in the database.
  fi

  #check if input was valid
  if [[ -n $ELEMENT_NUMBER ]]
  then
    #get all needed values/variables
    ELEMENT_NUMBER=$(echo $ELEMENT_NUMBER | sed 's/ *//g')
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_NAME=$(echo $ELEMENT_NAME | sed 's/ *//g')
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ELEMENT_NUMBER")
    ELEMENT_SYMBOL=$(echo $ELEMENT_SYMBOL | sed 's/ *//g')
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
    TYPE=$(echo $TYPE | sed 's/ *//g')
    MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    MASS=$(echo $MASS | sed 's/ *//g')
    MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    MELT=$(echo $MELT | sed 's/ *//g')
    BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ELEMENT_NUMBER")
    BOIL=$(echo $BOIL | sed 's/ *//g')
    
    #display message
    echo "The element with atomic number $ELEMENT_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT_NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi
