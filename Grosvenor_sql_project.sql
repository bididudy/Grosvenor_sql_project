/* 
Create a database of the hotel named “Grosvenor”. Given are a few hints on how tables should be created and how the values should be inserted. After the creation of the database, answer the questions given at the end about the hotel.

The Database

1. Hotel (Hotel_No, Name, Address) 
2. Room (Room_No, Hotel_No, Type, Price) 
3. Booking (Hotel_No,Guest_No, Date_From, Date_To, Room_No) 
4. Guest (Guest_No, Name, Address)

Creating the Tables(Make sure to include primary and foreign keys also keeping in mind the normalization of tables).

CREATE TABLE hotel ( hotel_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address

VARCHAR(50) NOT NULL);

CREATE TABLE room ( room_no VARCHAR(4) NOT NULL, hotel_no CHAR(4) NOT NULL, type CHAR(1)

NOT NULL, price DECIMAL(5,2) NOT NULL);

CREATE TABLE booking (hotel_no CHAR(4) NOT NULL, guest_no CHAR(4) NOT NULL, date_from

DATETIME NOT NULL, date_to DATETIME NULL, room_no CHAR(4) NOT NULL); Dates: YYYY-MM-DD;

CREATE TABLE guest ( guest_no CHAR(4) NOT NULL, name VARCHAR(20) NOT NULL, address

VARCHAR(50) NOT NULL);
------------------------
INSERT INTO hotel VALUES ('H111', 'Grosvenor Hotel‘, 'London'); 
INSERT INTO room VALUES ('1', 'H111', 'S', 72.00); 
INSERT INTO guest VALUES ('G111', 'John Smith', 'London'); 
INSERT INTO booking VALUES ('H111', 'G111', DATE'1999-01-01', DATE'1999-01-02', '1');

*/


CREATE DATABASE Grosvenor;  -- Created database Grosvenor

use Grosvenor;
/* creating table hotel with hotel no, name, address and with PK as hotel no */
CREATE TABLE hotel ( 
           hotel_no CHAR(4) NOT NULL, 
           name VARCHAR(20) NOT NULL, 
		   address VARCHAR(50) NOT NULL,
           PRIMARY KEY (hotel_no)
           );

/* creating table room with room_no, hotel no, type, price and with PK as room no */
CREATE TABLE room ( 
           room_no VARCHAR(4) NOT NULL, 
           hotel_no CHAR(4) NOT NULL, 
           type CHAR(1) NOT NULL, 
           price DECIMAL(5,2) NOT NULL,
           PRIMARY KEY (room_no)
           );
 
 /* creating table booking with guest_no, hotel no, date_from, date_to, room_no and with PK as guest_no */
CREATE TABLE booking (
           hotel_no CHAR(4) NOT NULL, 
           guest_no CHAR(4) NOT NULL, 
           date_from DATETIME NOT NULL, 
           date_to DATETIME NULL, 
           room_no CHAR(4) NOT NULL,
           PRIMARY KEY (guest_no)
           ); 

/* creating table guest with guest no, name, address and with PK as guest no */
CREATE TABLE guest ( 
           guest_no CHAR(4) NOT NULL, 
           name VARCHAR(20) NOT NULL, 
           address VARCHAR(50) NOT NULL,
           PRIMARY KEY (guest_no)
           );
           
/* inserting values into hotel table */
INSERT INTO `hotel` (`hotel_no`, `name`, `address`) 
VALUES ('H111', 'Grosvenor', 'London'),
	   ('H112', 'Marriott', 'Winsley'),
       ('H113', 'Goodwill', 'South Hampton');
       
/* inserting values into room table */
INSERT INTO `room` (`room_no`, `hotel_no`, `type`, price) 
VALUES ('1', 'H111', 'S', 72.00),
       ('2', 'H112', 'M', 75.00),
       ('3', 'H113', 'D', 82.00);

/* inserting values into booking table */
INSERT INTO `booking` (`hotel_no`, `guest_no`, date_from, date_to, room_no)
VALUES ('H111', 'G111', DATE'1999-01-01', DATE'1999-01-02', '1'),
       ('H112', 'G112', DATE'1999-06-01', DATE'1999-06-02', '2'),
       ('H113', 'G113', DATE'1999-07-01', DATE'1999-07-02', '3');
       
/* inserting values into guest table */
INSERT INTO `guest` (`guest_no`, `name`, `address`)
VALUES ('G111', 'John Smith', 'London'),
       ('G112', 'Jean Smith', 'London'),
       ('G113', 'Joana Smith', 'Winsley');
       
/* room price is increased by 1.05% in room table */
UPDATE room SET price = price*1.05;

/* created new table to store old bookings so current booking table will be available for new bookings */
CREATE TABLE booking_old ( 
             hotel_no CHAR(4) NOT NULL, 
             guest_no CHAR(4) NOT NULL, 
             date_from DATETIME NOT NULL, 
             date_to DATETIME NULL, 
             room_no VARCHAR(4) NOT NULL
             );

/* inserting values into booking_old where bookings are before 1st jan 2000 table */
INSERT INTO booking_old (SELECT * FROM booking WHERE date_to < DATE  '2000-01-01');

/* deleting values before 1st jan 2000 from booking table */
DELETE FROM booking WHERE (date_to < DATE '2000-01-01');

/* added foreign key to room table */
ALTER TABLE room
ADD FOREIGN KEY (hotel_no) references hotel (hotel_no);

/* added foreign key to booking table */
ALTER TABLE booking
ADD FOREIGN KEY (room_no) references room (room_no);

-- -------------------------------------------------------------------------------------
-- Simple Queries

-- 1. List full details of all hotels.
SELECT * -- need all columns 
FROM hotel; -- from hotel table
-- -----------------------------------------------

-- 2.List full details of all hotels in London.
SELECT * -- as we need all columns used *
FROM hotel -- all details from hotel table
WHERE address = 'London'; -- need where address column is London
-- ------------------------------------------------

-- 3. List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT name, address -- selected only name and address columns
FROM guest -- we will get all details from guest table
WHERE address='LONDON' -- we will compare adress where its london
ORDER BY name ASC; -- need names in ascending order
-- -----------------------------------------------

-- 4. List all double or family rooms with a price below £40.00 per night, in ascending order of price.
SELECT type, price -- type of room and price column selected 
FROM room -- room table will be used
WHERE price <40 -- price comparison
ORDER BY price ASC; -- price in ascendig order
-- ----------------------------------------------------------------

-- 5. List the bookings for which no date_to has been specified.
SELECT * -- selected all columns from booking table so we will get all info
FROM booking -- booking table will be used
WHERE date_to IS NULL; -- checking date_to null values
-- ------------------------------------------------------------------


-- Aggregate Functions

-- 1.  How many hotels are there?
SELECT COUNT(hotel_no) -- COUNT clasuse for counting hotel entries
FROM hotel -- from hotel table
GROUP BY hotel_no; -- GROUP BY clause for avoiding repeatations of same hotels
-- ------------------------------------------------------------------

-- 2. What is the average price of a room?
SELECT avg(price) -- avg clause to get average of price section
FROM room -- from room table
GROUP BY type; -- GROUP BY clause for avoiding repeatations of same rooms
-- -------------------------------------------------------------------

-- 3. What is the total revenue per night from all double rooms?
SELECT sum(price) -- sum clause to calculate all double room prices
FROM room -- from room table
WHERE type='D'; -- cheking the type of room is D
-- ------------------------------------------------------------------

-- 4. How many different guests have made bookings for August?
SELECT count(date_from)
FROM booking
WHERE (date_from >= DATE '2000-08-01') AND (date_from <= DATE '2000-08-31')
GROUP BY date_from;
-- -------------------------------------------------------------------------------------
-- Subqueries and Joins

-- 1.  List the price and type of all rooms at the Grosvenor Hotel.
SELECT h.name, r.type, r.price -- selected hotel name, room type and prize from hotel and room table
FROM hotel h -- selected hotel table
INNER JOIN room r -- inner join on room table
ON h.hotel_no=r.hotel_no -- common column used is hotel name
WHERE h.name='grosvenor';
-- -------------------------------------------------------------------

-- 2. List all guests currently staying at the Grosvenor Hotel.
SELECT h.name, g.name -- selected hotel name nd guest name
FROM hotel h -- selected hotel table
INNER JOIN booking b -- inner join on booking table
ON h.hotel_no=b.hotel_no -- common column hotel number for inner join 
INNER JOIN guest g -- 2nd inner join on guesttable
ON b.guest_no=g.guest_no -- guest no common table or inner join
WHERE h.name='grosvenor'; -- condition hotel name grosvenor
-- ----------------------------------------------------------
-- 3. List the details of all rooms at the Grosvenor Hotel, including the name of the guest staying in the room, if the room is occupied.
WITH temp -- created cte on hotel table
as
(
    SELECT * -- all columns selected
    FROM hotel -- selected hotel table
    WHERE name='grosvenor' -- condition hotel name grosvenor
    )
SELECT h.name hotel_name, g.name guest_name, r.type -- hotel name and guest name from hotel table and guest table
FROM temp h -- previously created cte
INNER JOIN room r -- inner join on room table
ON h.hotel_no=r.hotel_no -- common column hotel no
INNER JOIN booking b -- 2nd inner join on booking table
ON r.hotel_no=b.hotel_no -- common column hotel no
RIGHT OUTER JOIN guest g -- right out join on guest table
ON b.guest_no=g.guest_no; -- common column guest no
-- ------------------------------------------------------------------------------------------

-- 4. What is the total income from bookings for the Grosvenor Hotel today?
WITH temp
as
( /* from hotel seleted wherever hotel nme is grosvenor*/
    SELECT *
    FROM hotel
    WHERE name='grosvenor'
    )
SELECT h.name, sum(r.price) -- name of the hotel nd sum of the room price
FROM temp h
INNER JOIN room r -- inner join on cte created
ON h.hotel_no=r.hotel_no
INNER JOIN booking b -- 2nd inner inner join on booking table
ON r.hotel_no=b.hotel_no
WHERE date_from= curdate(); -- to check if it's current date used curdate function
-- --------------------------------------------------------------------------------------

-- 5. List the rooms that are currently unoccupied at the Grosvenor Hotel.

WITH temp
as
(   /* from hotel seleted wherever hotel nme is grosvenor*/
    SELECT *
    FROM hotel
    WHERE name='grosvenor'
    )
SELECT h.name, COUNT(date_from) -- to give unoccupied room count used 
FROM temp h
INNER JOIN room r -- inner join on cte created
ON h.hotel_no=r.hotel_no
INNER JOIN booking b -- 2nd inner inner join on booking table
ON r.hotel_no=b.hotel_no
WHERE date_from != curdate(); -- to check if it's not current date used curdate function
-- --------------------------------------------------------------------------------------

-- 6.What is the lost income from unoccupied rooms at the Grosvenor Hotel?
WITH temp
as
( /* from hotel seleted wherever hotel nme is grosvenor*/
    SELECT *
    FROM hotel
    WHERE name='grosvenor'
    )
SELECT h.name, sum(price) lost_money -- to calculate lost money used sum clause on price column 
FROM temp h
INNER JOIN room r -- inner join on cte created
ON h.hotel_no=r.hotel_no
INNER JOIN booking b -- 2nd inner inner join on booking table
ON r.hotel_no=b.hotel_no
WHERE date_from != curdate(); -- to check if it's not current date used curdate function
-- --------------------------------------------------------------------------------------

-- Grouping

-- 1. List the number of rooms in each hotel.
SELECT h.name, count(r.hotel_no)
FROM hotel h
INNER JOIN room r
ON h.hotel_no=r.hotel_no
GROUP BY r.hotel_no; -- groupby on hotel no column 
-- --------------------------------------------------------------------------------------

-- 2.  List the number of rooms in each hotel in London.
SELECT h.name, count(r.hotel_no)
FROM hotel h
INNER JOIN room r
ON h.hotel_no=r.hotel_no
WHERE h.address='London'
GROUP BY r.hotel_no;
-- --------------------------------------------------------------------------------------

-- 3. What is the average number of bookings for each hotel in August?

WITH temp as
(
    SELECT *
    FROM Booking
    WHERE (date_from >= DATE '2000-08-01') AND (date_from <= DATE '2000-08-31')
    
)

SELECT h.name, count(b.date_from)
FROM hotel h
INNER JOIN temp b
ON h.hotel_no=b.hotel_no
GROUP BY date_from;

-- -------------------------------------------------------------------------
-- 4. What is the most commonly booked room type for each hotel in London?
WITH temp
as
(
    SELECT *
    FROM hotel
    WHERE address='London'
    )
SELECT r.type, count(r.type)
FROM temp h
INNER JOIN room r
ON h.hotel_no=r.hotel_no
INNER JOIN booking b
ON r.hotel_no=b.hotel_no
GROUP BY r.type 
LIMIT 1;
-- -----------------------------------------------------------------------

-- 5. What is the lost income from unoccupied rooms at each hotel today?

SELECT h.name, COUNT(r.hotel_no), sum(price) lost_money
FROM hotel h
INNER JOIN room r
ON h.hotel_no=r.hotel_no
INNER JOIN booking b
ON r.hotel_no=b.hotel_no
WHERE date_from != curdate()
GROUP BY r.hotel_no
-- --------------------------------------------------------------------------








