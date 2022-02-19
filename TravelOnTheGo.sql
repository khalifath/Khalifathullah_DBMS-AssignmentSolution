drop database if exists TravelOnTheGo;
create database TravelOnTheGo;
use TravelOnTheGo;

drop table if exists Passenger;
create table Passenger (
	Passenger_name varchar(50), 
	Category varchar(10),
	Gender varchar(1),
	Boarding_City varchar(25),
	Destination_City varchar(25),
	Distance int,
	Bus_Type varchar(10)
);
desc Passenger;

insert into  Passenger values("Sejal","AC","F","Bengaluru","Chennai",350,"Sleeper");
insert into  Passenger values("Anmol","Non-AC","M","Mumbai","Hyderabad",700,"Sitting");
insert into  Passenger values("Pallavi","AC","F","Panaji","Bengaluru",600,"Sleeper");
insert into  Passenger values("Khusboo","AC","F","Chennai","Mumbai",1500,"Sleeper");
insert into  Passenger values("Udit","Non-AC","M","Trivandrum","panaji",1000,"Sleeper");
insert into  Passenger values("Ankur","AC","M","Nagpur","Hyderabad",500,"Sitting");
insert into  Passenger values("Hemant","Non-AC","M","panaji","Mumbai","700","Sleeper");
insert into  Passenger values("Manish","Non-AC","M","Hyderabad","Bengaluru",500,"Sitting");
insert into  Passenger values("Piyush","AC","M","Pune","Nagpur",700,"Sitting");

drop table if exists Price;

create table Price (
 Bus_Type varchar(10),
 Distance int,
 Price int
 );
 
 desc Price;
 
insert into Price values("Sleeper",350,770);
insert into Price values("Sleeper",500,1100);
insert into Price values("Sleeper",600,1320);
insert into Price values("Sleeper",700,1540);
insert into Price values("Sleeper",1000,2200);
insert into Price values("Sleeper",1200,2640);
insert into Price values("Sleeper",1500,2700);
insert into Price values("Sitting",500,620);
insert into Price values("Sitting",600,744);
insert into Price values("Sitting",700,868);
insert into Price values("Sitting",1000,1240);
insert into Price values("Sitting",1200,1488);
insert into Price values("Sitting",1500,1860);

Select * from Passenger;
Select * from Price;

/*
How many females and how many male passengers travelled for a minimum distance of 
600 KM s?
*/
select Gender,count(*) from Passenger where distance >=600 group by Gender;

/*
Find the minimum ticket price for Sleeper Bus. 
*/
select min(price) from price where bus_type="Sleeper";

/*
Select passenger names whose names start with character 'S'
*/

select  Passenger_name from Passenger where Passenger_name like "A%";

/*
Calculate price charged for each passenger displaying Passenger name, Boarding City, 
Destination City, Bus_Type, Price in the output
*/ 

Select pa.Passenger_name,pa.Boarding_City,pa.Destination_City,pa.distance,pa.Bus_type,p.price from Passenger pa
join price as p on p.distance=pa.distance 
group by pa.Passenger_name; 

/*
What are the passenger name/s and his/her ticket price who travelled in the Sitting bus 
for a distance of 1000 KM s  
****************NOTE: for 1000 KM in Sitting no one is there**************
*/

SELECT 
    pa.Passenger_name, 
    p.price 
FROM  Passenger pa
LEFT JOIN Price p  ON pa.distance = p.distance
WHERE   pa.distance=1000 and pa.bus_type="Sitting" group by pa.Passenger_name;


/*
What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to 
Panaji?
NOTE: bangalore to Panaji no records availble so exchanged Boarding and Destination 
*/

drop procedure if exists ticketFare
DELIMITER //
create procedure ticketFare(Pas_Name varchar(50))
	SELECT p.bus_type,p.price
	from Price p
	where 
	p.distance =(Select  Passenger.distance from Passenger 
    where Passenger.Passenger_name=Pas_Name 
    and Passenger.boarding_city="Panaji" 
    and Passenger.destination_city="Bengaluru") gidroup by bus_type;

DELIMITER ;

call ticketFare("Pallavi");



/*
List the distances from the "Passenger" table which are unique (non-repeated 
distances) in descending order
*/

select distinct(distance) from Passenger order by distance DESC;

/*
Display the passenger name and percentage of distance travelled by that passenger 
from the total distance travelled by all passengers without using user variables 
*/

SELECT Passenger_name, distance * 100 / total.sum AS `Percentage of Distance`
FROM Passenger
INNER JOIN (SELECT SUM(distance) AS sum FROM Passenger) total;

/*
	Display the distance, price in three categories in table Price
	a) Expensive if the cost is more than 1000
	b) Average Cost if the cost is less than 1000 and greater than 500
    c) Cheap otherwise
*/

SELECT Distance, Price,
	CASE WHEN Price > 1000 THEN 'Expensive'
	WHEN price>500 and price<=1000 THEN 'Average Cost'
	ELSE 'Cheap'
	END AS Category
FROM Price;




