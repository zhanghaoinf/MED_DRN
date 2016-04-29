clear;
close all;
clc;
testFile = './Attempt_1/CAFFE_LOG.txt.test';
count = 0;
[NumIters, Seconds, LearnRate, Acc, Loss] = textread(testFile,'%s%s%s%s%s','delimiter',',');
iters = str2double(NumIters(2:length(NumIters)));
tstAcc = str2double(Acc(2:length(Acc)));
tstLoss = str2double(Loss(2:length(Loss)));
subplot(2,2,1)
plot(iters, tstAcc);
xlabel('iter', 'Fontsize',20);
ylabel('Accuracy','Fontsize',20);

subplot(2,2,2)
plot(iters, tstLoss);
xlabel('iter', 'Fontsize',20);
ylabel('Testing Loss','Fontsize',20);

trnFile = './Attempt_1/CAFFE_LOG.txt.train';
[NumIters, Seconds, LearnRate, Loss] = textread(trnFile,'%s%s%s%s','delimiter',',');
iters = str2double(NumIters(2:length(NumIters)));
trnLoss = str2double(Loss(2:length(Loss)));
subplot(2,2,3)
plot(iters, trnLoss);

xlabel('iter', 'Fontsize',20);
ylabel('Training Loss','Fontsize',20);
print('-depsc','./Attempt_1/loss_without_ignore.eps')
