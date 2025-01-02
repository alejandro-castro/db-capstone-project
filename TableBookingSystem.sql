

USE little_lemon_db;
-- -------- Part 1
-- Task 1
INSERT INTO Bookings(BookingId, Date, TableNo, CustomerId) 
VALUES 
(1, "2022-10-10", 5, 1), 
(2, "2022-11-12", 3, 3),
(3, "2022-10-11", 2, 2),
(4, "2022-10-13", 2, 1)
;

-- Task 2
CREATE PROCEDURE CheckBooking(IN BookingDate DATE, IN TableNumber INT)
SELECT CONCAT("Table ", TableNo, " is already booked") AS "Booking Status" 
FROM Bookings
WHERE BookingDate = Bookings.Date AND TableNo = TableNumber;

CALL CheckBooking("2022-11-12", 3);

-- Task 3
DELIMITER $$
CREATE PROCEDURE AddValidBooking(IN BookingDate DATE, IN TableNumber INT, IN CurrentCustomerId INT)
BEGIN
DECLARE FoundCustomerId INT;

SELECT CustomerId FROM Bookings WHERE BookingDate=Bookings.Date AND TableNo = TableNumber LIMIT 1 INTO FoundCustomerId;
START TRANSACTION;

IF ISNULL(FoundCustomerId) THEN
	INSERT INTO Bookings(Date, TableNo, CustomerId) VALUES (BookingDate, TableNumber, CurrentCustomerId);
    SELECT CONCAT("Table ", TableNumber, "has been booked succesfully") AS "Booking Status"; 
ELSEIF (FoundCustomerId = CurrentCustomerId) THEN
    SELECT CONCAT("Table ", TableNumber, "was already booked by the same customer. No action performed.") AS "Booking Status"; 
ELSE
    SELECT CONCAT("Table ", TableNumber, "is already booked by a different customer. Booking cancelled.") AS "Booking Status"; 
END IF;
COMMIT; -- We dont need to rollback with this safe insert
END$$
DELIMITER ;


-- ------ Part 2
-- Task 1
DELIMITER $$
CREATE PROCEDURE AddBooking(IN BookingId INT, IN CustomerId INT, IN BookingDate DATE, IN TableNumber INT)
BEGIN
INSERT INTO Bookings(BookingId, Date, TableNo, CustomerId) VALUES (BookingId, BookingDate, TableNumber, CustomerId);
SELECT "New booking added" AS Confirmation;
END $$
DELIMITER ;
CALL AddBooking(9, 3, 4, "2022-12-30");

-- Task 2
DELIMITER $$
CREATE PROCEDURE UpdateBooking(IN BookingId INT, IN BookingDate DATE)
BEGIN
UPDATE Bookings SET Date=BookingDate WHERE BookingId = BookingId;
SELECT CONCAT("Booking ", BookingId, " updated") AS Confirmation;
END $$
DELIMITER ;
CALL UpdateBooking(9, "2022-12-17");

-- Task 3
DELIMITER $$
CREATE PROCEDURE CancelBooking(IN BookingId INT)
BEGIN
DELETE FROM Bookings WHERE BookingId = BookingId;
SELECT CONCAT("Booking ", BookingId, " cancelled") AS Confirmation;
END $$
DELIMITER ;
CALL CancelBooking(9);

