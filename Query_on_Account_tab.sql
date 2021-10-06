---Group Q2
(select a.cname
from account a inner join branch b on b.bname=a.bname 
where a.bal>1000 and lower(b.bcity)='minneapolis'
group by a.cname
having count(a.cname)= 1 )
INTERSECT
(select l.cname
from loan l inner join branch b on l.bname=b.bname
where l.amt < 4000 and (lower(b.bcity)= 'edina' OR lower(b.bcity) = 'bloomington') 
group by l.cname
having count(l.amt)>=1);

---Group Q4 

(select c.cname
from customer c, branch b, account a
where c.cname=a.cname and b.bname= a.bname and lower(b.bcity)='minnetonka'
and lower(c.ccity)IN ('minnetonka', 'eden prairie'))

INTERSECT
(
	(select l.cname
	from loan l, branch b
	where l.bname=b.bname and 
          exists (select a4.cname from loan a4
                  where l.cname = a4.cname and a4.bname = 'Main') and
          exists (select a5.cname from loan a5
                  where l.cname = a5.cname and a5.bname = 'Ridgedale') and
          exists (select a6.cname from loan a6
                   where l.cname = a6.cname and a6.bname ='Second') 
	group by l.cname
	having avg(l.amt) < 500
    MINUS
	select l.cname
	from loan l, branch b
	where l.bname=b.bname and lower(b.bcity) = 'minnetonka'
	group by l.cname, l.bname
	having avg(l.amt) >= 500)
 );
					

		


