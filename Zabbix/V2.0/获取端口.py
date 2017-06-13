#coding: utf-8


import re
 
line1 = "net.tcp.port[210.75.17.217,18087]"
line2 = "net.tcp.listen[80]"
 
matchObj1 = re.findall(r'\d+',line2,re.M)
matchObj2 = re.findall(r'(?<=\,)\d+(?=\])',line1)
b=matchObj2[0]
a= matchObj1[-1]
print "port: ", a
 
print "port: ", b