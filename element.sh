#!/bin/bash
# Check if an argument was provided
if [ -z "$1" ]; then
  echo -e "Please provide an element as an argument."
  exit
fi

# Define the PSQL command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if the argument is numeric
if [[ $1 =~ ^[0-9]+$ ]]
then
    # If the argument is numeric, compare it with atomic_number
    SQL="SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number=$1;"
elif [ ${#1} -le 2 ]
then
    # If the argument has 2 or fewer characters, compare it with symbol
    SQL="SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.symbol='$1';"
else
    # If the argument has more than 2 characters, compare it with name
    SQL="SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e INNER JOIN properties p ON e.atomic_number = p.atomic_number INNER JOIN types t ON p.type_id = t.type_id WHERE e.name='$1';"
fi

# Execute the SQL query
RESULT=$($PSQL "$SQL")

# Check if the query returned a result
if [ -z "$RESULT" ]
then
    echo "I could not find that element in the database."
else
    echo "$RESULT"
fi

