-- procedures.sql
-- Time Table Management System Stored Procedures

-- Assign a course to an instructor
create procedure AssignCourseToInstructor
@InstructorID varchar(5),
@CourseID varchar(5) as
insert into Course_Assignment (InstructorID, CourseID)
select @InstructorID, @CourseID

-- Get an instructor's full session schedule
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

-- Find all free times for a specific lab
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

-- Adds a new theory instructor to both the Instructor and Theory Instructor tables
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

-- Schedule a new theory class session
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
