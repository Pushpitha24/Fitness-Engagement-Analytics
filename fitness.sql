use fitness; -- using the fitness database 

show tables; -- shows all the tables in the  fitness data base
describe activity; -- display the structure of the activity table
select * from activity; -- displays all the details from the activity table

-- ----------------------------------- Business Case Scenarios ------------------------------------

-- 1. Average Calories Burned by Goal Type -----------------
SELECT u.Goal_Type, AVG(a.Calories_Burned) AS avg_calories FROM users u
  JOIN activity a ON u.User_ID = a.User_ID GROUP BY u.Goal_Type
  ORDER BY avg_calories DESC;
  
-- Displays features used more than 500 times, highlighting the most frequently engaged functionalities in the app.
-- Insights: Users pursuing Strength and Weight Loss goals burn slightly more calories on average, 
-- though differences across goal types are minimal.
-- --------------------------------------------------------------------------------------------------

-- 2. Workout Summary ----------------
CREATE VIEW workout_summary AS
SELECT Workout_Type, COUNT(*) AS total_sessions FROM activity GROUP BY Workout_Type;

select * from workout_summary;

-- Creates a view that shows the total number of sessions for each Workout_Type in the activity table.
-- Insights: Strength training is slightly more popular than Yoga, Mix, and Cardio, 
-- but overall session counts are very close across all workout types.
-- --------------------------------------------------------------------------------------------------

-- 3. Above-Average Activity Durations -----------------
SELECT User_ID, Duration_Minutes FROM Activity
   WHERE Duration_Minutes > (SELECT AVG(Duration_Minutes) FROM Activity);

-- Retrieves all activities longer than the average duration, highlighting exercises that exceed typical performance.
-- Insight: Most users have durations between 60–100 minutes, with several users reaching very high durations near 100 minutes.
-- --------------------------------------------------------------------------------------------------

-- 4. Morning Workouts by Users -----------------
DELIMITER //
CREATE PROCEDURE MorningWorkouts()  
BEGIN
  SELECT User_ID, Workout_Type, Duration_Minutes FROM Activity WHERE Workout_Time_of_Day = 'Morning';
END //
DELIMITER ;
call MorningWorkouts();

-- Retrieves all morning activities, showing type and duration, to analyze users exercise patterns.
-- Insights: Mix workouts are most common (3,193 sessions), while all workout types have similar average durations of about 60 minutes.
-- --------------------------------------------------------------------------------------------------

-- 5. Prevent Negative Duration Trigger -----------------
DELIMITER //
CREATE TRIGGER check_duration
BEFORE INSERT ON Activity
FOR EACH ROW
BEGIN
    IF NEW.Duration_Minutes < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Workout duration cannot be negative';
    END IF;
END //
DELIMITER ;

insert into activity values ("A028004", "U1505", "2022-12-24 00:00:00", "Mix", -10, 178, 5978, 134, "Morning", "Web");

-- This trigger prevents inserting a record into the Activity table if Duration_Minutes is negative by showing an error message.
-- --------------------------------------------------------------------------------------------------