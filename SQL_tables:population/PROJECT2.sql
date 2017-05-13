INSERT INTO ADMIN
VALUES(2420,'FELIX SINGERMAN','1994-01-10','flsingerman@gmail.com','Canada'),(2121,'WILSON LY','1996-07-02','rman@gmail.com','Canada'),(4542,'ERIK TURNBUL','1993-02-01','man@gmail.com','USA'),
(9472,'PATRICK LANGIS','1996-05-23','frman@gmail.com','USA'),(3525,'SUPERMAN','1956-12-31','rmn@gmail.com','USA'),(007,'James Bond','1964-10-11','rma@gmail.com','Canada');

INSERT INTO FRIDGE
VALUES(454352,2420,3,now(),now()),(543321,4542,2,now(),now()),(234312,007,2,now(),now()),
(458979,9472,3,now(),now()),(343209,2121,3,now(),now());

INSERT INTO CHEF
VALUES (2420,'FELIX SINGERMAN','1994-01-10','fsing047@uottawa.ca','Canada'),(1675,'ANTHONY BOURDAIN','1964-01-24','jkhdskfh309@uottawa.ca','USA'),(1754,'BENJAMIN GREEN','1981-10-20','sdjkl2909@uottawa.ca','USA'),
(2121,'PATRICK LANGIS','1996-05-23','skj389@uottawa.ca','Canada'),(4982,'HOMER SIMPSON','2005-12-19','wiu019@uottawa.ca','USA');

INSERT INTO REGULAR_USER
VALUES (2420,'FELIX SINGERMAN','1994-01-10','felix_2006@msn.com','Canada'),(4542,'ERIK TURNBUL','1993-02-10','bye1026@msn.com','Canada'),(2121,'WILSON LY','1994-01-10','food1001@msn.com','Canada'),
(3398,'ELLIOT ALDERSON','1991-07-19','hello3902@msn.com','USA'),(4321,'JON SNOW','2005-04-14','fel06@msn.com','USA');

INSERT INTO INGREDIENT
VALUES (1111,'Honey',2,2.75,1),(2222,'Olive Oil',2,10.25,1),(3333,'Ketchup',1,1.55,0),
(4444,'Apple',12,0.55,6),(5555,'Gnochhi',1,5.11,0),(6666,'Egg',12,2.75,4),
(7777,'Feta Cheese',1,3.75,0),(8888,'Sweet Potato',2,1.75,2),
(9999,'Milk',1,1.00,1),(1234, 'Wine', 2, 10.96, 2),(4256,'Salmon',4,15,0);

INSERT INTO MEAL
VALUES (12,'Sweet Potato Quiche','Mix all ingredients and put in oven at 400 degrees for
	25 minutes'),(11,'Maple Salmon','Put the salmon on the pan, dress with olive oil. Stir the ingredients into a bowl. Place the sauce over the salmon. Put in oven for 20 minutes at 400 degrees.'),
	(54,'Green Salad','Mix lettuce with vinegar, oil and salt pepper');

INSERT INTO MEAL_ORDER
VALUES (1, 2420, 12, 1,null),(2, 3398, 11, 2,TRUE),(3, 2121, 54, 1,TRUE),(4, 3398, 12, 5,FALSE);

INSERT INTO MEALS
VALUES (12,1111,1),(12,2222,1),(12,9999,2),(12,6666,6),(12,8888,2)
,(11,1111,1),(11,4256,2);

INSERT INTO INGR_ORDER
VALUES (1, 2420, 1111,2),(3, 4321, 2222,1), (5, 3398, 5555,1), (8, 4542, 6666,2), 
(10, 2420, 7777,3), (2, 2420, 9999,4);

INSERT INTO REPORT 
VALUES (31, 'Popular INGREDIENT', 'the most Popular ingredents are'),(41, 'Who ordered what', 'Heres the list of who ordered what'),(10, 'Who approved what', 'the list of admins and what they approved and denied');

INSERT INTO ORDERS
VALuES (2420, 1111),(2420, 2222),(2420, 6666),(3398,7777);

INSERT INTO CREATES
VALUES (12,2420),(11,2121),(12,1675); 

INSERT INTO REVIEWS
VALUES (1,2420),(2,2420),(3,9472);



-- Queries


DROP TABLE ADMIN CASCADE;
DROP TABLE INGREDIENT CASCADE;
DROP TABLE FRIDGE CASCADE; 
DROP TABLE MEAL CASCADE;
DROP TABLE CHEF CASCADE;
DROP TABLE REGULAR_USER CASCADE;
DROP TABLE MEAL_ORDER CASCADE;
DROP TABLE INGR_ORDER CASCADE;
DROP TABLE REPORT CASCADE;
DROP TABLE ORDERS CASCADE;
DROP TABLE ACCESS CASCADE;
DROP TABLE CREATES CASCADE;
DROP TABLE REVIEWS CASCADE;
DROP TABLE REQUESTS CASCADE;
DROP TABLE MEALS CASCADE;


-- triggers

CREATE OR REPLACE TRIGGER check_birth_date
  BEFORE INSERT OR UPDATE ON admin
  FOR EACH ROW
BEGIN
  IF( :admin.dob > date '1999-01-01')
  THEN
    RAISE_APPLICATION_ERROR( 
      -20001, 
      'You must be 18 years old in orer to be an admin' );
  END IF;
END;

CREATE OR REPLACE TRIGGER check_legal_canada
  BEFORE INSERT OR UPDATE ON REGULAR_USER
  FOR EACH ROW
BEGIN
  IF( :REGULAR_USER.dob < date '1998-01-01') and (:REGULAR_USER.country = 'Canada')
  THEN
    RAISE_APPLICATION_ERROR( 
      -20001, 
      'You must be 19 years old in order to drink an alcoholic beverage in Canada' );
  END IF;
END;



CREATE OR REPLACE TRIGGER check_legal_usa
  BEFORE INSERT OR UPDATE ON REGULAR_USER
  FOR EACH ROW
BEGIN
  IF( :REGULAR_USER.dob < date '1996-01-01') and (:REGULAR_USER.country = 'USA')
  THEN
    RAISE_APPLICATION_ERROR( 
      -20001, 
      'You must be 21 years old in order to drink an alcoholic beverage in USA' );
  END IF;
END;

CREATE OR REPLACE TRIGGER check_tempurature
  BEFORE INSERT OR UPDATE ON INGREDIENT
  FOR EACH ROW
BEGIN
  IF( :FRIDGE.tempurature > 10)
  THEN
  	DELETE FROM INGREDIENT *;
    RAISE_APPLICATION_ERROR( 
      -20001, 
      'THE FOOD IS CONTAMINATED' );
  END IF;
END;


CREATE FUNCTION expired_ingredient_delete_old_rows() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  DELETE FROM INGREDIENT WHERE timestamp < NOW() - INTERVAL '30 days';
  RETURN NEW;
END;
$$;

CREATE TRIGGER expired_ingredient_delete_old_rows_trigger
    AFTER INSERT ON INGREDIENT
    EXECUTE PROCEDURE expired_ingredient_delete_old_rows();