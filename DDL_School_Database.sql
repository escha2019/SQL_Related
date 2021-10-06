spool C:\Users\kwewe\Downloads\DDLModified.txt
set linesize 80;
set pagesize 64;
set echo on;
/*___________________________________________________________*\
/* SEIS630 Group ProjIDect 			Group: 2				 *\
/* Building a simple school database -- (DDL)
\*___________________________________________________________*/

-- IF EXISTS DROP TABLE
drop table "CLOCATION" cascade constraints PURGE;
drop table "COURSE" cascade constraints PURGE;
drop table "EMPLOYEE" cascade constraints PURGE;
drop table GradStudent cascade constraints PURGE;
drop table "INSTRUCTOR" cascade constraints PURGE;
drop table ResearchProj cascade constraints PURGE;
drop table "RESOURCES" cascade constraints PURGE;
drop table "STUDENT" cascade constraints PURGE;
drop table "CLOCATION" cascade constraints PURGE;
drop table "DEPARTMENT" cascade constraints PURGE;
drop table "TAKE" cascade constraints PURGE;
drop table WorksOn cascade constraints PURGE;
-- Table_1: Department
CREATE TABLE DEPARTMENT
(
	DeptID			NUMBER(8)           not null,
	DNAME			CHAR(12)			not null,
	ADDRESS			VARCHAR(100)		not null,
	BUDGET 			NUMBER(6,2)					,
	MANAGER			NUMBER(8)					,
	CONSTRAINT PK_DEPARTMENT PRIMARY KEY (DeptID)
);

-- Table_2: Employee
CREATE TABLE EMPLOYEE
(
	EMPID			NUMBER(8)	    	not null,
    Iindex			NUMBER(8)	        not null,
	FirstName			CHAR(10)			not null,
	LastName			CHAR(10)			not null,
	SSN 			CHAR(9)		UNIQUE	not null,
	ADDRESS			VARCHAR(100)		not null,
	POSITION 		VARCHAR(50)			not null,
	SALARY			NUMBER(7,2)					,
	CONSTRAINT PK_EMPLOYEE PRIMARY KEY (EMPID)
);

-- Table_3: Student
CREATE TABLE STUDENT
(
	STDID			NUMBER(8)	        not null,
	FirstName			CHAR(20)			not null,
	LastName			CHAR(20)			not null,
	MAJOR 			CHAR(20)			not null,
	MINOR			CHAR(20)					,
	ADVISOR			NUMBER(8)	DEFAULT 01010101,
	DOB		 		DATE						,
	EnrollDate		DATE						,
	GPA				NUMBER(1,3)					,
	STATUS			CHAR(15)					,
	CONSTRAINT PK_STUDENT PRIMARY KEY (STDID)  ,
	CONSTRAINT CK_STATUS  CHECK(STATUS IN ('FT','PT')) 
);

-- Table_4: Graduate Student
CREATE TABLE GradStudent
(
	GIndex			NUMBER(8)	        not null,
	STDID			NUMBER(8)	UNIQUE	not null,
	ThesisTopic	VARCHAR(50)					,
	AnnualFund		NUMBER(7,2)					,
	OfficeLoc 		CHAR(20)			not null,
	CONSTRAINT PK_GradStudent PRIMARY KEY (GIndex)
);

-- Table_5: Resources
CREATE TABLE RESOURCES
(
	ResID			NUMBER(8)	        not null,
	DESCRIBTION		VARCHAR(30)			not null,
	MAKE			CHAR(15)					,
	DatePurchased	DATE					 	,
	CONSTRAINT PK_RESOURCES PRIMARY KEY (ResID)
);

-- Table_6: Course
CREATE TABLE COURSE
(
	CourseID		NUMBER(8)	        not null,
    LocID          NUMBER(8)	        not null,
	courseName		CHAR(10)			not null,
	CSection		CHAR(2)				not null,
	CLEVEL			CHAR(12)					,
	Credit		NUMBER(1)					,
	CYear			DATE					 	,
	CONSTRAINT PK_COURSE PRIMARY KEY (CourseID)
);

-- Table_7: Instructor
CREATE TABLE INSTRUCTOR
(
	Iindex			NUMBER(8)	        not null,
	EMPID			NUMBER(8)			not null,
	NumPublishedPaper	NUMBER(3)					,
	TenureStatus		CHAR(10)					,
	CONSTRAINT PK_INSTRUCTOR PRIMARY KEY (Iindex)
);

-- Table_8: ResearchProj
CREATE TABLE ResearchProj
(
	ProjID			NUMBER(8)	      not null,
	NAME			VARCHAR(30)					,
	BUDGET			NUMBER(8)					,
	CONSTRAINT PK_ResearchProj PRIMARY KEY (ProjID)
);

-- Table_9: CLOCATION
CREATE TABLE CLOCATION
(
	LocID			NUMBER(8)	      not null,
	BUILDING		CHAR(12)			not null,
	RoomNumber			CHAR(12)			not null,
	ADDRESS			VARCHAR(30)					,
	CONSTRAINT PK_CLOCATION PRIMARY KEY (LocID)
);

--Adding Foreign keys to primary tables 
ALTER TABLE DEPARTMENT
	ADD CONSTRAINT FK_DEPARTMENT_MANAGER_EMP FOREIGN KEY (MANAGER)
		REFERENCES EMPLOYEE(EMPID) ;

ALTER TABLE GradStudent
	ADD CONSTRAINT FK_GradStudent_STUDENT_ID FOREIGN KEY (STDID)
		REFERENCES STUDENT(STDID)
		ON DELETE CASCADE;
		
ALTER TABLE STUDENT
	ADD CONSTRAINT FK_STUDENT_ADVISOR FOREIGN KEY (ADVISOR)
		REFERENCES INSTRUCTOR(Iindex)
		ON DELETE CASCADE;
		
ALTER TABLE INSTRUCTOR
	ADD CONSTRAINT FK_INSTRUCTOR_EMPID FOREIGN KEY (EMPID)
		REFERENCES EMPLOYEE(EMPID)
		ON DELETE CASCADE ;
		
ALTER TABLE COURSE
	ADD CONSTRAINT FK_COURSE_CLOCATION FOREIGN KEY (LocID)
		REFERENCES CLOCATION(LocID) ;


-- AFTER ALTER
-- Table_10(relationship): TAKE 
CREATE TABLE TAKE
(
	STDID			NUMBER(8)			not null,
	CourseID		NUMBER(8)			not null,
	LocID			NUMBER(8)			not null,
	Iindex			NUMBER(8)			not null,
	GRADE			CHAR(2)						,
	CONSTRAINT PK_TAKE 
		PRIMARY KEY (STDID , CourseID , LocID , Iindex),
	CONSTRAINT FK_TAKE_1 
		FOREIGN KEY (STDID) REFERENCES STUDENT(STDID),
	CONSTRAINT FK_TAKE_2 
		FOREIGN KEY (CourseID) REFERENCES COURSE(CourseID),
	CONSTRAINT FK_TAKE_3 
		FOREIGN KEY (LocID) REFERENCES CLOCATION(LocID),
	CONSTRAINT FK_TAKE_4 
		FOREIGN KEY (Iindex) REFERENCES INSTRUCTOR(Iindex)
);

-- Table_11(relationship): Works On 
CREATE TABLE WorksOn
(   
	IINDEX			NUMBER(8)			not null,
	GINDEX			NUMBER(8)			not null,
	ProjIDID			NUMBER(8)			not null,
	StartDate			DATE						,
	FinishDate			DATE						,
	CONSTRAINT PK_WorksOn PRIMARY KEY (IINDEX , GINDEX, ProjIDID ),
	CONSTRAINT FK_WorksOn_1 
		FOREIGN KEY (IINDEX) REFERENCES INSTRUCTOR(IINDEX),
	CONSTRAINT FK_WorksOn_2 
		FOREIGN KEY (GINDEX) REFERENCES GradStudent(GIndex),
	CONSTRAINT FK_WorksOn_3 
		FOREIGN KEY (ProjIDID) REFERENCES ResearchProj(ProjID)
);

spool off;

