CREATE TABLE user(
email_id VARCHAR(32) NOT NULL,
password VARCHAR(32) NOT NULL,
display_name VARCHAR(32),
PRIMARY KEY(email_id),
CONSTRAINT UNIQUE (display_name)
);

CREATE TABLE student(
student_email_id VARCHAR(32) NOT NULL,
FOREIGN KEY (student_email_id) REFERENCES user(email_id), 
PRIMARY KEY(student_email_id) 
);

CREATE TABLE staff(
staff_email_id VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (staff_email_id) REFERENCES user(email_id),
FOREIGN KEY (department_number) REFERENCES department(department_number),
PRIMARY KEY(staff_email_id)
);

CREATE TABLE professor(
professor_email_id VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (professor_email_id) REFERENCES user(email_id),
FOREIGN KEY (department_number) REFERENCES department(department_number),
PRIMARY KEY(professor_email_id)
);

CREATE TABLE ta(
ta_email_id VARCHAR(32) NOT NULL,
ta_teaches VARCHAR(8) NOT NULL,
FOREIGN KEY (ta_teaches) REFERENCES opens_in(course_id),
FOREIGN KEY (ta_email_id) REFERENCES student(student_email_id),
PRIMARY KEY(ta_email_id)
);

CREATE TABLE department(
department_number INT NOT NULL,
PRIMARY KEY(department_number)
);

CREATE TABLE major_in(
student_email_id VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (student_email_id) REFERENCES student(student_email_id),
FOREIGN KEY (department_number) REFERENCES department(department_number),
PRIMARY KEY(student_email_id,department_number)
);

CREATE TABLE program(
program_name VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (department_number) REFERENCES department(department_number),
PRIMARY KEY (program_name)
);

CREATE TABLE pursues(
student_email_id VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
program_name VARCHAR(32) NOT NULL,
FOREIGN KEY (student_email_id) REFERENCES student(student_email_id),
FOREIGN KEY (department_number) REFERENCES department(department_number),
FOREIGN KEY (program_name) REFERENCES program(program_name),
PRIMARY KEY(student_email_id,department_number,program_name)
);

CREATE TABLE instructor(
instructor_email_id VARCHAR(32) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (department_number) REFERENCES department(department_number),
FOREIGN KEY (instructor_email_id) REFERENCES professor(professor_email_id),
PRIMARY KEY(instructor_email_id)
);

CREATE TABLE courses(
course_id VARCHAR(8) NOT NULL,
department_number INT NOT NULL,
FOREIGN KEY (department_number) REFERENCES department(department_number),
PRIMARY KEY (course_id)
);

CREATE TABLE prerequisite(
course_id_1 VARCHAR(8) NOT NULL,
course_id_2 VARCHAR(8) NOT NULL,
FOREIGN KEY (course_id_1) REFERENCES courses(course_id),
FOREIGN KEY (course_id_2) REFERENCES courses(course_id),
PRIMARY KEY (course_id_1,course_id_2)
);

CREATE TABLE semester(
semester_year INT NOT NULL,
semester_season VARCHAR(8) NOT NULL,
PRIMARY KEY (semester_year,semester_season)
);

CREATE TABLE register(
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
student_email_id VARCHAR(32) NOT NULL,
FOREIGN KEY (semester_year,semester_season) REFERENCES semester(semester_year,semester_season),
FOREIGN KEY (student_email_id) REFERENCES student(student_email_id),
PRIMARY KEY (semester_year,semester_season,student_email_id)
);

CREATE TABLE enrolls_in(
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
student_email_id VARCHAR(32) NOT NULL,
course_id VARCHAR(8) NOT NULL,
overall_grade VARCHAR(2) NOT NULL,
prerequisite_grade VARCHAR(2) NOT NULL,
FOREIGN KEY (semester_year,semester_season) REFERENCES register(semester_year,semester_season),
FOREIGN KEY (student_email_id) REFERENCES register(student_email_id),
FOREIGN KEY (course_id) REFERENCES courses(course_id),
PRIMARY KEY(semester_year,semester_season, student_email_id,course_id)
);

CREATE TABLE takes(
student_email_id VARCHAR(32) NOT NULL,
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
course_id VARCHAR(8) NOT NULL,
exam_grade VARCHAR(8) NOT NULL,
exam_id VARCHAR(8) NOT NULL,
FOREIGN KEY (student_email_id) REFERENCES enrolls_in(student_email_id),
FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
FOREIGN KEY (semester_year,semester_season) REFERENCES enrolls_in(semester_year,semester_season),
PRIMARY KEY(student_email_id,exam_id)
);

CREATE TABLE exam(
exam_id VARCHAR(8) NOT NULL,
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
course_id VARCHAR(8) NOT NULL,
PRIMARY KEY(exam_id,semester_year,semester_season,course_id),
FOREIGN KEY (semester_year,semester_season) REFERENCES semester(semester_year,semester_season),
FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE problem(
problem_id VARCHAR(8) NOT NULL,
exam_id VARCHAR(8) NOT NULL,
problem_statement VARCHAR(256) NOT NULL,
FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
PRIMARY KEY(problem_id,exam_id)
);

CREATE TABLE answers(
student_email_id VARCHAR(32) NOT NULL,
problem_id VARCHAR(8) NOT NULL,
exam_id VARCHAR(8) NOT NULL,
student_score INT,
FOREIGN KEY (student_email_id) REFERENCES takes(student_email_id),
FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
FOREIGN KEY (problem_id) REFERENCES problem(problem_id),
PRIMARY KEY(student_email_id, exam_id, problem_id)
);

CREATE TABLE opens_in(
course_id VARCHAR(8) NOT NULL,
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
course_capacity INT NOT NULL,
FOREIGN KEY (course_id) REFERENCES courses(course_id),
FOREIGN KEY (semester_year,semester_season) REFERENCES semester(semester_year,semester_season),
PRIMARY KEY(course_id,semester_year,semester_season)
);

CREATE TABLE instructs(
instructor_email_id VARCHAR(32) NOT NULL,
course_id VARCHAR(8) NOT NULL,
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
FOREIGN KEY (instructor_email_id) REFERENCES instructor(instructor_email_id),
FOREIGN KEY (course_id) REFERENCES opens_in(course_id),
FOREIGN KEY (semester_year,semester_season) REFERENCES semester(semester_year,semester_season),
PRIMARY KEY(instructor_email_id,course_id,semester_season)
);

CREATE TABLE post_feedback(
student_email_id VARCHAR(32) NOT NULL,
instructor_email_id VARCHAR(32) NOT NULL,
course_id VARCHAR(8) NOT NULL,
semester_year VARCHAR(8) NOT NULL,
semester_season VARCHAR(8) NOT NULL,
FOREIGN KEY (semester_year,semester_season) REFERENCES instructs(semester_year,semester_season),
FOREIGN KEY (student_email_id) REFERENCES enrolls_in(student_email_id),
FOREIGN KEY (instructor_email_id) REFERENCES instructs(instructor_email_id),
FOREIGN KEY (course_id) REFERENCES instructs(course_id), 
PRIMARY KEY(student_email_id,instructor_email_id,course_id,semester_year,semester_season)
);

/*
CREATE TRIGGER opens_in
ON course_capacity
BEFORE INSERT
AS 
	DECLARE @tableCount INT
    SELECT @tableCount = COUNT(*)
    FROM opens_in
	
	IF @tableCount > 50
    BEGIN
        ROLLBACK
    END
GO
*/