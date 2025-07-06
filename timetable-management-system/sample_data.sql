-- sample_data.sql
-- Time Table Management System Sample Data

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
