-- views.sql
-- Time Table Management System Views

-- View showing all ongoing theory sessions
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

-- View showing all ongoing lab sessions
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

-- View mapping instructors to assigned courses
create view CourseAllocationView as
select
    ca.InstructorID,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    ca.CourseID,
    c.CourseName
from Course_Assignment ca
join Instructor i on ca.InstructorID = i.InstructorID
join Course c on ca.CourseID = c.CourseID

-- View showing office hours of each instructor
create view instructorOfficeHours as
select i.InstructorID , i.FirstName + ' ' + i.LastName as Instructor_Name ,o.hours as Office_Hours
from Instructor as i join OfficeHours as o on
i.InstructorID = o.InstructorID

-- View showing how many sessions each instructor is teaching
create view InstructorLoadView as
select 
    i.InstructorID,
    i.FirstName + ' ' + i.LastName as Instructor_Name,
    count(s.SessionID) as TotalSessions
from Instructor i
left join Session s on i.InstructorID = s.InstructorID
group by i.InstructorID, i.FirstName, i.LastName
