-- Time Table Management System
-- Ali Qaash (26)
-- M. Danish Jawad (106)

create database Time_Table_Management_System
use Time_Table_Management_System

create table Instructor(
InstructorID varchar(5) not null Primary Key,
FirstName varchar(30),
LastName varchar(30),
Office varchar(30)
)

create table TheoryInstructor (
InstructorID varchar(5) not null Primary Key,
AcademicRank varchar(30),
Foreign Key(InstructorID) references Instructor(InstructorID)
)

create table LabInstructor (
InstructorID varchar(5) not null Primary Key,
LabSpecialization varchar(30),
Foreign Key(InstructorID) references Instructor(InstructorID)
)

create table OfficeHours(
InstructorID varchar(5) not null foreign key references Instructor(InstructorID),
Hours varchar(20) not null,
Primary Key(instructorID , Hours)
)

create table Course(
CourseID varchar(5) not null Primary Key,
CourseName varchar(20)
)

create table Course_Assignment(
InstructorID varchar(5) not null foreign key references Instructor(InstructorID),
CourseID varchar(5) not null foreign key references Course(CourseID),
Primary Key(InstructorID , CourseID)
)

create table ClassRoom(
RoomNo varchar(5) not null,
Block varchar(5) not null,
NoOfChairs int,
Primary Key(RoomNo , Block),
)

create table Lab(
RoomNo varchar(5) not null,
Block varchar(5) not null,
NoOfComputers int,
Primary Key(RoomNo , Block),
)

create table TimeSlot(
TimeSlotID varchar(5) not null Primary Key,
Day varchar(10),
StartTime varchar(10),
EndTime varchar(10),
unique(day , starttime , endtime)
)

create table Section(
SectionID varchar(15) not null Primary Key,
Semester int)


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

Check((SessionType = 'Theory' and LabNo is NULL and LabBlock is NULL and ClassRoomNo is not NULL and ClassRoomBlock is not NULL)
OR (SessionType = 'Lab' and ClassRoomNo is NULL and ClassRoomBlock is NULL and LabNo is not NULL and LabBlock is not NULL))
)

--Creating Views

create view OngoingTheorySessions as
select
    s.SessionID,
    s.SessionType,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    c.CourseName,
    cr.RoomNo,
    cr.Block,
    t.Day,
    t.StartTime,
    t.EndTime,
    sec.SectionID,
    sec.Semester
from Session s
join Instructor i on s.InstructorID = i.InstructorID
join Course c on s.CourseID = c.CourseID
join ClassRoom cr on s.ClassRoomNo = cr.RoomNo AND s.ClassRoomBlock = cr.Block
join TimeSlot t on s.TimeSlotID = t.TimeSlotID
join Section sec on s.SectionID = sec.SectionID
where s.SessionType = 'Theory'

select * from OngoingTheorySessions

create view OngoingLabSessions as
select
    s.SessionID,
    s.SessionType,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    c.CourseName,
    l.RoomNo,
    l.Block,
    t.Day,
    t.StartTime,
    t.EndTime,
    sec.SectionID,
    sec.Semester
from Session s
join Instructor i on s.InstructorID = i.InstructorID
join Course c on s.CourseID = c.CourseID
join Lab l on s.LabNo = l.RoomNo AND s.LabBlock = l.Block
join TimeSlot t on s.TimeSlotID = t.TimeSlotID
join Section sec on s.SectionID = sec.SectionID
where s.SessionType = 'Lab'

select * from OngoingLabSessions

create view CourseAllocationView as
select
    ca.InstructorID,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    ca.CourseID,
    c.CourseName
from Course_Assignment ca
join Instructor i on ca.InstructorID = i.InstructorID
join Course c on ca.CourseID = c.CourseID

select * from CourseAllocationView

create view instructorOfficeHours as
select i.InstructorID , i.FirstName + ' ' + i.LastName as Instructor_Name ,o.hours as Office_Hours
from Instructor as i join OfficeHours as o on
i.InstructorID = o.InstructorID

select * from instructorOfficeHours

create view InstructorLoadView as
select 
    i.InstructorID,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    count(s.SessionID) as TotalSessions
from Instructor i
left join Session s on i.InstructorID = s.InstructorID
group by i.InstructorID, i.FirstName, i.LastName

select * from InstructorLoadView

--Creating Procedures

create procedure AssignCourseToInstructor
@InstructorID varchar(5),
@CourseID varchar(5) as
insert into Course_Assignment (InstructorID, CourseID)
select @InstructorID, @CourseID

exec AssignCourseToInstructor 'I001', 'CS101'

create procedure GetInstructorSchedule
@InstructorID varchar(5) as
select 
s.sessionID,
s.sessionType,
i.firstname + ' ' + i.lastname as Instructor_Name,
c.CourseName,
t.day,
t.StartTime,
t.EndTime,
sec.sectionID
from session s
join Course c on s.CourseID = c.CourseID
join Instructor i on s.InstructorID = i.InstructorID
join TimeSlot t on s.TimeSlotID = t.TimeSlotID
join Section sec on s.SectionID = sec.SectionID
where s.InstructorID = @InstructorID

exec GetInstructorSchedule 'I001'

create procedure AvailableLabSlots
@LabNo varchar(5),
@LabBlock varchar(5) as
select
t.TimeSlotID, 
t.Day, 
t.StartTime, 
t.EndTime
from TimeSlot t
left join Session s on t.TimeSlotID = s.TimeSlotID 
and s.SessionType = 'Lab' 
and s.LabNo = @LabNo 
and s.LabBlock = @LabBlock
WHERE s.SessionID IS NULL

exec AvailableLabSlots 'L02' , 'A'

create procedure InsertNewTheoryInstructor
@InstructorID varchar(5),
@FirstName varchar(30),
@LastName varchar(30),
@Office varchar(30),
@AcademicRank varchar(30) as
insert into Instructor (InstructorID, FirstName, LastName, Office)
select @InstructorID, @FirstName, @LastName, @Office

insert into TheoryInstructor (InstructorID, AcademicRank)
select @InstructorID, @AcademicRank

exec InsertNewTheoryInstructor 'I006', 'Ayesha', 'Raza', 'B12', 'Lecturer'

create procedure ScheduleTheorySession
@SessionID varchar(5),
@InstructorID varchar(5),
@CourseID varchar(5),
@SectionID varchar(15),
@RoomNo varchar(5),
@Block varchar(5),
@TimeSlotID varchar(5)
as
insert into session (SessionID, SessionType, InstructorID, CourseID, SectionID, ClassRoomNo, ClassRoomBlock, TimeSlotID)
select @SessionID, 'Theory', @InstructorID, @CourseID, @SectionID, @RoomNo, @Block, @TimeSlotID

exec ScheduleTheorySession 
'S006',
'I003',
'Hum10',
'SP22-BEE-B',
'CR05',
'N',
'T04'

--Inserting Data

insert into Instructor values
('I001', 'Mahrukh', 'Saleem', 'D101'),
('I002', 'Ahmad', 'Malik', 'H17'),
('I003', 'Zain', 'Abbas', 'C18'),
('I004', 'Hina', 'Khan', 'A22'),
('I005', 'Usman', 'Amjad', 'H21')

insert into TheoryInstructor values
('I001', 'Assistant Professor'),
('I003', 'Professor'),
('I004', 'Lecturer')

insert into LabInstructor values
('I002', 'Programming'),
('I005', 'Computer Networks')

insert into OfficeHours values
('I001', 'Mon 10-12'),
('I001', 'Thu 8-10'),
('I002', 'Tue 11-1'),
('I003', 'Wed 9-11'),
('I003', 'Mon 9-11'),
('I004', 'Thu 2-4'),
('I005', 'Fri 10-12')

insert into course values
('CS101', 'DSA'),
('CS110', 'CCN'),
('MT12', 'Calculus'),
('Hum10', 'Expository Writing'),
('CS005', 'DBMS')

insert into Course_Assignment values
('I001', 'CS005'),
('I002', 'CS101'),
('I003', 'Hum10'),
('I004', 'MT12'),
('I005', 'CS110')

insert into ClassRoom values
('CR11' , 'N' , 44),
('CR07' , 'D' , 32),
('CR05' , 'N' , 48)

insert into lab values
('L02' , 'A' , 40),
('L19' , 'C' , 35)

insert into TimeSlot values
('T01', 'Monday', '09:00', '9:30'),
('T02', 'Monday', '09:30', '10:00'),
('T03', 'Wednesday', '12:00', '12:30'),
('T04', 'Tuesday', '01:00', '01:30'),
('T05', 'Friday', '02:00', '02:30')

insert into Section values
('FA23-BSE-B' , 4),
('SP25-BCS-A' , 1),
('SP22-BEE-B' , 7),
('SP23-BSE-D' , 5),
('FA24-BBA-B' , 2)


insert into Session(SessionID,SessionType,InstructorID,CourseID,SectionID,ClassRoomNo,ClassRoomBlock,TimeSlotID) values
('S001', 'Theory', 'I001', 'CS005', 'FA23-BSE-B' ,'CR11' , 'N', 'T01'),
('S002', 'Theory', 'I001', 'CS005', 'FA23-BSE-B' ,'CR07' , 'D', 'T02'),
('S004', 'Theory', 'I003', 'Hum10', 'SP22-BEE-B' , 'CR05' , 'N' , 'T01')

insert into Session(SessionID,SessionType,InstructorID,CourseID,SectionID,LabNo,LabBlock,TimeSlotID) values
('S003', 'Lab', 'I002', 'CS101', 'SP25-BCS-A' , 'L19' , 'C', 'T05'),
('S005', 'Lab', 'I005', 'CS110', 'FA23-BSE-B' , 'L02' , 'A' , 'T03')

