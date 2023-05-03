-- This is the first of two queries where the overall goal is to compare the amount of walking throughout the day,
-- if we combine all users and compare weekdays, saturdays, and sundays.
-- This first query actually shift the definition of a day.
-- When it comes to walking, I thought it made more sense to have days run from 4AM to 3AM, instead of midnight to 11PM.
-- If we think of people walking around between midnight and 3AM, chances are they're at the end of the day prior, not the start of the current day.


WITH time_to_int as (
SELECT
*,
EXTRACT(HOUR FROM CleanedTime) as hour ##We convert the time to an INT for easier manipulation later on
 FROM `watchful-lotus-384408.fitbit_fitness_tracker_data.hourlySteps`
)

SELECT
    Id,
    CASE ##If a time falls between midnight and 3AM, we change the day to the privous.
        WHEN hour=0 THEN DATE_ADD(CleanedDate, INTERVAL -1 DAY)
        WHEN hour=1 THEN DATE_ADD(CleanedDate, INTERVAL -1 DAY)
        WHEN hour=2 THEN DATE_ADD(CleanedDate, INTERVAL -1 DAY)
        WHEN hour=3 THEN DATE_ADD(CleanedDate, INTERVAL -1 DAY)
        ELSE CleanedDate
    END as day_4am_to3am,

    CASE ##If a time falls between midnight and 3AM, we add 24 to the time, effectively ending up with 24,25,26,27PM
        WHEN hour=0 THEN 24
        WHEN hour=1 THEN 25
        WHEN hour=2 THEN 26
        WHEN hour=3 THEN 27
        ELSE hour
    END as time_4am_to3am,
    StepTotal

FROM time_to_int

ORDER BY Id, day_4am_to3am, time_4am_to3am