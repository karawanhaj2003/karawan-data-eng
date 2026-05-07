--------------------------------------------------
-- ����� ��� ������� hospital4 (�� ���� ����)
--------------------------------------------------
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'hospital4')
BEGIN
    CREATE DATABASE hospital4;
END
GO

--------------------------------------------------
-- ����� ���� ������� hospital4
--------------------------------------------------
USE hospital4;
GO

--------------------------------------------------
-- 1?? ���� Departments
-- ������ �� ������� ������
--------------------------------------------------
CREATE TABLE dbo.Departments (
    DepartmentID INT NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Departments PRIMARY KEY (DepartmentID)
);
GO

INSERT INTO dbo.Departments (DepartmentID, DepartmentName) VALUES
(1, 'Cardiology'), (2, 'Neurology'), (3, 'Orthopedics'), (4, 'Pediatrics'),
(5, 'Dermatology'), (6, 'Oncology'), (7, 'ENT'), (8, 'Urology'),
(9, 'Psychiatry'), (10, 'Ophthalmology'), (11, 'Gastroenterology'),
(12, 'Endocrinology'), (13, 'Nephrology'), (14, 'Pulmonology'), (15, 'Rheumatology');
GO

--------------------------------------------------
-- 2?? ���� Doctors
-- ������ ������ ������
--------------------------------------------------
CREATE TABLE dbo.Doctors (
    DoctorID INT NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Specialization NVARCHAR(100) NULL,
    Phone NVARCHAR(20) NULL,
    YearsExperience INT NULL,
    HospitalBranch NVARCHAR(100) NULL,
    Email NVARCHAR(100) NULL,
    CONSTRAINT PK_Doctors PRIMARY KEY (DoctorID)
);
GO

INSERT INTO dbo.Doctors (DoctorID, FirstName, LastName, Specialization, Phone, YearsExperience, HospitalBranch, Email) VALUES
(1, 'Ahmed', 'Khalil', 'Cardiology', '0501111111', 15, 'Central', 'ahmed.khalil@hospital.com'),
(2, 'Sara', 'Nabil', 'Neurology', '0502222222', 12, 'North', 'sara.nabil@hospital.com'),
(3, 'John', 'Doe', 'Orthopedics', '0503333333', 20, 'Central', 'john.doe@hospital.com'),
(4, 'Laila', 'Yousef', 'Pediatrics', '0504444444', 10, 'East', 'laila.yousef@hospital.com'),
(5, 'Youssef', 'Hassan', 'Dermatology', '0505555555', 8, 'West', 'youssef.hassan@hospital.com'),
(6, 'Mona', 'Saleh', 'Cardiology', '0506666666', 14, 'Central', 'mona.saleh@hospital.com'),
(7, 'Omar', 'Khaled', 'Neurology', '0507777777', 18, 'North', 'omar.khaled@hospital.com'),
(8, 'Fatima', 'Ali', 'Orthopedics', '0508888888', 9, 'East', 'fatima.ali@hospital.com'),
(9, 'Hassan', 'Ahmed', 'Pediatrics', '0509999999', 16, 'West', 'hassan.ahmed@hospital.com'),
(10, 'Nadia', 'Yousef', 'Dermatology', '0501010101', 11, 'Central', 'nadia.yousef@hospital.com');
GO

--------------------------------------------------
-- 3?? ���� Patients
-- ������ ������� ������
--------------------------------------------------
CREATE TABLE dbo.Patients (
    PatientID INT NOT NULL,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    BirthDate DATE NULL,
    Gender CHAR(1) NULL,
    Phone NVARCHAR(20) NULL,
    Address NVARCHAR(200) NULL,
    RegistrationDate DATE NULL,
    InsuranceProvider NVARCHAR(100) NULL,
    InsuranceNumber NVARCHAR(50) NULL,
    Email NVARCHAR(100) NULL,
    CONSTRAINT PK_Patients PRIMARY KEY (PatientID)
);
GO

INSERT INTO dbo.Patients (PatientID, FirstName, LastName, BirthDate, Gender, Phone, Address, RegistrationDate, InsuranceProvider, InsuranceNumber, Email) VALUES
(1, 'Ali', 'Hassan', '1980-05-12', 'M', '0521111111', 'Street 1', '2020-01-01', 'InsureCo', 'INS001', 'ali.hassan@email.com'),
(2, 'Mona', 'Saleh', '1990-08-22', 'F', '0522222222', 'Street 2', '2019-05-12', 'HealthPlus', 'INS002', 'mona.saleh@email.com'),
(3, 'Omar', 'Khaled', '1985-03-15', 'M', '0523333333', 'Street 3', '2018-07-20', 'MedSecure', 'INS003', 'omar.khaled@email.com'),
(4, 'Fatima', 'Ali', '1992-12-01', 'F', '0524444444', 'Street 4', '2021-03-15', 'InsureCo', 'INS004', 'fatima.ali@email.com'),
(5, 'Hassan', 'Ahmed', '1975-07-20', 'M', '0525555555', 'Street 5', '2017-11-05', 'HealthPlus', 'INS005', 'hassan.ahmed@email.com'),
(6, 'Sara', 'Yousef', '1988-02-18', 'F', '0526666666', 'Street 6', '2016-09-12', 'MedSecure', 'INS006', 'sara.yousef@email.com'),
(7, 'Khalid', 'Omar', '1991-06-22', 'M', '0527777777', 'Street 7', '2019-01-30', 'InsureCo', 'INS007', 'khalid.omar@email.com'),
(8, 'Leila', 'Hassan', '1983-04-10', 'F', '0528888888', 'Street 8', '2020-08-18', 'HealthPlus', 'INS008', 'leila.hassan@email.com'),
(9, 'Tariq', 'Saleh', '1979-12-25', 'M', '0529999999', 'Street 9', '2018-05-05', 'MedSecure', 'INS009', 'tariq.saleh@email.com'),
(10, 'Nadia', 'Khaled', '1995-09-12', 'F', '0521010101', 'Street 10', '2021-02-10', 'InsureCo', 'INS010', 'nadia.khaled@email.com');
GO

--------------------------------------------------
-- 4?? ���� Appointments
-- ������ ������ ��� ������� �������
--------------------------------------------------
CREATE TABLE dbo.Appointments (
    AppointmentID INT NOT NULL,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDateTime DATETIME NULL,
    Status NVARCHAR(50) NULL,
    Notes NVARCHAR(200) NULL,
    CONSTRAINT PK_Appointments PRIMARY KEY (AppointmentID)
);
GO

ALTER TABLE dbo.Appointments
ADD CONSTRAINT FK_Appointments_Patients FOREIGN KEY (PatientID)
REFERENCES dbo.Patients(PatientID);
GO

ALTER TABLE dbo.Appointments
ADD CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (DoctorID)
REFERENCES dbo.Doctors(DoctorID);
GO

INSERT INTO dbo.Appointments (AppointmentID, PatientID, DoctorID, AppointmentDateTime, Status, Notes) VALUES
(1, 1, 1, '2026-03-01 09:00:00', 'Scheduled', 'Routine checkup'),
(2, 2, 2, '2026-03-01 10:00:00', 'Completed', 'Migraine consultation'),
(3, 3, 3, '2026-03-02 11:00:00', 'Scheduled', 'Knee pain'),
(4, 4, 4, '2026-03-02 12:00:00', 'Completed', 'Vaccination'),
(5, 5, 5, '2026-03-03 09:30:00', 'Scheduled', 'Skin rash'),
(6, 6, 6, '2026-03-03 10:30:00', 'Completed', 'Heart check'),
(7, 7, 7, '2026-03-04 11:30:00', 'Scheduled', 'Neurology follow-up'),
(8, 8, 8, '2026-03-04 12:30:00', 'Completed', 'Fracture consultation'),
(9, 9, 9, '2026-03-05 13:00:00', 'Scheduled', 'Pediatrics exam'),
(10, 10, 10, '2026-03-05 14:00:00', 'Completed', 'Dermatology check'),
(11, 1, 6, '2026-03-06 09:00:00', 'Scheduled', 'Cardiology review'),
(12, 2, 7, '2026-03-06 10:00:00', 'Completed', 'Neurology check'),
(13, 3, 8, '2026-03-07 11:00:00', 'Scheduled', 'Orthopedic review'),
(14, 4, 9, '2026-03-07 12:00:00', 'Completed', 'Pediatrics consultation'),
(15, 5, 10, '2026-03-08 09:00:00', 'Scheduled', 'Dermatology check'),
(16, 6, 1, '2026-03-08 10:30:00', 'Completed', 'Cardiology follow-up'),
(17, 7, 2, '2026-03-09 11:00:00', 'Scheduled', 'Neurology review'),
(18, 8, 3, '2026-03-09 12:30:00', 'Completed', 'Orthopedic check'),
(19, 9, 4, '2026-03-10 09:00:00', 'Scheduled', 'Pediatrics follow-up'),
(20, 10, 5, '2026-03-10 10:30:00', 'Completed', 'Dermatology exam');
GO

--------------------------------------------------
-- 5?? ���� Treatments
-- ������ ������� ������ ������ �����
--------------------------------------------------
CREATE TABLE dbo.Treatments (
    TreatmentID INT NOT NULL,
    AppointmentID INT NOT NULL,
    TreatmentType NVARCHAR(100) NULL,
    Description NVARCHAR(200) NULL,
    Cost DECIMAL(10,2) NULL,
    TreatmentDate DATETIME NULL,
    CONSTRAINT PK_Treatments PRIMARY KEY (TreatmentID)
);
GO

ALTER TABLE dbo.Treatments
ADD CONSTRAINT FK_Treatments_Appointments FOREIGN KEY (AppointmentID)
REFERENCES dbo.Appointments(AppointmentID);
GO

INSERT INTO dbo.Treatments (TreatmentID, AppointmentID, TreatmentType, Description, Cost, TreatmentDate) VALUES
(1, 1, 'ECG', 'Routine ECG test', 100.00, '2026-03-01 09:15:00'),
(2, 2, 'MRI', 'Brain MRI scan', 500.00, '2026-03-01 10:15:00'),
(3, 3, 'X-Ray', 'Knee X-ray', 150.00, '2026-03-02 11:15:00'),
(4, 4, 'Vaccination', 'Child vaccination', 50.00, '2026-03-02 12:15:00'),
(5, 5, 'Skin Biopsy', 'Skin lesion biopsy', 200.00, '2026-03-03 09:45:00'),
(6, 6, 'Blood Test', 'Heart blood panel', 80.00, '2026-03-03 10:45:00'),
(7, 7, 'EEG', 'EEG test', 120.00, '2026-03-04 11:45:00'),
(8, 8, 'Ultrasound', 'Fracture check', 220.00, '2026-03-04 12:45:00'),
(9, 9, 'Pediatrics Exam', 'General pediatrics', 100.00, '2026-03-05 13:15:00'),
(10, 10, 'Dermatology Check', 'Skin health exam', 150.00, '2026-03-05 14:15:00'),
(11, 11, 'ECG', 'Cardio review', 100.00, '2026-03-06 09:15:00'),
(12, 12, 'MRI', 'Neurology review', 500.00, '2026-03-06 10:15:00'),
(13, 13, 'X-Ray', 'Orthopedic review', 150.00, '2026-03-07 11:15:00'),
(14, 14, 'Vaccination', 'Pediatrics booster', 50.00, '2026-03-07 12:15:00'),
(15, 15, 'Skin Biopsy', 'Dermatology check', 200.00, '2026-03-08 09:15:00'),
(16, 16, 'ECG', 'Cardiology follow-up', 100.00, '2026-03-08 10:45:00'),
(17, 17, 'MRI', 'Neurology follow-up', 500.00, '2026-03-09 11:15:00'),
(18, 18, 'X-Ray', 'Orthopedic check', 150.00, '2026-03-09 12:45:00'),
(19, 19, 'Pediatrics Exam', 'Pediatrics follow-up', 100.00, '2026-03-10 09:15:00'),
(20, 20, 'Dermatology Check', 'Dermatology follow-up', 150.00, '2026-03-10 10:45:00');
GO

--------------------------------------------------
-- 6?? ���� Billing
-- ������ ������ ������ ���� �������
--------------------------------------------------
CREATE TABLE dbo.Billing (
    BillID INT NOT NULL,
    TreatmentID INT NOT NULL,
    PatientID INT NOT NULL,
    BillDate DATETIME NULL,
    Amount DECIMAL(10,2) NULL,
    PaymentMethod NVARCHAR(50) NULL,
    PaymentStatus NVARCHAR(50) NULL,
    CONSTRAINT PK_Billing PRIMARY KEY (BillID)
);
GO

ALTER TABLE dbo.Billing
ADD CONSTRAINT FK_Billing_Treatments FOREIGN KEY (TreatmentID)
REFERENCES dbo.Treatments(TreatmentID);
GO

ALTER TABLE dbo.Billing
ADD CONSTRAINT FK_Billing_Patients FOREIGN KEY (PatientID)
REFERENCES dbo.Patients(PatientID);
GO

INSERT INTO dbo.Billing (BillID, TreatmentID, PatientID, BillDate, Amount, PaymentMethod, PaymentStatus) VALUES
(1, 1, 1, '2026-03-01', 100.00, 'Cash', 'Paid'),
(2, 2, 2, '2026-03-01', 500.00, 'Card', 'Paid'),
(3, 3, 3, '2026-03-02', 150.00, 'Cash', 'Paid'),
(4, 4, 4, '2026-03-02', 50.00, 'Card', 'Paid'),
(5, 5, 5, '2026-03-03', 200.00, 'Cash', 'Paid'),
(6, 6, 6, '2026-03-03', 80.00, 'Card', 'Paid'),
(7, 7, 7, '2026-03-04', 120.00, 'Cash', 'Paid'),
(8, 8, 8, '2026-03-04', 220.00, 'Card', 'Paid'),
(9, 9, 9, '2026-03-05', 100.00, 'Cash', 'Paid'),
(10, 10, 10, '2026-03-05', 150.00, 'Card', 'Paid');
GO
