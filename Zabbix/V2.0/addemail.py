#coding: utf-8
import smtplib
from email.mime.text import MIMEText
import time
import string




#获取时间
localtime = time.asctime( time.localtime(time.time()) )

#配置邮箱
sender = 'POAM@fe.com'
receiver = 'yonghua.liu@fe.com,252491900@qq.com'
receiver = string.splitfields(receiver, ",")
subject = '已正常添加产品监控【' + localtime + '】'
smtpserver = 'm.fe.com'
username = 'POAM'
password = '!@#2015'

#文件内容
msg = MIMEText("<html><p>"+str(receiver)+"ok</p></html>",'html','utf-8')

#邮件头显示
msg['Subject'] = subject
msg['from'] = sender
msg['to'] =  ','.join(receiver)

#发送邮件
try:
    smtp = smtplib.SMTP()
    smtp.connect('m.fe.com')
    smtp.login(username, password)
    smtp.sendmail(sender, receiver, msg.as_string())
    smtp.quit()
    print "Successfully sent email"
except Exception, e:  
    print str(e)