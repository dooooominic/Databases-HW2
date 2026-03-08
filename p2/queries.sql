--HW2 Problem 2 

--Part c View:
CREATE VIEW FlightOccupancy AS
    SELECT F.flight_number, F.departure_date, 
        CAST ((F.departure_date + FS.departure_time + FS.duration) AS DATE) AS arrival_date,
        FS.origin_code, FS.dest_code, A.capacity, COUNT(B.pid) AS total_passengers

    FROM Flight F JOIN FlightService FS 
    ON F.flight_number = FS.flight_number
    JOIN Aircraft A 
    ON F.plane_type = A.plane_type
    LEFT JOIN Booking B --keeps flights with no bookings!
    ON F.flight_number = B.flight_number
    AND F.departure_date = B.departure_date
    GROUP BY F.flight_number, F.departure_date, 
        CAST ((F.departure_date + FS.departure_time + FS.duration) AS DATE),
        FS.origin_code, FS.dest_code, A.capacity;


--Part c queries 

--a
SELECT FO.flight_number, FO.departure_date, FO.total_passengers
FROM FlightOccupancy FO 
WHERE FO.total_passengers = (
    SELECT MAX(total_passengers) FROM FlightOccupancy
    );

--b
SELECT FO.dest_code, SUM(FO.total_passengers) AS total_number
FROM FlightOccupancy FO
WHERE FO.arrival_date = '2025-12-31'
GROUP BY FO.dest_code;

--c
SELECT FO.flight_number
FROM FlightOccupancy FO
WHERE FO.total_passengers >0.9 * FO.capacity;


--part d view:
CREATE VIEW AirportWithoutCountry AS
    SELECT A.airport_code, A.name, A.city
    FROM Airport A;

--part d queries:

--a
/*This would fail. Because country has a not null contraint. So we can't insert
a new airport record without entering anything for country */

--b 
DELETE FROM AirportWithoutCountry
WHERE city = 'Chicago';

--c
/*Once again, this doens't work because we can't filter by country in
this view that we wrote. So we can't delete by country name */

--d
SELECT city, COUNT(DISTINCT airport_code)
FROM AirportWithoutCountry
GROUP BY city;
