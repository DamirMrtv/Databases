---Task 1

SELECT * FROM course WHERE credits > 3;

SELECT * FROM classroom WHERE building = 'Watson' OR building ='Packard';

SELECT * FROM course WHERE dept_name = 'Comp. Sci';

SELECT * FROM section, course WHERE course.course_id=section.course_id ANd section.semester = 'Fall';

SELECT * FROM student WHERE tot_cred>=45  AND tot_cred<=90;

SELECT * FROM student WHERE name LIKE '%a' OR name LIKE '%e' OR name LIKE '%o' OR name LIKE '%u' OR name LIKE '%i';

SELECT * FROM prereq, course WHERE course.course_id = prereq.course_id AND prereq.prereq_id = 'CS-101';


---Task 2

SELECT dept_name, avg(salary) AS avg_salary FROM instructor GROUP BY dept_name;

SELECT building, count(course_id)  AS count_course FROM course,department WHERE department.dept_name=course.dept_name  GROUP BY building;

SELECT building, count(course_id) FROM department, course
WHERE department.dept_name = course.dept_name GROUP BY building
HAVING count(course_id) =
       (SELECT max(course_count)
        FROM (SELECT count(course_id) AS course_count FROM department, course
                 WHERE department.dept_name = course.dept_name GROUP BY building) AS t );


SELECT department.dept_name, count(course_id) FROM department, course
WHERE department.dept_name = course.dept_name GROUP BY department.dept_name
HAVING count(course_id) =
       (SELECT min(course_count)
        FROM ( SELECT count(course_id) AS course_count FROM department, course
                 WHERE department.dept_name = course.dept_name GROUP BY department.dept_name) AS t );


SELECT student.name, takes.id, count(takes.course_id) FROM course, takes, student
WHERE takes.course_id = course.course_id AND takes.id = student.id AND course.dept_name = 'Comp. Sci.' GROUP BY student.name, takes.id
HAVING count(takes.course_id) > 3;

SELECT * FROM instructor WHERE dept_name='Biology' OR dept_name='Philosophy' OR dept_name='Music';

(SELECT * FROM instructor,teaches WHERE instructor.id=teaches.id AND teaches.year=2018)
EXCEPT (SELECT * FROM instructor,teaches WHERE instructor.id=teaches.id AND teaches.year=2017);



---Task 3

SELECT student.id, name, course.title, course.course_id, takes.grade FROM takes, course, student
WHERE takes.course_id = course.course_id AND takes.id = student.id AND course.dept_name = 'Comp. Sci.' AND (takes.grade = 'A' OR takes.grade = 'A-') order by name;

SELECT instructor.name, instructor.dept_name, student.name, student.id, takes.course_id, takes.grade FROM instructor, advisor, student, takes
WHERE instructor.id = advisor.i_id AND student.id = advisor.s_id AND takes.id = student.id AND (takes.grade = 'B-' OR takes.grade = 'C+' OR takes.grade = 'C' OR takes.grade = 'C-' OR takes.grade = 'F');


(SELECT dept_name FROM course,takes WHERE course.course_id=takes.course_id)
EXCEPT (SELECT dept_name FROM course,takes WHERE course.course_id=takes.course_id AND (takes.grade='C' OR takes.grade='F'));


SELECT instructor.name, takes.course_id, takes.grade, takes.id FROM instructor, course, takes, advisor
WHERE instructor.id = advisor.i_id AND advisor.s_id = takes.id AND course.course_id = takes.course_id AND instructor.name NOT IN (
    SELECT instructor.name FROM instructor, course, takes, advisor
    WHERE instructor.id = advisor.i_id AND advisor.s_id = takes.id AND course.course_id = takes.course_id AND takes.grade IN ('A'));

SELECT distinct time_slot.time_slot_id, title FROM time_slot, course, section
WHERE end_hr < 13 AND section.time_slot_id = time_slot.time_slot_id AND course.course_id = section.course_id order by time_slot.time_slot_id;