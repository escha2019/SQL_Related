---Question 4
select distinct b.bname
from account a inner join branch b on b.bname=a.bname
where b.bname IN (select a2.bname
				from customer c inner join account a2 on
				c.cname = a2.cname
				where lower(c.ccity)='eden prairie' and 
				lower(c.ccity) != 'edina');
				
---Question 5
 
select a.cname
from account a inner join loan l on a.cname = l.cname
where (l.bname IN (select b.bname
                  from branch b
				  where lower(b.bcity) = 'edina') and 
	  a.bname IN (select b2.bname
                  from branch b2
				  where lower(b2.bcity) = 'edina')) and
				  l.bname != a.bname
group by a.cname
having count(a.bal)=1 and count(l.amt)=1;

--- Question 6
select a.cname, avg(l.amt)
from account a full outer join loan l on a.cname = l.cname
where l.bname IN (select b.bname
                  from branch b
				  where lower(b.bcity) = 'edina') and 
	  a.bname IN (select b2.bname
                  from branch b2
				  where lower(b2.bcity) = 'edina')
group by a.cname
having avg(l.amt)>1000;


                 















