
首页
公开课堂
问答
已加入课堂
我的问答
我的任务
关系型数据库 - 河北地质大学 > [第六天]CGI
查看课程PPT
Apache, CGI及MySQL的C接口介绍
Apache介绍及安装

Apache是世界使用排名第一的Web服务器软件。它可以运行在几乎所有广泛使用的计算机平台上，由于其跨平台和安全性被广泛使用，是最流行的Web服务器端软件之一。它快速、可靠并且可通过简单的API扩充，将Perl/Python等解释器编译到服务器中。
Apache安装

    sudo apt-get update
    sudo apt-get install tasksel
    sudo tasksel

CGI

CGI(Common Gateway Interface) 是WWW技术中最重要的技术之一，有着不可替代的重要地位。CGI是外部应用程序（CGI程序）与WEB服务器之间的接口标准，是在CGI程序和Web服务器之间传递信息的过程。CGI规范允许Web服务器执行外部程序，并将它们的输出发送给Web浏览器，CGI将Web的一组简单的静态超媒体文档变成一个完整的新的交互式媒体。
Apache开启CGI

需要在apache中开启cgi支持.

sudo ln -s /etc/apache2/mods-available/cgi.load /etc/apache2/mods-enabled/cgi.load

    1

需要重启 apache 服务器

service apache2 restart

    1

需要运行的cgi文件的存放路径为:

/usr/lib/cgi-bin

    1

改完目录的权限, 方便对目录下的文件写.

sudo mkdir /usr/lib/cgi-bin/sx
sudo chmod 777 /usr/lib/cgi-bin/sx

    1
    2

Makefile.

vim Makefile

install:
	cp *.cgi /usr/lib/cgi-bin/sx

    1
    2

MySQL的C接口介绍
安装mysql的C语言库

    sudo apt-get update
    sudo apt-get install libmysqlclient-dev

CCGI 基本使用

CGIC官网链接
获取表单数据

cgiFormResultType   cgiFormString(char *name, char *result, int max);
参数：  name, 指定要获取的表单项的名字
       result,将获得的数据存储到result中
       max， 指定最多读取的字符个数

比如： cgiFormString("name", result,  16);可以获得最多16个字符并且保存于result中

    1
    2
    3
    4
    5
    6
    7

补充函数fprintf

int fprintf(FILE *stream, const char *format, ...);
功能： 将格式化的语句输出到指定的流
fprintf(stdin, "helloworld\n")  等价于 printf("helloworld\n);

    1
    2
    3
    4

补充函数atoi

int atoi(const char *nptr);
功能：将一个字符串转换成对应的数字，比如：“1234” ==》 1234

    1
    2
    3

接口介绍

手册：mysql Documentation
编写：#include <mysql/mysql.h>
编译：gcc  test.c  -o test  -lmysqlclient

MYSQL *mysql_init(MYSQL *mysql)
功能：初始化函数，参数为NULL即可，接收返回值。
     失败，NULL

MYSQL *mysql_real_connect(MYSQL *mysql, const char *host, const char *user, const char *passwd, const char *db, unsigned int port, const char *unix_socket, unsigned long client_flag)
功能：连接mysql服务器
      失败，NULL

void mysql_close(MYSQL *mysql)
功能：关闭服务器连接

int mysql_real_query(MYSQL *mysql, const char *stmt_str, unsigned long length)
功能：执行sql语句，sql语句不能以“；”结尾
      成功，0
      失败， 非0

int mysql_query(MYSQL *mysql, const char *stmt_str)
功能：执行sql语句，sql语句不能以“；”结尾

MYSQL_RES *mysql_store_result(MYSQL *mysql)
功能：存储 mysql_query()  或者  mysql_read_query() 的数据
     失败， NULL

MYSQL_RES *mysql_use_result(MYSQL *mysql)
功能：接收结果，速度要比mysql_use_result()快。

void mysql_free_result(MYSQL_RES *result)
功能：释放空间

my_ulonglong mysql_num_rows(MYSQL_RES *result)
功能：返回 mysql_store_result 的记录个数

my_ulonglong mysql_affected_rows(MYSQL *mysql)
功能：得到执行sql语句之后改变的记录数

const char *mysql_error(MYSQL *mysql)
功能：返回出错提示

MYSQL_FIELD *mysql_fetch_field(MYSQL_RES *result)
功能：返回集合中列的定义   
MYSQL_FIELD *field;

while((field = mysql_fetch_field(result)))
{
    printf("field name %s\n", field->name);
}

MYSQL_FIELD *mysql_fetch_fields(MYSQL_RES *result)
功能：返回集合中列的数组
unsigned int num_fields;
unsigned int i;
MYSQL_FIELD *fields;

num_fields = mysql_num_fields(result);
fields = mysql_fetch_fields(result);
for(i = 0; i < num_fields; i++)
{
   printf("Field %u is %s\n", i, fields[i].name);
}

unsigned int mysql_num_fields(MYSQL_RES *result)
功能：返回集合中列的个数

my_ulonglong mysql_num_rows(MYSQL_RES *result）
功能：返回集合中行的个数
MYSQL_ROW mysql_fetch_row(MYSQL_RES *result)
功能：返回集合中的一行， 结束或者错误返回NULL

unsigned long *mysql_fetch_lengths(MYSQL_RES *result)
功能：返回当前行中每一个字段值的长度 数组。

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45
    46
    47
    48
    49
    50
    51
    52
    53
    54
    55
    56
    57
    58
    59
    60
    61
    62
    63
    64
    65
    66
    67
    68
    69
    70
    71
    72
    73
    74

视图

视图（View）是一种虚拟存在的表，对于使用视图的用户来说基本上是透明的。视图并
不在数据库中实际存在，行和列数据来自定义视图的查询中使用的表，并且是在使用视图时动态生成的。
视图相对于普通的表的优势主要包括以下几项。

   简单： 使用视图的用户完全不需要关心后面对应的表的结构、 关联条件和筛选条件，
对用户来说已经是过滤好的复合条件的结果集。
 安全：使用视图的用户只能访问他们被允许查询的结果集，对表的权限管理并不能
限制到某个行某个列，但是通过视图就可以简单的实现。
 数据独立：一旦视图的结构确定了，可以屏蔽表结构变化对用户的影响，源表增加
列对视图没有影响；源表修改列名，则可以通过修改视图来解决，不会造成对访问
者的影响

    1
    2
    3
    4
    5
    6
    7

创建视图的条件

 mysql> select Select_priv,Create_view_priv from mysql.user where user='root';
+-------------+------------------+
| Select_priv | Create_view_priv |
+-------------+------------------+
| Y           | Y                |
+-------------+------------------+
1 row in set (0.20 sec)

    1
    2
    3
    4
    5
    6
    7
    8

基本语法

创建视图的语法为：
CREATE [OR REPLACE] [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]

修改视图的语法为：
ALTER [ALGORITHM = {UNDEFINED | MERGE | TEMPTABLE}]
VIEW view_name [(column_list)]
AS select_statement
[WITH [CASCADED | LOCAL] CHECK OPTION]

查看视图：
show tables;
desc viewname;


删除视图：
drop view  view_name;

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19

示例：
创建视图;

//单表
create view stus_view as select *from stus;
create view stus_view (id ,name,age) as select * from stus;
create view stus_view (id ,name,age) as select id,name,age  from stus;

//多表
 create or replace view  worker_view (name,departname) as
    -> select name, d_name from workers,depart where workers.d_id=depart.d_id with check option;


修改视图：
使用create or replace view 来修改   
create or replace view worker_view(name,departname,address) as select
    -> name,d_name,address from workers,depart where workers.d_id=depart.d_id;

使用alter修改
alter view worker_view(name,departname,address) as select
    -> name,d_name,address from workers,depart where workers.d_id=depart.d_id;


查询：
mysql> select * from data1.work_view;

更新数据：
update worker_view set address='sh' where name='lisi';


删除视图：
drop view worker_view;

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33

Atom editor 开环境使用的插件

    activate-power-mode：动感插件 atl + ctrl + o :打开插件
    vim-mode：vim模式
    ex-mode：实现:w功能
    monokai：高亮显示
    atom-ternjs：JavaScript 自动补全
    autoprefixer：给 CSS 添加适当的前缀
    color-picker：选颜色
    emmet：写 HTML 的神器
    atom-beautify：美化代码，空格啊什么什么的
    autoclose-html：HTML自动补全闭标签
    file-icons: 增加许多图标,在侧边蓝文件名前面的icon,,很赞
    autocomplete-modules: 自动补全插件, 有HTML, CSS, python 等
    highlight-selected: 高亮当前所选的文字, 双击后全文这个词或变量都会变高亮.
    Open In Browser: 右键打开浏览器.
    atom-clock: 在bar显示 时间
    autocomplete-js-import: 模块导入智能提示
    autocomplete-modules: 模块智能提示【node_modules】

注意

输入中文：
修改 /etc/mysql/mysql.conf.d/myslqd.cnf

[mysqld]
character-set-server=utf8
[client]
defaut-character-set=utf8  

    1
    2
    3
    4
    5
    6
    7

该课时下暂无相关问答

暂无与本课时相关联的问答
上一节
下一节
问

说点什么吧···


选择标签，最多选择4个
HTML5
Unity3D
3D美术
课堂提问仅加入本课堂的学员可见
