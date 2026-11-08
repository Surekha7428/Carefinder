
-- CareFinder - Smart Nearby Hospital Finder
-- MySQL schema + DEMO / SAMPLE data (not live hospital data).
-- Run:  mysql -u root -p < database/schema.sql

CREATE DATABASE IF NOT EXISTS carefinder CHARACTER SET utf8mb4;
USE carefinder;

DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS hospital_availability;
DROP TABLE IF EXISTS hospital_specialties;
DROP TABLE IF EXISTS accident_types;
DROP TABLE IF EXISTS specialties;
DROP TABLE IF EXISTS hospitals;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  phone VARCHAR(20),
  role ENUM('patient','staff') DEFAULT 'patient',
  hospital_name VARCHAR(150) DEFAULT '',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE appointments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  patient_name VARCHAR(100),
  phone VARCHAR(25),
  hospital_ref VARCHAR(40),
  hospital_name VARCHAR(150),
  department VARCHAR(80),
  appt_date DATE,
  appt_time VARCHAR(5),
  reason VARCHAR(300),
  status ENUM('Pending','Confirmed','Completed','Cancelled','Declined') DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE hospitals (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  address VARCHAR(255),
  latitude DECIMAL(9,6) NOT NULL,
  longitude DECIMAL(9,6) NOT NULL,
  phone VARCHAR(25),
  hospital_type ENUM('Government','Private') NOT NULL,
  rating DECIMAL(2,1) DEFAULT 0,
  reviews_count INT DEFAULT 0,
  emergency_available TINYINT(1) DEFAULT 1,
  icu_available TINYINT(1) DEFAULT 0,
  ambulance_available TINYINT(1) DEFAULT 0,
  blood_available TINYINT(1) DEFAULT 0,
  total_beds INT DEFAULT 0,
  available_beds INT DEFAULT 0,
  opening_time TIME DEFAULT '00:00:00',
  closing_time TIME DEFAULT '23:59:00',
  image VARCHAR(255)
);

CREATE TABLE specialties (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE hospital_specialties (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hospital_id INT NOT NULL,
  specialty_id INT NOT NULL,
  FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE,
  FOREIGN KEY (specialty_id) REFERENCES specialties(id) ON DELETE CASCADE
);

CREATE TABLE accident_types (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  description VARCHAR(255)
);

CREATE TABLE hospital_availability (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hospital_id INT NOT NULL,
  emergency_status ENUM('Available','Limited','Call to Confirm') DEFAULT 'Available',
  available_beds INT DEFAULT 0,
  icu_beds INT DEFAULT 0,
  blood_status ENUM('Available','Limited','Unavailable','Unknown') DEFAULT 'Unknown',
  last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (hospital_id) REFERENCES hospitals(id) ON DELETE CASCADE
);

-- ---------- CAREFINDER HOSPITAL DATA: 14 DIRECTORY ENTRIES ----------
-- These are the 14 hospitals listed in CITY_DIRECTORY in app.py.
-- Coordinates are approximate town/city-centre pins, NOT verified hospital entrances.
-- Ratings, bed counts, ICU counts, blood stock and emergency status are left unverified.
-- Do not present these values as real-time availability.

INSERT INTO specialties (name) VALUES
 ('Emergency'),('Trauma'),('Orthopedics'),('Cardiology'),('Neurology'),
 ('Neurosurgery'),('Burns'),('Pediatrics'),('Pulmonology');

INSERT INTO accident_types (name, description) VALUES
 ('Road Crash','Vehicle collisions, bike accidents, pedestrian hits.'),
 ('Burn','Fire, hot liquid, chemical or electrical burns.'),
 ('Fall','Falls from height, slips and suspected fractures.'),
 ('Sports Injury','Sprains, fractures and ligament injuries during sport.'),
 ('Cardiac Emergency','Chest pain, suspected heart attack, sudden collapse.'),
 ('Breathing Emergency','Severe breathlessness, choking, asthma attack.'),
 ('Other Emergency','Any other urgent situation.');

INSERT INTO hospitals
(id,name,address,latitude,longitude,phone,hospital_type,rating,reviews_count,
 emergency_available,icu_available,ambulance_available,blood_available,
 total_beds,available_beds,opening_time,closing_time,image)
VALUES
(1,'Government General Hospital, Rajamahendravaram','Rajamahendravaram, Andhra Pradesh 533105',17.000500,81.804000,NULL,'Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(2,'GSL Medical College & General Hospital','NH-16, Lakshmipuram, Rajamahendravaram, Andhra Pradesh 533296',17.000500,81.804000,'+918836699999','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(3,'Apollo Hospitals, Kakinada','Suryaraopeta Main Road, Kakinada, Andhra Pradesh 533001',16.989100,82.247500,NULL,'Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(4,'Medicover Hospitals, Kakinada','ADB Road, Panasapadu, Kakinada, Andhra Pradesh 533005',16.989100,82.247500,NULL,'Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(5,'Vision Multi Speciality Hospital, Samalkota','D. No. 11-1, 29/2, Main Road, near Meher Complex, Samarlakota, Andhra Pradesh 533440',17.053700,82.169600,'+919491766405','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(6,'Community Health Centre, Samalkot','Samalkot, Kakinada District, Andhra Pradesh',17.053700,82.169600,'+918125288989','Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(7,'Vision Multi Speciality Hospital, Pithapuram','Beside Union Bank of India, near Kotagummam Centre, Kalyanamandapam, Pithapuram, Andhra Pradesh 533450',17.116600,82.254800,'+918179120555','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(8,'Community Health Centre, Pithapuram','Pithapuram, Kakinada District, Andhra Pradesh',17.116600,82.254800,NULL,'Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(9,'KIMS Hospital, Amalapuram','NH216, Chaitanya Nagar, Amalapuram, Andhra Pradesh 533201',16.578000,82.006000,'+918856239999','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(10,'Area Hospital, Amalapuram','Amalapuram, Konaseema District, Andhra Pradesh 533201',16.578000,82.006000,NULL,'Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(11,'King George Hospital, Visakhapatnam','Maharanipeta, Visakhapatnam, Andhra Pradesh 530002',17.686800,83.218500,NULL,'Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(12,'Apollo Hospitals, Visakhapatnam','Waltair Main Road, Ram Nagar, Visakhapatnam, Andhra Pradesh 530002',17.686800,83.218500,'+918912727272','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(13,'NIMS Hospital, Hyderabad','Punjagutta, Hyderabad, Telangana',17.385000,78.486700,'+914023489999','Government',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,''),
(14,'Apollo Hospitals, Jubilee Hills, Hyderabad','Film Nagar, Jubilee Hills, Hyderabad, Telangana',17.385000,78.486700,'+914069071200','Private',NULL,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'');

-- Specialty associations only use broad categories supplied in the project directory.
INSERT INTO hospital_specialties (hospital_id, specialty_id) VALUES
(2,1),(2,3),
(4,3),(4,4),
(5,1),(5,3),
(7,1),(7,3);

-- Unknown means the project has no verified live availability information.
INSERT INTO hospital_availability
(hospital_id, emergency_status, available_beds, icu_beds, blood_status)
VALUES
(1,'Call to Confirm',NULL,NULL,'Unknown'),
(2,'Call to Confirm',NULL,NULL,'Unknown'),
(3,'Call to Confirm',NULL,NULL,'Unknown'),
(4,'Call to Confirm',NULL,NULL,'Unknown'),
(5,'Call to Confirm',NULL,NULL,'Unknown'),
(6,'Call to Confirm',NULL,NULL,'Unknown'),
(7,'Call to Confirm',NULL,NULL,'Unknown'),
(8,'Call to Confirm',NULL,NULL,'Unknown'),
(9,'Call to Confirm',NULL,NULL,'Unknown'),
(10,'Call to Confirm',NULL,NULL,'Unknown'),
(11,'Call to Confirm',NULL,NULL,'Unknown'),
(12,'Call to Confirm',NULL,NULL,'Unknown'),
(13,'Call to Confirm',NULL,NULL,'Unknown'),
(14,'Call to Confirm',NULL,NULL,'Unknown');
