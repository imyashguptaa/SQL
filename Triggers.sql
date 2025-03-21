-- Triggers

create database triggers1 ;
use triggers1;
create table Student_details (
Student_id int ,
student_name VARchar(20),
mail_id varchar(30),
mobile_no varchar(12) );
create table Student_details_backup (
Student_id int ,
student_name VARchar(20),
mail_id varchar(30),
mobile_no varchar(12) );

insert into Student_details values ( 59 , "SRIYOGAESH A" , 'sriyogaeshasriyo' , 7667072726 );
insert into Student_details values ( 41 , "RAJARAMAN" , 'RAJAraman15' , 9836574124 ) , ( 13 , "AJISH KUMAR DANIEL " , 'ajish' , 6879123645 ) ,
( 44 , "NIDHIKSHA" , 'Nidhiksha.karthi' , NULL ) , ( 56 , "EVELINE" , 'Eveline.jemima' , 7236148956 ) , ( 25 , "yash Gupta" , 'Yash.Gupta' , 7481328947 );
insert into Student_details values ( 27 , "NAREIN N" , 'Nareinnatarajan' , 7904567628 ) , ( 52 , "SASIDHAR KUMAR N" , 'sasidharkumar' , 9790155634 ) ;

delimiter $$
create trigger STUDENTBACKUP before delete on Student_details  for each row begin 
insert into Student_details_backup(student_Id , Student_name, mail_id ,Mobile_no)
values (old.student_Id , old.Student_name, old.mail_id , old.Mobile_no) ;
end $$
delimiter ;

select * from student_details;
select * from Student_details_backup;

delete from student_details where student_id =44;