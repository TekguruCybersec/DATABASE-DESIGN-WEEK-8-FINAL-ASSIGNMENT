-- File: clinic_booking_system.sql
-- Description: This SQL script creates a relational database for a Clinic Booking System.
-- It includes tables for patients, doctors, appointments, medical records, and prescriptions,
-- along with appropriate constraints and relationships.

-- Create the database
CREATE DATABASE IF NOT EXISTS ClinicBookingDB;
USE ClinicBookingDB;

-- -----------------------------------------------------------------------------
-- Table: Patients
-- Description: Stores information about patients.
-- Relationships:
-- - One-to-Many with Appointments (one patient can have many appointments)
-- - One-to-One with MedicalRecords (one patient has one medical record)
-- -----------------------------------------------------------------------------
CREATE TABLE Patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(255)
);

-- -----------------------------------------------------------------------------
-- Table: Doctors
-- Description: Stores information about doctors.
-- Relationships:
-- - One-to-Many with Appointments (one doctor can have many appointments)
-- -----------------------------------------------------------------------------
CREATE TABLE Doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100),
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE
);

-- -----------------------------------------------------------------------------
-- Table: Appointments
-- Description: Manages the appointments between patients and doctors.
-- Relationships:
-- - Many-to-One with Patients (many appointments can belong to one patient)
-- - Many-to-One with Doctors (many appointments can belong to one doctor)
-- -----------------------------------------------------------------------------
CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('Scheduled', 'Completed', 'Canceled') NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- Table: MedicalRecords
-- Description: Stores the medical history and data for each patient.
-- This represents a one-to-one relationship with the Patients table,
-- enforced by the UNIQUE constraint on patient_id.
-- Relationships:
-- - One-to-One with Patients (one medical record for each patient)
-- -----------------------------------------------------------------------------
CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL UNIQUE,
    height_cm DECIMAL(5, 2),
    weight_kg DECIMAL(5, 2),
    blood_type VARCHAR(5),
    allergies TEXT,
    medication_history TEXT,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------
-- Table: Prescriptions
-- Description: Stores prescription information. This table represents
-- a many-to-many relationship between doctors and patients, as a doctor can
-- prescribe to many patients, and a patient can receive prescriptions from
-- many doctors.
-- Relationships:
-- - Many-to-One with Patients (many prescriptions can be for one patient)
-- - Many-to-One with Doctors (many prescriptions can be from one doctor)
-- -----------------------------------------------------------------------------
CREATE TABLE Prescriptions (
    prescription_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(50) NOT NULL,
    instructions TEXT,
    prescription_date DATE NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id) ON DELETE CASCADE
);
