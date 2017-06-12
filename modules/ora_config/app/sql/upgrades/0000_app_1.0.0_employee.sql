CREATE TABLE DEPARTMENT(
   deptno     INTEGER NOT NULL,
   name       VARCHAR(14),
   location   VARCHAR(13)
);

ALTER TABLE EMPLOYEE
   ADD CONSTRAINT emp_pk
   PRIMARY KEY (empno);


CREATE TABLE EMPLOYEE(
   empno      INTEGER NOT NULL,
   name       VARCHAR(10),
   job        VARCHAR(9),
   boss       INTEGER,
   hiredate   VARCHAR(12),
   salary     DECIMAL(7, 2),
   comm       DECIMAL(7, 2),
   deptno     INTEGER
);

ALTER TABLE DEPARTMENT
   ADD CONSTRAINT dept_pk
   PRIMARY KEY (deptno);

