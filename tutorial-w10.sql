-- supervisor
select s.name, count(*)
from employee s, employee e, department d
WHERE AND s.number = e.supervisor
    AND e.department = d.code
    ANd d.location <> "HANOI"
GROUP by s.number


SELECT e.position, d.name, COUNT(*)
FROM department D, employee E 
WHERE E.department = D.code;
GROUP By e.position,