clear;
close all;
clc;
fin = fopen('CAFFE_LOG.txt.test');
count = 0;
while ~feof(fin)
	tline = fgetl(fin);
	if count > 0
		S = textscan(tline,'%s %s %s %s');
		iters(count, 1) = str2num(S{1,1}{1,1});
		Acc(count, 1)   = str2num(S{1,3}{1,1});
	end
	count = count + 1;
end
subplot(2,2,1)
plot(iters, Acc);
xlabel('iter', 'Fontsize',20);
ylabel('Accuracy','Fontsize',20);

clear;
fin = fopen('CAFFE_LOG.txt.test');
count = 0;
while ~feof(fin)
	tline = fgetl(fin);
	if count > 0
		S = textscan(tline,'%s %s %s %s');
		iters(count, 1) = str2num(S{1,1}{1,1});
		Acc(count, 1)   = str2num(S{1,4}{1,1});
	end
	count = count + 1;
end
subplot(2,2,2)
plot(iters, Acc);
xlabel('iter', 'Fontsize',20);
ylabel('Testing Loss','Fontsize',20);

clear
fin = fopen('CAFFE_LOG.txt.train');
count = 0;
while ~feof(fin)
	tline = fgetl(fin);
	if count > 0
		S = textscan(tline,'%s %s %s %s');
		iters(count, 1) = str2num(S{1,1}{1,1});
		loss(count, 1)   = str2num(S{1,3}{1,1});
	end
	count = count + 1;
end
subplot(2,2,3)
plot(iters(1:10:end), loss(1:10:end));

xlabel('iter', 'Fontsize',20);
ylabel('Training Loss','Fontsize',20);
print('-depsc','loss_without_ignore.eps')
