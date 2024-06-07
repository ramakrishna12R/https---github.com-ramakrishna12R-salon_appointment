#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

CREATE_APPOINTMENT() {

  # NAME=$1
  CUSTOMER_ID=$1
  SERVICE_ID=$2
  # SERVICE_NAME=$4

  NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID")


  #Ask appointment time
  # echo -e "\nWhat time would you like your $SERVICE_NAME, $NAME?"
  # read SERVICE_TIME

  #create_appointment
  # INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $3, '$SERVICE_TIME')")

  # echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $NAME."



}

MAKE_APPOINTMENT() {
  SERVICE_ID=$1
  SERVICE_NAME=$2

  #enter phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_ID ]]
  then
    #if number not present
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    #insert new customer into customers table
    INSERT_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    # #Ask appointment time
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME

    #create_appointment
    INSERT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME,$CUSTOMER_NAME."
    fi

}

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
  READ_SERVICES=$($PSQL "SELECT * FROM services ORDER BY service_id")

  echo "$READ_SERVICES" | while read SER BAR SNAME
  do
    echo -e "$SER) $SNAME"
  done

  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  # if service not present
  if [[ -z $SERVICE_NAME ]]
  then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # if service present
    MAKE_APPOINTMENT $SERVICE_ID_SELECTED $SERVICE_NAME
  fi
  
}

MAIN_MENU