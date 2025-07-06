# Timetable Management System (SQL Server)

This project is a SQL-based academic scheduling system designed to manage and organize university timetables. It ensures that sessions (lectures and labs) are scheduled without conflicts, while properly tracking instructors, courses, student sections, rooms, and time slots.

---

## 📌 Overview

- Each instructor can teach one or more courses  
- Courses can be taught by multiple instructors  
- Theory and lab sessions are scheduled in separate spaces with dedicated rules  
- Time slots and room assignments are conflict-free using constraints and checks  
- Views and stored procedures are used to retrieve structured outputs  

---

## 🗂️ Folder Structure

sql/
└── timetable-db-complete.sql -- All table definitions, sample data, views, and stored procedures

docs/
└── ERD.png -- Entity-Relationship Diagram of the system


---

## 🛠️ Technologies Used

- **SQL Server**  
- **T-SQL**  
- **ERD Modeling**

---

## 🧱 Key Components

### 📋 Tables
- `Instructor`, `TheoryInstructor`, `LabInstructor`
- `Course`, `Course_Assignment`
- `Section`, `Session`, `TimeSlot`, `ClassRoom`, `Lab`
- `OfficeHours`

### 🔍 Views
- `OngoingTheorySessions`
- `OngoingLabSessions`
- `CourseAllocationView`
- `InstructorLoadView`
- `InstructorOfficeHours`

### ⚙️ Stored Procedures
- `AssignCourseToInstructor`
- `InsertNewTheoryInstructor`
- `ScheduleTheorySession`
- `AvailableLabSlots`
- `GetInstructorSchedule`

---

## 🚀 How to Run

1. Open `timetable-db-complete.sql` in SQL Server Management Studio  
2. Execute the entire script or run step-by-step to create tables, views, procedures, and insert sample data  
3. Use `SELECT` queries to retrieve data from views  
4. Run stored procedures with sample input values to simulate timetable operations  

---

## 📊 ERD Diagram

The Entity Relationship Diagram illustrates the structure and relationships between entities like instructors, courses, and sessions.

timetable-management-system/docs/ERD.png

---

**Muhammad Danish Jawad**  
[GitHub Profile](https://github.com/yourusername) *(optional)*
