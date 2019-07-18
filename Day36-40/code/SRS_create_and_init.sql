-- 如果存在名为school的数据库就删除它
drop database if exists school;

-- 创建名为school的数据库并设置默认的字符集和排序方式
create database school default charset utf8 collate utf8_bin;

-- 切换到school数据库上下文环境
use school;

-- 创建学院表
create table tb_college
(
collid int not null auto_increment comment '编号',
collname varchar(50) not null comment '名称',
collmaster varchar(20) not null comment '院长',
collweb varchar(511) default '' comment '网站',
primary key (collid)
);

-- 创建学生表
create table tb_student
(
stuid int not null comment '学号',
stuname varchar(20) not null comment '姓名',
stusex bit default 1 comment '性别',
stubirth date not null comment '出生日期',
stuaddr varchar(255) default '' comment '籍贯',
collid int not null comment '所属学院',
primary key (stuid),
foreign key (collid) references tb_college (collid)
);

-- alter table tb_student add constraint fk_student_collid foreign key (collid) references tb_college (collid);

-- 创建教师表
create table tb_teacher
(
teaid int not null comment '工号',
teaname varchar(20) not null comment '姓名',
teatitle varchar(10) default '助教' comment '职称',
collid int not null comment '所属学院',
primary key (teaid),
foreign key (collid) references tb_college (collid)
);

-- 创建课程表
create table tb_course
(
couid int not null comment '编号',
couname varchar(50) not null comment '名称',
coucredit int not null comment '学分',
teaid int not null comment '授课老师',
primary key (couid),
foreign key (teaid) references tb_teacher (teaid)
);

-- 创建选课记录表
create table tb_score
(
scid int auto_increment comment '选课记录编号',
stuid int not null comment '选课学生',
couid int not null comment '所选课程',
scdate datetime comment '选课时间日期',
scmark decimal(4,1) comment '考试成绩',
primary key (scid),
foreign key (stuid) references tb_student (stuid),
foreign key (couid) references tb_course (couid)
);

-- 添加唯一性约束（一个学生选某个课程只能选一次）
alter table tb_score add constraint uni_score_stuid_couid unique (stuid, couid);

-- 插入学院数据
insert into tb_college (collname, collmaster, collweb) values 
('计算机学院', '左冷禅', 'http://www.abc.com'),
('外国语学院', '岳不群', 'http://www.xyz.com'),
('经济管理学院', '风清扬', 'http://www.foo.com');

-- 插入学生数据
insert into tb_student (stuid, stuname, stusex, stubirth, stuaddr, collid) values
(1001, '杨逍', 1, '1990-3-4', '四川成都', 1),
(1002, '任我行', 1, '1992-2-2', '湖南长沙', 1),
(1033, '王语嫣', 0, '1989-12-3', '四川成都', 1),
(1572, '岳不群', 1, '1993-7-19', '陕西咸阳', 1),
(1378, '纪嫣然', 0, '1995-8-12', '四川绵阳', 1),
(1954, '林平之', 1, '1994-9-20', '福建莆田', 1),
(2035, '东方不败', 1, '1988-6-30', null, 2),
(3011, '林震南', 1, '1985-12-12', '福建莆田', 3),
(3755, '项少龙', 1, '1993-1-25', null, 3),
(3923, '杨不悔', 0, '1985-4-17', '四川成都', 3);

-- 插入老师数据
insert into tb_teacher (teaid, teaname, teatitle, collid) values 
(1122, '张三丰', '教授', 1),
(1133, '宋远桥', '副教授', 1),
(1144, '杨逍', '副教授', 1),
(2255, '范遥', '副教授', 2),
(3366, '韦一笑', '讲师', 3);

-- 插入课程数据
insert into tb_course (couid, couname, coucredit, teaid) values 
(1111, 'Python程序设计', 3, 1122),
(2222, 'Web前端开发', 2, 1122),
(3333, '操作系统', 4, 1122),
(4444, '计算机网络', 2, 1133),
(5555, '编译原理', 4, 1144),
(6666, '算法和数据结构', 3, 1144),
(7777, '经贸法语', 3, 2255),
(8888, '成本会计', 2, 3366),
(9999, '审计学', 3, 3366);

-- 插入选课数据
insert into tb_score (stuid, couid, scdate, scmark) values 
(1001, 1111, '2017-09-01', 95),
(1001, 2222, '2017-09-01', 87.5),
(1001, 3333, '2017-09-01', 100),
(1001, 4444, '2018-09-03', null),
(1001, 6666, '2017-09-02', 100),
(1002, 1111, '2017-09-03', 65),
(1002, 5555, '2017-09-01', 42),
(1033, 1111, '2017-09-03', 92.5),
(1033, 4444, '2017-09-01', 78),
(1033, 5555, '2017-09-01', 82.5),
(1572, 1111, '2017-09-02', 78),
(1378, 1111, '2017-09-05', 82),
(1378, 7777, '2017-09-02', 65.5),
(2035, 7777, '2018-09-03', 88),
(2035, 9999, curdate(), null),
(3755, 1111, date(now()), null),
(3755, 8888, date(now()), null),
(3755, 9999, '2017-09-01', 92);

-- 查询所有学生信息
select * from tb_student;

-- 查询所有课程名称及学分(投影和别名)
select couname, coucredit from tb_course;
select couname as 课程名称, coucredit as 学分 from tb_course;

select stuname as 姓名, case stusex when 1 then '男' else '女' end as 性别 from tb_student;
select stuname as 姓名, if(stusex, '男', '女') as 性别 from tb_student;

-- 查询所有女学生的姓名和出生日期(筛选)
select stuname, stubirth from tb_student where stusex=0;

-- 查询所有80后学生的姓名、性别和出生日期(筛选)
select stuname, stusex, stubirth from tb_student where stubirth>='1980-1-1' and stubirth<='1989-12-31';
select stuname, stusex, stubirth from tb_student where stubirth between '1980-1-1' and '1989-12-31';

-- 查询姓"杨"的学生姓名和性别(模糊)
select stuname, stusex from tb_student where stuname like '杨%';

-- 查询姓"杨"名字两个字的学生姓名和性别(模糊)
select stuname, stusex from tb_student where stuname like '杨_';

-- 查询姓"杨"名字三个字的学生姓名和性别(模糊)
select stuname, stusex from tb_student where stuname like '杨__';

-- 查询名字中有"不"字或"嫣"字的学生的姓名(模糊)
select stuname, stusex from tb_student where stuname like '%不%' or stuname like '%嫣%';

-- 查询没有录入家庭住址的学生姓名(空值)
select stuname from tb_student where stuaddr is null;

-- 查询录入了家庭住址的学生姓名(空值)
select stuname from tb_student where stuaddr is not null;

-- 查询学生选课的所有日期(去重)
select distinct scdate from tb_score;

-- 查询学生的家庭住址(去重)
select distinct stuaddr from tb_student where stuaddr is not null;

-- 查询男学生的姓名和生日按年龄从大到小排列(排序)
-- asc - ascending - 升序（从小到大）
-- desc - descending - 降序（从大到小）
select stuname as 姓名, year(now())-year(stubirth) as 年龄 from tb_student where stusex=1 order by 年龄 desc;

-- 聚合函数：max / min / count / sum / avg
-- 查询年龄最大的学生的出生日期(聚合函数)
select min(stubirth) from tb_student;

-- 查询年龄最小的学生的出生日期(聚合函数)
select max(stubirth) from tb_student;

-- 查询男女学生的人数(分组和聚合函数)
select count(stuid) from tb_student;
select stusex, count(*) from tb_student group by stusex;
select stusex, min(stubirth) from tb_student group by stusex;

-- 查询课程编号为1111的课程的平均成绩(筛选和聚合函数)
select avg(scmark) from tb_score where couid=1111;
select min(scmark) from tb_score where couid=1111;
select count(scid) from tb_score where couid=1111;
select count(scmark) from tb_score where couid=1111;

-- 查询学号为1001的学生所有课程的平均分(筛选和聚合函数)
select avg(scmark) from tb_score where stuid=1001;

-- 查询每个学生的学号和平均成绩(分组和聚合函数)
select stuid as 学号, avg(scmark) as 平均分 from tb_score group by stuid;

-- 查询平均成绩大于等于90分的学生的学号和平均成绩
-- 分组以前的筛选使用where子句
-- 分组以后的筛选使用having子句
select stuid as 学号, avg(scmark) as 平均分 from tb_score group by stuid having 平均分>=90;

-- 查询年龄最大的学生的姓名(子查询/嵌套的查询)
select stuname from tb_student where stubirth=(
	select min(stubirth) from tb_student
);

-- 查询年龄最大的学生姓名和年龄(子查询+运算)
select stuname as 姓名, year(now())-year(stubirth) as 年龄 from tb_student where stubirth=(
	select min(stubirth) from tb_student
);

-- 查询选了两门以上的课程的学生姓名(子查询/分组条件/集合运算)
select stuname from tb_student where stuid in (
	select stuid from tb_score group by stuid having count(stuid)>2
)

-- 查询学生姓名、课程名称以及成绩(连接查询)
select stuname, couname, scmark from tb_student t1, tb_course t2, tb_score t3 where t1.stuid=t3.stuid and t2.couid=t3.couid and scmark is not null;

select stuname, couname, scmark from tb_student t1 inner join tb_score t3 on t1.stuid=t3.stuid inner join tb_course t2 on t2.couid=t3.couid where scmark is not null order by scmark desc limit 5 offset 10;

select stuname, couname, scmark from tb_student t1 inner join tb_score t3 on t1.stuid=t3.stuid inner join tb_course t2 on t2.couid=t3.couid where scmark is not null order by scmark desc limit 10, 5;

-- 单表：65535TB
-- 单列：4G - LONGBLOB (Binary Large OBject) / LONGTEXT
-- 查询选课学生的姓名和平均成绩(子查询和连接查询)
select stuname, avgmark from tb_student t1, (select stuid, avg(scmark) as avgmark from tb_score group by stuid) t2 where t1.stuid=t2.stuid;

select stuname, avgmark from tb_student t1 inner join 
(select stuid, avg(scmark) as avgmark from tb_score group by stuid) t2 on t1.stuid=t2.stuid;

-- 内连接（inner join）：只有满足连接条件的记录才会被查出来
-- 外连接（outer join）：左外连接 / 右外连接 / 全外连接
-- left outer join / right outer join / full outer join
-- 查询每个学生的姓名和选课数量(左外连接和子查询)
select stuname, ifnull(total, 0) from tb_student t1 left outer join (select stuid, count(stuid) as total from tb_score group by stuid) t2 on t1.stuid=t2.stuid;
