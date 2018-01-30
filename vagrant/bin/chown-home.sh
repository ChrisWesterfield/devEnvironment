#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
cd /home/vagrant
sudo chown -R vagrant:vagrant .{a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}*  > /dev/null 2>&1
echo "done"