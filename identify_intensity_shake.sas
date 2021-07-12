libname output"E:\IDI_redzone\output";
libname input"E:\IDI_redzone\input";
proc sql;
create table output.intensity_shake1 as
select
a.FID,
a.Paramvalue as inten_shake,
b.FID,
b.mb2018_v1_ as mb2018
from 
work.intensity_shake a LEFT JOIN work.mb2018 b
on a.FID=b.FID and ;
run;
/* Count the number of meshblocks*/
proc sql;
select count(distinct mb2018) as count1
from output.intensity_shake1;

run;

/*Output the data*/

proc export data = output.intensity_shake1
outfile  = "E:\IDI_redzone\intensity_shake.xlsx"
dbms = tab replace; 
run;

proc sql;
create table output.inten_redzone1 as
select 
mb2018_v1_ as mb2018,
dbh_tc as redzone,
paramvalue as intensity
from INPUT.RR_Mb18_intensity_110812
order by mb2018;
run;

proc sql;
select count(distinct mb2018_v1_)
from INPUT.redzone_mb2018;
run;

proc sql;
create table output.inten_cante1 as
select
mb2018_v1_ as mb2018,
paramvalue as intensity
from input.inten_cante
order by mb2018;
run;



data output.inten_cante3;
set output.inten_cante1;
by mb2018;
keep mb2018 intensity;
if first.mb2018 then output;
run;

data output.inten_cante4 ;
set output.inten_cante3 ;
mb2018_num=input(mb2018,8.);
drop mb2018;
run;
data test1;
set output.inten_cante4;
cante=1;
run;
proc sql;
create table test3 as
select
a.*,
b.*
from 
 test1 a LEFT JOIN output.inten_redzone1  b
on a.mb2018_num=b.mb2018;
run;


proc sql;
select count( mb2018_num)
from output.inten_cante2;
run;
data inten_nz1;
set INPUT.inten_nz;
if paramvalue >0;
run;
proc sql;
create table output.inten_nz2 as
select
mb2018_v1_ as mb2018,
paramvalue as intensity
from inten_nz1
order by mb2018;
run;
data output.inten_nz3;
set output.inten_nz2;
nz=1;
run;


proc sql;
create table output.test4 as
select
a.*,
b.*
from 
 output.inten_redzone1  a LEFT JOIN output.inten_nz3  b
on a.mb2018=b.mb2018;
run;


proc sql;
create table output.test5 as
select
a.*,
b.*
from 
  output.inten_nz3  a LEFT JOIN output.inten_redzone1  b
on a.mb2018=b.mb2018;
run;
proc sql;
select count(distinct mb2018)
from output.test5
where redzone is missing;
run;
