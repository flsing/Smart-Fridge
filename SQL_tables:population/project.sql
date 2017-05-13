create schema project;
set search_path ='project';

CREATE DOMAIN ID AS numeric(10);
CREATE DOMAIN location as varchar(40);



CREATE TABLE ADMIN(
admin_ID 		ID		NOT NULL,
name		varchar(30)		NOT NULL,
dob		date		NOT NULL CHECK (dob between date '1900-01-01' and date'1999-01-01'),
email	varchar(320)	NOT NULL 	UNIQUE,
country 	location,
PRIMARY KEY(admin_ID)
);

CREATE TABLE INGREDIENT (
ingr_ID 				ID 		NOT NULL,
name			varchar(30)		NOT NULL,
count			smallint,
price_per_item	money,
threshold		smallint,
date 			date		default NOW(),
PRIMARY KEY(ingr_ID)
);

CREATE TABLE FRIDGE (
fridge_ID 		ID 		NOT NULL,
adminID			ID		NOT NULL,
temperature 	numeric(5)	NOT NULL,
date		date	NOT NULL,
time		time with time zone	NOT NULL, 
PRIMARY KEY(fridge_ID),
FOREIGN KEY(adminID) REFERENCES ADMIN(admin_ID) ON DELETE RESTRICT
ON UPDATE CASCADE
);


CREATE TABLE MEAL(
meal_ID 		ID 			NOT NULL,	
name		varchar(300) 	NOT NULL,
description 	text,
PRIMARY KEY(meal_ID)

);

CREATE TABLE CHEF(
chef_ID 		ID		NOT NULL,
name		varchar(30)	NOT NULL,
dob		date,
email	varchar(320)	NOT NULL UNIQUE,
country		location,
PRIMARY KEY(chef_ID)
);

CREATE TABLE REGULAR_USER(
reg_ID 		ID		NOT NULL,
name		varchar(30),
dob		date		NOT NULL,
email	varchar(320) NOT NULL UNIQUE,
country		location NOT NULL,
PRIMARY KEY(reg_ID)

);

CREATE TABLE MEAL_ORDER(
order_ID 		ID		NOT NULL,
creator_ID 		ID		NOT NULL,
meal_ID			ID 		NOT NULL,
count			integer,	
state			boolean,
PRIMARY KEY(order_ID),
FOREIGN KEY(creator_ID) REFERENCES REGULAR_USER(reg_ID),
FOREIGN key(meal_ID) REFERENCES MEAL(meal_ID) 
);

CREATE TABLE INGR_ORDER(
order_ID		ID 		NOT NULL,
creator_ID		ID		NOT NULL,
ingr_ID			ID 		NOT NULL,
count			integer,
PRIMARY KEY(order_ID),
FOREIGN KEY(creator_ID) REFERENCES CHEF(chef_ID),
FOREIGN KEY(ingr_ID) REFERENCES INGREDIENT(ingr_ID)
);

CREATE TABLE REPORT (
report_ID		ID				NOT NULL,
name			varchar(120),
description 	text,
PRIMARY KEY(report_ID)
);

--Relations

CREATE TABLE ORDERS(
ID 		ID,
order_ID	ID,
FOREIGN KEY(ID) REFERENCES ADMIN(admin_ID),
FOREIGN KEY(order_ID) REFERENCES INGR_ORDER(order_ID)
);

CREATE TABLE ACCESS(
chef_ID 	ID,
report_ID	ID,
admin_ID	ID,
FOREIGN KEY(chef_ID) REFERENCES CHEF(chef_ID),
FOREIGN KEY(report_ID) REFERENCES REPORT(report_ID),
FOREIGN KEY(admin_ID) REFERENCES ADMIN(admin_ID)
);

CREATE TABLE CREATES(
meal_ID ID,
chef_ID	ID,
FOREIGN KEY(meal_ID) REFERENCES MEAL(meal_ID),
FOREIGN KEY(chef_ID) REFERENCES CHEF(chef_ID)
);

CREATE TABLE REVIEWS(
order_ID	ID,
admin_ID ID,
FOREIGN KEY(order_ID) REFERENCES MEAL_ORDER(order_ID),
FOREIGN KEY(admin_ID) REFERENCES ADMIN(admin_ID)
);


CREATE TABLE REQUESTS(
chef_ID ID,
order_ID ID,
fridge_ID ID,
reg_ID ID,
FOREIGN KEY(reg_ID) REFERENCES REGULAR_USER(reg_ID),
FOREIGN KEY(order_ID) REFERENCES INGR_ORDER(order_ID),
FOREIGN KEY(chef_ID) REFERENCES CHEF(chef_ID),
FOREIGN KEY(fridge_ID) REFERENCES FRIDGE(fridge_ID)
);


CREATE TABLE MEALS(
meal_ID ID,
ingr_ID ID,
quantity integer,
FOREIGN KEY (meal_ID) REFERENCES MEAL(meal_ID),
FOREIGN KEY (ingr_ID) REFERENCES INGREDIENT(ingr_ID));


