-- Test full text parsing
set names utf8;

use mysql_icu_test;
drop table if exists matchTest;
drop table if exists matchTest2;

create table matchTest  (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    phrase VARCHAR(128)
) collate utf8_icu_my_MM_ci;
create table matchTest2  (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    phrase VARCHAR(128)
) collate utf8_icu_custom_ci;

create fulltext index icuft on matchTest (phrase) with parser icu;
create fulltext index icuft2 on matchTest2 (phrase) with parser icu;

insert into matchTest2 (phrase) values 
('မြန်မာစကား'),
('စကာလုံးများ'),
('ဘယ်နှလုံးလဲ။'),
('ဘာလုပ်မလဲ။'),
('မြန်မာဘာသာစကား'),
('မြန်မာလူမျို'),
('မြန်မာနိုင်ငံ'),
('နိုင်ငံရေး'),
('လူများတယ်'),
('အင်္ဂလိန်ကမြန်မာပြည်ကိုလားတယ်။'),
('မြန်လားမာလား။'),
('စကောဘာသာစကား'),
('ကောင်းတယ်။');

insert into matchTest2 (phrase) values 
('This is English'),
('It is easier to use full text searches in English');

insert into matchTest select * from matchTest2;

repair table matchTest quick;
repair table matchTest2 quick;

select 'Match လုံး';
select * from matchTest where match (phrase) against ('လုံး');
select 'Match လုပ်';
select * from matchTest where match (phrase) against ('လုပ်');
select 'Match မြန်မာစကား';
select * from matchTest where match (phrase) against ('မြန်မာစကား');
select 'Match မြန်မာ';
select * from matchTest where match (phrase) against ('မြန်မာ');
select 'Match မြန်မာ*';
select * from matchTest where match (phrase) against ('မြန်မာ*' IN BOOLEAN MODE);
select 'Match လူ';
select * from matchTest where match (phrase) against ('လူ');
select 'Match +လူ';
select * from matchTest where match (phrase) against ('+လူ' IN BOOLEAN MODE);

select 'Custom rules';
select 'Match လုံး';
select * from matchTest2 where match (phrase) against ('လုံး');
select 'Match +လူ';
select * from matchTest2 where match (phrase) against ('+လူ' IN BOOLEAN MODE);

select 'Match +လူ -မြန်';
select * from matchTest2 where match (phrase) against ('+လူ -မြန်' IN BOOLEAN MODE);


select 'Match မြန်မာ';
select * from matchTest2 where match (phrase) against ('မြန်မာ');
select 'Match "မြန်မာ" boolean';
select * from matchTest2 where match (phrase) against ('"မြန်မာ"' IN BOOLEAN MODE);
select 'Match မြန်မာ*';
select * from matchTest2 where match (phrase) against ('မြန်မာ*' IN BOOLEAN MODE);

select 'Match ကော';
select * from matchTest2 where match (phrase) against ('ကော');
select 'Match ကောင်း';
select * from matchTest2 where match (phrase) against ('ကောင်း');

