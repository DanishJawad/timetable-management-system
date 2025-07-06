-- Time Table Management System Database
-- Author: Muhammad Danish Jawad
-- Description: Relational schema to manage courses, instructors, sessions, rooms, and timeslots
-- =========================================

create database Time_Table_Management_System
use Time_Table_Management_System

-- Table for all instructors
create table Instructor(
InstructorID varchar(5) not null Primary Key,
FirstName varchar(30),
LastName varchar(30),
Office varchar(30)
)

-- Table for theory instructors with academic rank
create table TheoryInstructor (
InstructorID varchar(5) not null Primary Key,
AcademicRank varchar(30),
Foreign Key(InstructorID) references Instructor(InstructorID)
)

-- Table for lab instructors with specialization
create table LabInstructor (
InstructorID varchar(5) not null Primary Key,
LabSpecialization varchar(30),
Foreign Key(InstructorID) references Instructor(InstructorID)
)


-- Table to store each instructor's available office hours
create table OfficeHours(
InstructorID varchar(5) not null foreign key references Instructor(InstructorID),
Hours varchar(20) not null,
Primary Key(instructorID , Hours)
)

-- Table for all available courses
create table Course(
CourseID varchar(5) not null Primary Key,
CourseName varchar(20)
)

-- Mapping of which instructor teaches which course
create table Course_Assignment(
InstructorID varchar(5) not null foreign key references Instructor(InstructorID),
CourseID varchar(5) not null foreign key references Course(CourseID),
Primary Key(InstructorID , CourseID)
)

-- Table for classrooms with seating capacity
create table ClassRoom(
RoomNo varchar(5) not null,
Block varchar(5) not null,
NoOfChairs int,
Primary Key(RoomNo , Block),
)

-- Table for lab rooms with computer counts
create table Lab(
RoomNo varchar(5) not null,
Block varchar(5) not null,
NoOfComputers int,
Primary Key(RoomNo , Block)
)

-- Table for day + time slot combinations
create table TimeSlot(
TimeSlotID varchar(5) not null Primary Key,
Day varchar(10),
StartTime varchar(10),
EndTime varchar(10),
unique(day , starttime , endtime)
)

-- Table for student sections with semester information
create table Section(
SectionID varchar(15) not null Primary Key,
Semester int)

-- Table to schedule class sessions (theory or lab)
-- Ensures mutual exclusivity between classroom and lab
-- Prevents overlapping sessions for instructors, rooms, and sections
create table Session(
SessionID varchar(5) not null Primary Key,
SessionType varchar(10) not null check(SessionType = 'Theory' or SessionType = 'Lab'),
InstructorID varchar(5) not null ,
CourseID varchar(5) not null,
SectionID varchar(15) not null foreign key references Section(SectionID),
ClassRoomNo varchar(5),
ClassRoomBlock varchar(5),
LabNo varchar(5),
LabBlock varchar(5),
TimeSlotID varchar(5) references TimeSlot(TimeSlotID),

Foreign Key(InstructorID , CourseID) references Course_Assignment(InstructorID , CourseID),
Foreign Key(ClassRoomNo , ClassRoomBlock) references ClassRoom(RoomNo , Block),
Foreign Key(LabNo , LabBlock) references Lab(RoomNo , Block),

unique(InstructorID , TimeSlotID),
unique(SectionID , TimeSlotID),
unique(ClassRoomNo,ClassRoomBlock,LabNo,LabBlock,TimeSlotID),

-- Ensures either Lab or Classroom is used, not both
Check((SessionType = 'Theory' and LabNo is NULL and LabBlock is NULL and ClassRoomNo is not NULL and ClassRoomBlock is not NULL)
OR (SessionType = 'Lab' and ClassRoomNo is NULL and ClassRoomBlock is NULL and LabNo is not NULL and LabBlock is not NULL))
)



