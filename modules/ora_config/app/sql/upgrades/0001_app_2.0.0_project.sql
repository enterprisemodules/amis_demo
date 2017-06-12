CREATE TABLE PROJECT(
   projectno    INTEGER NOT NULL,
   description  VARCHAR(100),
   start_date   VARCHAR(12),
   end_date     VARCHAR(12)
);

ALTER TABLE PROJECT
   ADD CONSTRAINT project_pk
   PRIMARY KEY (projectno);

CREATE TABLE ROLE(
   role_id      INTEGER NOT NULL,
   description  VARCHAR(100)
);

ALTER TABLE ROLE
   ADD CONSTRAINT role_pk
   PRIMARY KEY (role_id);


CREATE TABLE PROJECT_PARTICIPATION(
   projectno    INTEGER NOT NULL,
   empno        INTEGER NOT NULL,
   start_date   VARCHAR(12) NOT NULL,
   end_date     VARCHAR(12),
   role_id      INTEGER
);
 
ALTER TABLE PROJECT_PARTICIPATION
   ADD CONSTRAINT participation_pk
   PRIMARY KEY (projectno, empno, start_date);

