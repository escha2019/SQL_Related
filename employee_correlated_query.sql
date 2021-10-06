spool C:\Users\kwewe\Downloads\milestone2.txt
set linesize 80;
set pagesize 64;
set echo on;

/* Group # 2
			Correlated queries
*/

DROP VIEW researchGrad;
DROP VIEW gradstudentRahimi;
DROP VIEW   gpaMajor;
DROP VIEW sn_minn;

			  
/* Find the names of all instructors who works on research project 'X' with 
 graduate student GIndex = '908090' and makes more than 60000 */
Create View researchGrad AS
SELECT e.firstname, e.lastname  
from instructor i, workson o, ResearchProj r, employee e
where lower(o.gindex) ='908090' and 
				i.EmpID = e.EmpID and -- get name 
				o.projidid  = r.projID and -- project name
				i.IIndex = o.iindex and -- project x
				lower(r.name)= 'x' and
				e.salary > 60000;
				



/*Print the names of all students and employees, but only those employees who don't
live in Minneapolis */

Create VIEW sn_minn AS
((select s.firstname, s.lastname
from student s)
UNION
(select e.firstname, e.lastname
from employee e))
MINUS
(select e1.firstname, e1.lastname
from employee e1
where lower(e1.address) LIKE '%minneapolis%');


/*Find all majors with average gpa greater than 3.5 */
Create View gpaMajor AS
select s.major
from student s
group by s.major
having avg(s.gpa) > 3.5;


/* 
find all graduate students who are working on all projects 
that professor Rahimi is working on 
*/
Create View gradstudentRahimi AS
select s1.firstname, s1.lastname 
from student s1
where Not Exists (select e.EmpID
				  from workson o, employee e, instructor i  
				  where i.iindex = o.iindex and  e.EmpID = i.empid and 
				  lower(e.firstname)='rahimi' and
				  o.projidid NOT IN (select o3.projidid
									from GradStudent g, student s3, workson o3
									where s3.StdID = s1.StdID and
									s3.StdID = g.StdID and
									o3.gindex = g.GIndex
									));
				  



spool off;

select 
from student, gradstudent
where student.stdin=gradstudent.stdid


