---Assign Q1B Ans
select e1.name, e1.D#
from emp_salaried e1
where salary < 30000 and
	e1.ssn IN (select w.ssn
	           from work_on w
	           group by w.ssn
	           having count(w.#p) > 2 ) and  
	(select ei.name As manager_Name
	 from emp_salaried ei,department d
	 where ei.ssn=d.manager_ssn and e1.ssn = ei.ssn) 
	 =
	(select e3.name AS Supervisor_Name
	 from emp_salaried e2,emp_salaried e3
     where e2.supervisor_ssn = e3.ssn and e1.ssn = e2.ssn)  
						

--Assign Q2B Ans
select c.name, a.bal
from customer c inner join account a on a.ssn = c.cssn
where EXISTS
		(select ep.ssn, ep.name 
         from emp ep, emp p2		 
		 where ep.ssn = p2.supervisor_ssn and
		 c.banker_ssn = p2.ssn and p2.sal > 50000 and
		 ep.name = 'John');
		  
				  
--Assign Q3 Ans.
select a.cname
from account a inner join loan l on a.cname = l.cname
where (l.bname IN (select b.bname
                  from branch b
				  where lower(b.bcity) = 'edina') and 
	  a.bname IN (select b2.bname
                  from branch b2
				  where lower(b2.bcity) = 'edina'))
MINUS
select a.cname
from account a inner join loan l on a.cname = l.cname
where (l.bname IN (select b.bname
                  from branch b
				  where lower(b.bcity) = 'edina') and 
	  a.bname IN (select b2.bname
                  from branch b2
				  where lower(b2.bcity) = 'edina')) and 
				  l.bname = a.bname ;
				  

--Assign Q4 Ans
create view loanAndCust AS
(select a.cname, a.bname
from account a
UNION 
select l.cname, l.bname
from  loan l );
select customer.cname, lc.bname
from customer left join loanAndCust lc on customer.cname = lc.cname; 

--Assign Q5 Ans
select distinct branch.bcity
from branch, account
where account.bname = branch.bname and account.cname IN
  (select distinct a.cname
   from account a 
   where (exists (select a1.cname from account a1
                  where a.cname = a1.cname and a1.bname ='Southdale') and 
          exists (select a2.cname from account a2
                  where a.cname = a2.cname and a2.bname = 'France') and
          exists (select a3.cname from account a3
                  where a.cname = a3.cname and a3.bname = 'York') )
                OR
         (exists (select a4.cname from account a4
                  where a.cname = a4.cname and a4.bname = 'Main') and
          exists (select a5.cname from account a5
                  where a.cname = a5.cname and a5.bname = 'Ridgedale') and
          exists (select a6.cname from account a6
                  where a.cname = a6.cname and a6.bname ='Second') ) );
