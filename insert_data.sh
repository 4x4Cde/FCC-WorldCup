#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")   # Clear values in table.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then

  # get winner id
  WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")

  # get opponent id
  OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

  # # winner id and opp id not found
  #   if [[ -z $WINNER_ID ]]
  #   then
  #     # Insert
  #     INSERT_WNAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  #     INSERT_ONAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

  #     #update the winner id and opponent id
  #     WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
  #     OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

  #   elif [[ -z $OPPONENT_ID ]]
  #   then
  #     # Insert O
  #     INSERT_ONAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

  #     #update the winner id and opponent id
  #     WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
  #     OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
  #   fi
  

    if [[ -z $WINNER_ID ]]
    then
      # Insert
      INSERT_WNAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      # INSERT_ONAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #update the winner id and opponent id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

    fi

    if [[ -z $OPPONENT_ID ]]
    then
      # Insert O
      INSERT_ONAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

      #update the winner id and opponent id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")
    fi

    
    # Insert remaining game data
    INSERT_GAME_VALUE=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS)")

    # if [[ $WINNER_ID && $OPPONENT_ID && $INSERT_GAME_VALUE == "INSERT 0 1" ]]
    # then
    #   echo "Inserted the following team name, $WINNER"
    #   echo "Inserted the following team name, $OPPONENT"
    #   echo -e "Inserted the following, $YEAR, $ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS\n"
    # fi
  fi
done
