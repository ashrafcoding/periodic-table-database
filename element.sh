#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"
if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument." 
    exit
elif [[ $1 =~ ^[0-9]+$ ]]
  then
    SELECTED_ELEMENT=$($PSQL "select * from elements where atomic_number = $1 ;")
elif [[ ! $1 =~ ^[0-9]+$ ]]
  then
    SELECTED_ELEMENT=$($PSQL "select * from elements where symbol = '$1' or name = '$1';")
fi
echo "$SELECTED_ELEMENT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
do
if [[ $SELECTED_ELEMENT ]]
  then
    ELEMENT_PROPERTIES=$($PSQL "select * from properties inner join types using(type_id) where atomic_number = $ATOMIC_NUMBER;")
    echo "$ELEMENT_PROPERTIES" | while read ID BAR ATOMIC_NUMBER BAR  ATOMIC_MASS BAR MELTING BAR BOILING BAR TYPE
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
elif [[ ! $SELECTED_ELEMENT ]]
  then
    echo "I could not find that element in the database." 
    exit 
fi 
done
