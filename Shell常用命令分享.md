#test

##1.基础知识
- Linux目录结构和文件

		1.文件
		在linux系统中一切皆文件.文件夹和设备都是文件.使用文件描述符(fd:file descriptor)来对文件进行操作.文件描述符是整数
		
		2.目录结构
		"/" :Linux文件系统的入口.也是最高一级的目录.
		"." :当前目录
		".." :父目录
		"/usr":存放用户使用系统命令和应用程序等信息.像命令.帮助文件等.
		"/home":普通用户的目录默认存储目录.
		"/etc":所有的系统配置文件.
		"/proc":系统信息目录.只存在内存当中，而不占用外存空间.(./cpuinfo ./meminfo ./net/)
		"/bin":基本系统所需要的命令,功能和"/usr/bin"类似,这个目录下的文件都是可执行的.普通用户也是可以执行的.

		"/boot":内核和加载内核所需要的文件.grub系统引导管理器也在这个目录下.
		"/dev":设备文件存储目录.像终端.磁盘等.
		"/lib":库文件和内核模块存放目录.
		"/media":即插即用设备的挂载点自动存放在这个目录下.像U盘,cdrom/dvd自动挂载后,就会在这个目录下.
		"/mnt":临时文件系统的挂载点目录.
		"/opt":第三方软件的存放目录.
		"/root":Linux超级权限用户root的根目录.
		"/sbin":基本的系统维护命令,只能由超级用户使用.
		"/srv":存放一些服务器启动之后需要提取的数据.
		"/tmp":临时文件目录.
		"/var":存放经常变动的数据,像日志.邮件等.
		
		2.文件基本信息
		lic@lic:~/tmp$ ls -l 
		-rw-rw-r-- 1 lic lic 19 Oct 25 07:21 tmp1.sh
		第一个小格是特殊表示格，表示目录或连结文件等等，d表示目录，l表示软链接文件，“-”表示文件
		后面9个小格:rw-(Owner)rw-(Group)r--(Other)
		第二个栏位，表示文件个数
		第三个栏位，表示该文件或目录的拥有者
		第四个栏位，表示所属的group
		第五栏位，表示文件大小
		第六个栏位，表示创建日期
		第七个栏位，表示文件名
		Linux的文件是没有所谓的扩展名的，扩展名只是作为执行软件或程序识别用；文件能否被执行仅余

		3.软链接和硬链接
		建立软链接ln -s
		建立硬链接ln
		inode:索引节点，是文件的唯一标识而非文件名
		（元数据中的 inode 号才是文件的唯一标识而非文件名）
		（参考文档:http://www.ibm.com/developerworks/cn/linux/l-cn-hardandsymb-links/）
- 管道

		| 管道符号
		command 1 | command 2 他的功能是把第一个命令command 1执行的结果作为command 2的输入传给command 2


- 重定向
		
		1.文件描述符:
		0表示标准输入
		1表示标准输出
		2表示标准错误

		2.重定向输出:将命令的正常输出结果保存到指定的文件中,而不是直接显示在显示器的屏幕上
		若重定向的输出的文件不存在，则会新建该文件
		> 重定向输出(覆盖文件)
		>> 重定向输出(追加内容)
		
		其他重定向知识
		< 重定向输入: 将命令中接收输入的途径由默认的键盘改为其他文件.而不是等待从键盘输入
		2> 错误重定向:类似于重定向输出
		&> 混合输出:不区分标准输出和错误输出
		&等同于
		/dev/null 垃圾桶:无法读取任何文件，也不会因为输出的内容过多而导致文件大小不断的增加
		ls /tmp /nginx 1>a.txt 2>b.txt
		> /dev/null 2>&1
- 账户及权限切换

		sudo
		su - 
		exit
		chmod u:用户，g:组，o:其它，a所有用户(默认)； r=4,w=2,x=1
- 其他基本命令

		ls, mv, cp, rm, touch, mkdir等命令,例如
		root@laogu8:/home/sgm/logs# ls -Slr
		root@laogu8:/home/sgm/logs# ls -lrt

##2.实用小命令
- tr

		lic@lic:~/tmp$ cat test_data |tr "string_1" "string_2"
		lic@lic:~/tmp$ cat test_data |tr "a-l" "A-L"
- date

		lic@lic:~/tmp$ date
		lic@lic:~/tmp$ date '+%c'
		lic@lic:~/tmp$ date '+%D'
		lic@lic:~/tmp$ date '+%x'
		lic@lic:~/tmp$ date '+%T'
		lic@lic:~/tmp$ date '+%X'
		lic@lic:~/tmp$ date -d next-day +%Y%m%d
		lic@lic:~/tmp$ date -d 'next monday'
		lic@lic:~/tmp$ date -d '2 weeks'
- sort
		
		sort默认为升序，如果需要降序使用-r参数:
		lic@lic:~/tmp$ cat test_data |sort -r

		以数值大小来排序使用-n参数
		设置间隔符使用-t参数
		指定列数使用-k参数
		lic@lic:~/tmp$ cat test_data |sort -k4nr -t :

		忽略大小写使用-f参数
		
		
- head/tail

		显示前30行
		lic@lic:~/tmp$ cat test_data |head -n 30
		显示前30个字节
		lic@lic:~/tmp$ cat test_data |head -c 30
		显示除前30行之外的行数
		lic@lic:~/tmp$ cat test_data |head -n -30

- more/less

		Enter    向下n行，需要定义。默认为1行
		Ctrl+F   向下滚动一屏
		空格键  向下滚动一屏
		Ctrl+B  返回上一屏
		=       输出当前行的行号
		：f     输出文件名和当前行的行号
		V      调用vi编辑器
		!命令   调用Shell，并执行命令 
		q       退出more
		
		从第50行开始显示
		lic@lic:~/tmp$ cat test_data |more +50
		从的一个string_1开始显示
		lic@lic:~/tmp$ cat test_data |more +/string_1

- 其他，例如base64

		lic@lic:~/tmp$ echo "www.hypers.com" |base64
		d3d3Lmh5cGVycy5jb20K
		lic@lic:~/tmp$ echo "d3d3Lmh5cGVycy5jb20K" |base64 -d
		www.hypers.com

##3.常用命令
- grep

		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep 104

		打印行号
		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep -n 104

		打印文件名
		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep -H 104

		统计行数
		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep -c 104

		使用扩展的正则表达式
		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep -E "104|103"

		排除某些行
		qooweds@ubuntu:~/git/python$ cat test_data.txt |grep -Ev "99|103" 
- find

		查找指定目录,指定深度,符合某些特征文件名的文件
		qooweds@ubuntu:~/git/python$ find . -maxdepth 1 -name "test_data.txt"

		查找含有某些字符串的文件
		qooweds@ubuntu:~/git/python$ find . -maxdepth 1 -name "*.txt" |xargs grep -HEnv "99|103"

- sed

		替换并输出指定字符或字符串
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -e 's/字符串_1/字符串_2/g'
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -e 's/\@/\#/g'

		替换并修改指定字符或字符串
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -e 's/\@/\#/g'

		仅替换每行第一个
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -e 's/\'"/\####/'

		仅打印发生变化的行
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -n 's/104/一百四/pg'
		
		限定替换的行
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -n '80,85s/104/一百四/pg'

		同时进行多种替换
		qooweds@ubuntu:~/git/python$ cat test_data.txt |sed -n '80,85s/104/一百四/pg;s/103/一百三/pg'
- awk

		默认分隔符为空格
		qooweds@ubuntu:~/git/python$ cat test_data.txt |awk '{print $2}'

		指定分隔符
		qooweds@ubuntu:~/git/python$ cat test_data.txt |awk -F ':' '{print $2}'

		对某一列数值按数值从大到小进行排序
		qooweds@ubuntu:~/git/python$ cat test_data.txt |awk -F ':|,' '{print $9}' |sort -k1nr |head -20

		将邮箱按ASCII字符顺序进行排序
		qooweds@ubuntu:~/git/python$ cat test_data.txt |awk -F ':|,' '{print $13}' |sed 's/\"//g' |sort -k1 |head -20

		BEGIN,END模式
		qooweds@ubuntu:~/git/python$ cat test_data.txt |head -5|awk -F ':|,' 'BEGIN {print "aaa"} {if($9>90)print $9} END{print "bbb"}'

- vim

		0 到行头
		$ 到行尾
		gg 到文档头
		G 到文档尾
		dd 剪切当前行
		(n)dd 剪切从当前行起的多行
		o 从下一行插入
		O 从上一行插入
		/pattern → 搜索 pattern 的字符串
		n 跳到下一个搜索字符
		# 跳到上一个搜索字符
		vim内替换: 类似于sed
		
##4.其他命令介绍
- crontab
- ssh
- rsync
- top
- ps
- netstat
- wc

- wget
- tar
- mail
- curl
- tcpdump
