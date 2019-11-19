from numpy import *
import numpy as np
import os,sys
def convert(filename,flag_dir,output_dir,flag_output_dir):
        dir_args=os.path.join(output_dir,filename)
	output_data=np.loadtxt(open(dir_args))
        temp=filename.split('.')
        tmp=temp[0]
#        temp2=args.split('_')
#        tmp2=temp2[0]
#        tmp3=temp2[1]
#	flag_dir="/home/huanghe/"
        flag_name=os.path.join(flag_dir,filename)
        flag_data=np.loadtxt(open(flag_name))
#        s=len(flag_data)
#	ss=s*(s-1)/2
        s1=flag_data.shape[0]
        s2=flag_data.shape[1]
        ss=s1*s2
	result_dir=os.path.join(flag_output_dir,tmp+'.txt')
        for i in range(s1):
		for j in range(s2):
			f=open(result_dir,'a')
			flag=flag_data[i][j]
			x=i+1
			y=j+1
			newline=str(flag)+'\n'
			f.write(newline)
#			f.write('/n')
               

if __name__=="__main__":
	output_dir='./true_contact_matrix'
	flag_dir='./true_contact_matrix'
	flag_output_dir='./output_result'
        for filename in os.listdir(output_dir):
                convert(filename,flag_dir,output_dir,flag_output_dir)

