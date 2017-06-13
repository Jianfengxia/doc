#!/usr/bin/python
#-coding: utf-8
import MySQLdb
import os
import re
import time
import string
import smtplib
from email.mime.text import MIMEText
import sys
import urllib
import urllib2
import socket
reload(sys)
sys.setdefaultencoding( "utf-8" )
black_list=[]
#获取时间
localtime = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+""
socket.setdefaulttimeout(200)
print "start1",localtime
#打开TBM数据库连接
db1 = MySQLdb.connect("10.1.*.**","root","pass","lag",charset="utf8",init_command='set names utf8')
# 使用cursor()方法获取操作游标 
cursor1 = db1.cursor()
try:
  p1=db1.ping()
except:
  print "OAMmysql connect have been close"
  
#打开TBM-test数据库连接
db2 = MySQLdb.connect("10.1.*.**","root","pass","lag",charset="utf8",init_command='set names utf8')
# 使用cursor()方法获取操作游标 
cursor2 = db2.cursor()
try:
  p2=db2.ping()
except:
  print "tbm-test mysql connect have been close"
  
  
#打开TBM-test数据库连接
db3 = MySQLdb.connect("10.1.*.**","root","pass","lag",charset="utf8",init_command='set names utf8')
# 使用cursor()方法获取操作游标 
cursor3 = db3.cursor()
try:
  p3=db3.ping()
except:
  print "tbm-test mysql connect have been close"
  
   
  



# 测试web是否正常函数
def url_request(host,port=80):
  try:
    response = urllib.urlopen(host)
    real_url = response.geturl()
    print "真实的url是：",real_url
    response_code = response.getcode()
    if 200 != response_code:
      return response_code
    else:
      return "正常"
  except :
    return "无法访问"

# 网址访问发送邮件报告
def email_send (useremail,own,web_value,ywecp_cnt,yweurl_cnt,yweurlout_cnt,web_nullinfo,web_nullinfo_cnt):
   a=useremail
   f=own
   d=web_value
   a1=ywecp_cnt
   a2=yweurl_cnt
   a3=yweurlout_cnt
   #配置邮箱
   sender = 'POAM@xxx.com'
   # receiver = ''+a+',c000070@xxx.com'c000070-产品运维部 <c000070@xxx.com>
   receiver = ''+a+',c000070@xxx.com'
      # receiver = ''+a+',c000070@xxx.com'
   # #receiver = 'yonghua.liu@xxx.com'
   # receiver = string.splitfields(receiver, ",")
   
   #receiver = 'yonghua.liu@xxx.com'
   receiver = string.splitfields(receiver, ",")
   print receiver,"----------------"
   subject = f+"工程师的日常巡检简报"+'【' + localtime + '】'
   smtpserver = 'm.xxx.com'
   username = 'POAM'
   password = 'pass'
   print receiver,"------------------------------------"

   #文件内容
   msg = MIMEText("<html><p style='color:#0099FF'><b>尊敬的运维工程师"+str(f)+"，您好：<table border='1'><caption><h4>汇总（不含：准生产环境、非监控产品）</h4></caption><tr><td>产品个数</td><td>总监控网址数</td><td>不可访问网址数</td></tr><tr><td>"+str(a1)+"</td><td>"+str(a2)+"</td><td><p style='color:#FF0000'>"+str(a3)+"</td></tr></table><p></p><hr> <h3><th></th></h3><table border='1'><caption><h4>产品未添加web监控列表（不含:准生产环境、非监控产品、下架）数量:"+str(web_nullinfo_cnt)+"个</h4></caption><tr><td>"+str(web_nullinfo)+"</td></tr></table> <p></p><hr> <h3><th></th></h3><table border='1'><caption><h4>网站状态（不含准生产环境、非监控产品）</h4></caption><tr><th>产品</th><th>网址</th><th>状态</th><h5><tr><td>"+str(d)+"<h5></table></html>",'html','utf-8')
   # print msg,"52000000000000000000000000000000000000000000000"
  #邮件头显示
   msg['Subject'] = subject
   msg['from'] = sender
   msg['to'] =  ','.join(receiver)

   #发送邮件
   try:
      smtp = smtplib.SMTP()
      smtp.connect('m.xxx.com',587)
      smtp.login(username, password)
      smtp.sendmail(sender, receiver, msg.as_string())
      smtp.quit()
      print receiver,"Successfully sent email_URL"
   except Exception, e:  
      print str(e)
# rullib2测试web是否正常函数
def url_request1(host,timeout=3):
  try:
    f = urllib2.urlopen(host, timeout=1)
    result = f.read()
    return result
  except Exception,e:
    return host,str(e)
#web格式化
def value_list(val):
  a=list(val)
  l=len(val)
  b=0
  while b<l:
    c=a[b]
    g=list(c)
    a[b]=g
    b = b + 1
  return a
#web格式化2
def value1(val):
  a=0
  l=len(val)
  while a<l:
    b=val[a]
    c=list(b)
    d=c[0]
    a = a+1
  return d
#web格式化3
def value_lis(weball):
  a=0
  b=weball
  l=len(weball)
  ll=len(weball[0])
  lb=0
  w="</td></tr><tr><td>"
  while a<l:
    c=b[a]
    str_c=('</td><td>'.join(c))
#    print str_c
    e=str(str_c) + ""
    d=e + w
    b[a]=d
    a=a+1
  return b
  
#web格式化4
def value_yw(val):
  ln=0
  l=len(val)
  z=[]
  while ln<l:
    a=val[ln]
    c=a[0]
    d=list(c)
    z=z+d 
    ln=ln+1 
  return z
#web格式化5
def valueyw( val ):
    a = val[0]
    b = a[0]
    return b

def webnull_lis(val):
  a = val
  l = len(val)
  cn = 0
  while cn < l:
    a[cn] = a[cn][0]
    cn = cn + 1
  return a
    
#查询运维ID信息-----------------------------------------------这里修改运维人员名单
try:
  sql7="select GROUP_CONCAT(id) id from users where name in('方淼','黄龙府','江婉怡','龚小芝','尹华雁','李军','王中成','谭飞鸿','黄鑫钢','周小平','郝祥刚') "
  cursor1.execute(sql7)
  yw_id1=cursor1.fetchall()
#  print yw_id1
  yw_id2 = value_list(yw_id1)
  yw_id = (yw_id2[0])[0]
  print yw_id,yw_id2,"yw_id ddddddddddddddddddddddddddddddddddddddd"
except:
  print "查询运维IDsql error"
  

 #格式化运维产品ID
def value_kud(weball):
  a=0
  b=weball
  l=len(weball)
  while a<l:
    c=b[a]
    str_c1=c[0]
    str_c = "\"" + str_c1 +"\""
    b[a] = str_c
    a=a+1
  return b 



try:
  sql8="select b.prod_sku gp from tbm_web_cp a,p_product_info b where a.prod_sku = b.prod_name and b.yw_person in ("+yw_id+") "
  cursor2.execute(sql8)
  yw_gp1=cursor2.fetchall()
#  print yw_id1
  yw_gp2 = value_list(yw_gp1)
  yw_gp3 = value_kud(yw_gp2)
  yw_gp = (",".join(yw_gp3))
  # print yw_gp3,yw_gp,"gpppppppppppppppppppppppppppppppppppppppppppppppppppp"
except:
  print "查询运维yw_gp error"
  
#查询运维主机信息
try:
  sql1="select * from (select u.name yw,u.email, a.prod_sku,b.prod_name,a.ns_inner web ,a.prod_environ ,'ns_inner' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id  and b.prod_enable = 'ENABLED' and b.yw_person in("+yw_id+")  union all select u.name yw,u.email, a.prod_sku,b.prod_name,a.ns_outer web,a.prod_environ ,'ns_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.prod_enable = 'ENABLED' and b.yw_person = u.id and b.yw_person in("+yw_id+") union all select u.name yw,u.email, a.prod_sku,b.prod_name,a.sk_inner web,a.prod_environ ,'sk_inner' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and b.prod_enable = 'ENABLED' and b.yw_person in("+yw_id+")  union all select u.name yw,u.email, a.prod_sku,b.prod_name,a.sk_outer web ,a.prod_environ ,'sk_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and b.prod_enable = 'ENABLED' and b.yw_person in("+yw_id+")) z where z.web is not null and  z.web <> '' and z.prod_environ <> 'QAPRO_ENVIRON'  order by web "
 # #取消准生产环境监控：最后一行and  z.web <> ''后面添加 and z.prod_environ <> 'QAPRO_ENVIRON'
# try:
  # sql1="select * from (select u.name yw,u.email, a.prod_sku,b.prod_name,a.ns_outer web,a.prod_environ ,'ns_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.prod_enable = 'ENABLED' and b.yw_person = u.id and b.yw_person in("+yw_id+") union all select u.name yw,u.email, a.prod_sku,b.prod_name,a.sk_outer web ,a.prod_environ ,'sk_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and b.prod_enable = 'ENABLED' and b.yw_person in("+yw_id+") union all  select u.name yw,u.email, a.prod_sku,b.prod_name,a.domain_name web ,a.prod_environ ,'domain_name' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and b.prod_enable = 'ENABLED' and b.yw_person in("+yw_id+")) z where z.web is not null and  z.web <> '' and z.prod_environ <> 'QAPRO_ENVIRON'  order by web "
  cursor1.execute(sql1)
  pro_value=cursor1.fetchall()
  pro_all = value_list(pro_value)
  print pro_all,"00000000000000000000000000"
except:
  print "查询运维主机信息sql error"
  
#更新web当前状态
try:
  sql2="delete from tbm_web;"
  cursor2.execute(sql2)
  db2.commit()
except:
  print "sq2 delete tbm_web error"

try:
  result_list=[]
  pro_cnt=0
  pro_l = len(pro_all)
#  print "web数是：",pro_l,"开始时间是：",localtime
  while pro_cnt<pro_l:
    w_year = time.strftime('%Y',time.localtime(time.time()))+""
    w_day = time.strftime('%Y-%m-%d',time.localtime(time.time()))+""
    w_time = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+""
    pro_a=pro_all[pro_cnt]
  #  print  pro_cnt,pro_a,"zaaaaaaaaa"
    pro_yw = pro_a[0]
    pro_email = pro_a[1]
    pro_name = pro_a[3]
    pro_iweb = pro_a[4]
    pro_environ = pro_a[5]
    pro_netdir = pro_a[6]
    print pro_yw,pro_email, pro_name ,pro_iweb,pro_netdir,pro_environ,"wwwwwwwwwwwwwwwwwww"
    pro_url = url_request(pro_iweb,port=80)
 #   print pro_url,"3333333333333333333"
    try:
      sql5="insert into tbm_web(w_year,w_yw,w_email,w_day,w_name,w_url,w_type,prod_environ,w_netdir) value('"+str(w_year)+"','"+str(pro_yw)+"','"+str(pro_email)+"','"+str(w_day)+"','"+str(pro_name)+"','"+str(pro_iweb)+"','"+str(pro_url)+"','"+str(pro_environ)+"','"+str(pro_netdir)+"')"
      print sql5
      cursor2.execute(sql5)
      db2.commit()
    except:
      print "插入数据sq2 error"
    pro_cnt = pro_cnt + 1
    print pro_cnt
except:
   print "更新web当前状态----error2"

  
  

#b=[['a1','a2'],['b1','b2']]#b=[['a1'],['b1']]
#f=value_lis(b)

# 查询tbm_web表信息

try:
  sql22="select distinct w_yw from tbm_web;"
  cursor2.execute(sql22)
  yw_value=cursor2.fetchall()
  yw_all = value_list(yw_value)
  yw_n=0
  yw_l=len(yw_all)
  # while yw_n<yw_l:
  while yw_n<yw_l:
# 运维邮箱
    web_yw1=yw_all[yw_n]
    web_yw=web_yw1[0]
    sql220="select distinct w_email from tbm_web where w_yw = '"+str(web_yw)+"';"
    # print sql220,"-----------------------------------"
    try:
      cursor3.execute(sql220)
      ywem=cursor3.fetchall()
      ywemi=ywem[0]
      ywemail=ywemi[0]
      print ywemail,"www--------------------------------ww"
    except:
      print "运维人员邮箱提取错误"
# 运维人员产品
    sqlyw_cp220="select distinct w_name from tbm_web where w_yw = '"+str(web_yw)+"';"
    try:
      cursor3.execute(sqlyw_cp220)
      ywcp3=cursor3.fetchall()
      ln_ywcp3 = len(ywcp3)
      # print ywcp3,"ywcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcpwcp"
    except:
      print "运维人员产品提取错误"
  
# 产品个数、总网址数、不可访问网址

    sql223="select a.cp_cnt,b.url_cnt,c.urlout_cnt from (select count(distinct w_name) cp_cnt from tbm_web where w_yw = '"+str(web_yw)+"' )a,(select count(distinct w_url) url_cnt from tbm_web where w_yw = '"+str(web_yw)+"' )b,(select count(distinct w_url) urlout_cnt from tbm_web where w_type <>'正常' and w_yw = '"+str(web_yw)+"' )c;"
    # print sql223,"sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223"
    try:
      cursor3.execute(sql223)
      ywcnt=cursor3.fetchall()
      ywemi=ywcnt[0]
      ywecp_cnt=ywemi[0]
      yweurl_cnt=ywemi[1]
      yweurlout_cnt=ywemi[2]
      # print ywcnt,ywecp_cnt,yweurl_cnt,yweurlout_cnt,"===========================+"
    except:
      print "运维人员产品个数、总网址数、不可访问网址提取错误"
# 统计无监控地址的产品

    sql124="select prod_name from (select a.prod_name,a.prod_name web0 from  p_product_info a left join  p_product_webinfo b  on a.prod_sku = b.prod_sku  where a.prod_enable ='ENABLED' AND  b.prod_sku is null  and a.yw_person = '"+str(web_yw)+"' union select z.prod_name,GROUP_CONCAT(z.web) web0  from (select u.name yw,u.email, a.prod_sku,b.prod_name,ifnull(a.ns_inner,'') web ,a.prod_environ ,'ns_inner' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and u.name = '"+str(web_yw)+"'  and b.prod_enable = 'ENABLED'  union all select u.name yw,u.email, a.prod_sku,b.prod_name,ifnull(a.ns_outer,'') web,a.prod_environ ,'ns_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and u.name = '"+str(web_yw)+"' and b.prod_enable = 'ENABLED'  union all select u.name yw,u.email, a.prod_sku,b.prod_name,ifnull(a.sk_inner,'') web,a.prod_environ ,'sk_inner' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and u.name = '"+str(web_yw)+"'  and b.prod_enable = 'ENABLED'  union all select u.name yw,u.email, a.prod_sku,b.prod_name,ifnull(a.sk_outer,'') web ,a.prod_environ ,'sk_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and u.name = '"+str(web_yw)+"'  and b.prod_enable = 'ENABLED'  union all select u.name yw,u.email, a.prod_sku,b.prod_name,ifnull(a.domain_name,'') web ,a.prod_environ ,'sk_outer' w_netdir from p_product_webinfo a,p_product_info b ,users u where a.prod_sku = b.prod_sku and b.yw_person = u.id and u.name = '"+str(web_yw)+"' and b.prod_enable = 'ENABLED' ) z GROUP BY z.prod_name having web0 =',,,,') z "
    # print sql223,"sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223sql223"
    try:
      cursor1.execute(sql124)
      web_null3=cursor1.fetchall()
      web_null2=value_list(web_null3)
      web_nullinfo_cnt = len(web_null2)
      web_nullinfo1 = webnull_lis(web_null2)
      web_nullinfo = ('</td><td>'.join(web_nullinfo1))
      print web_null2,"-------------",web_nullinfo1,web_nullinfo,"无监控地址的产品=================================+"
    except:
      print "无监控地址的产品提取错误" 
# 产品信息
    sql221="select w_name,w_url,w_type from tbm_web where w_yw = '"+str(web_yw)+"'  group by w_url order by w_type,w_name;"
    print sql221
    cursor2.execute(sql221)
    web_value=cursor2.fetchall()
   # print web_value
    web_all3 = value_list(web_value)
   # print web_all3
    web_all2 = value_lis(web_all3)
    web_all = (''.join(web_all2))
    print web_all2,"www========================================wwwwwwwwwww"
    email_send(ywemail,web_yw,web_all,ln_ywcp3,yweurl_cnt,yweurlout_cnt,web_nullinfo,web_nullinfo_cnt)
    yw_n=yw_n +1
except:
  print "获取bpm_web表信息异常"


lasttime1 = time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time()))+""
print "开始时间为：", localtime,"最后时间为：", lasttime1



#---待测试运维名称