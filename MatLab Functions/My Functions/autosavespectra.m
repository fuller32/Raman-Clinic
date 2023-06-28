close all; clear all;clc;
test = 0
myspectrometersGUI
load('input.mat','g')
Db = eval(g)
prompt = {'File Name'};
dlgtitle = 'Input';
dims = [1 35];
phi=0;
definput = {''};
Name = inputdlg(prompt,dlgtitle,dims,definput);
