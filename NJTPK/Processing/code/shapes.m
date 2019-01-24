%% seperate different shapes of motion of the cross section
%% Load data text file
[dat_name, fname] = uigetfile('.txt');
dat_file = file();
dat_file.name = dat_name; 
dat_file.path = fname;

dat_raw = dlmread(dat_file.fullname);

dat = dat_raw(:,2:end);

addpath(genpath('C:\Users\John B\Projects_Git\vma'));
tt = convert_datetime(dat_raw(:,1));

%% Compute CPSD
%% Compute mode shapes
% Compute spectral densities
fs = 3200;
navg = 20;
perc_overlap = 25;
addpath(genpath('C:\Users\John B\Projects_Git\vma'));
[pxy,ff] = vibs.getcpsd(dat,1:8,navg,perc_overlap,[],fs);
plot(ff,real(permute(pxy(:,2,:),[3 1 2])))
% Generate CMIF
cm = cmif(real(pxy),ff);
cm.bnds = [0 60];
cm.plot
% Choose poles
peaks = [15 16 18 24.7 26.2 28.8 29.4 30.4 31.3 38.7 42.2 43.3 ];
for jj=1:length(peaks)
    peak_ind(jj) = find(cm.f-peaks(jj)>=0,1,'first');
end
cm.peakid = peak_ind';
cm.rank = ones(size(cm.peakid));
cm.sort_peaks();

mode=1;
sxn_dat = [zeros(1,size(cm.UU,1)); cm.UU(:,:)'];

%% Plot cross section
% build nodal coordinates
sxn_dat = [zeros(1,size(disp,2)); disp];
flange_width = 10;
beam_depth = 36;
stringer_offset = 3;
stringer_elev = 6;
num_points = 10;
scale = 100;

coords_base = [-flange_width 0; 0 0; flange_width 0; -flange_width -beam_depth; 0 -beam_depth; flange_width -beam_depth;...
    -stringer_offset stringer_elev; stringer_offset stringer_elev];
nodx = -sxn_dat(:,[3 3 3 6 6 6 5 1]);
nody = [sxn_dat(:,4) mean(sxn_dat(:,[7 8]),2) sxn_dat(:,[2 8]) mean(sxn_dat(:,[7 8]),2) sxn_dat(:,[7 4 2])]; 
clear cartesian_dat
cartesian_dat(:,:,1) = nodx*scale+repmat(coords_base(:,1)',size(sxn_dat,1),1);
cartesian_dat(:,:,2) = nody*scale+repmat(coords_base(:,2)',size(sxn_dat,1),1);
clear lx ly
for modes=1:size(sxn_dat,1)
    %create vectors that define line plots
    c_dat = permute(cartesian_dat(modes,:,:),[2 3 1]);
    lx{1,modes} = [c_dat(7,1) c_dat(7,1)-2*flange_width];
    ly{1,modes} = [c_dat(7,2) c_dat(7,2)];
    lx{2,modes} = [c_dat(8,1) c_dat(8,1)+2*flange_width];
    ly{2,modes} = [c_dat(8,2) c_dat(8,2)];
    lx{3,modes} = linspace(c_dat(1,1),c_dat(3,1),num_points);
    ly{3,modes} = polyval(polyfit(c_dat([1 2 3],1),c_dat([1 2 3],2),2),lx{3});
    lx{4,modes} = c_dat([2 5],1);
    ly{4,modes} = c_dat([2 5],2);
    lx{5,modes} = c_dat([4 6],1);
    ly{5,modes} = c_dat([4 6],2);
end

%plot base sxn
figure
for ii = 1:size(lx,1)
    base_lh(ii) = line(lx{ii,1},ly{ii,1});
end

%plot deformation
for ii = 1:size(lx,1)
    lh(ii) = line(lx{ii,1},ly{ii,1},'color','red');
end
for jj=2:10:size(lx,2)
    % refresh lines
    for ii = 1:length(lh)
        lh(ii).XData = lx{ii,jj};
        lh(ii).YData = ly{ii,jj};
        drawnow
    end
    pause(0.001)
end

%% try with displacement
%% lets look at displacement
% Because of the sensors used and the nature of the loading...
% Accel data is not below 0.5Hz or above 2KHz
% Therefore we will only examine the displacement caused by vibrations
% between 1 and 60 Hz
dt = 1/fs;
dat_imp = dat*386.09;
freq_bounds =[0.5 60]; %Hz
event_inds = [1581379 1597119]
clear disp A
for ii = 1:size(dat,2)
 [disp(:,ii) A(:,ii)] = iomega_freq(dat_imp(event_inds(1):event_inds(2),ii),dt,3,1,freq_bounds);
end

figure

p3 = abs(A/ll);
p4 = p3(1:floor(ll/2)+1,:);
p4(2:end-1) = 2*p4(2:end-1);
plot(ff,p4(:,chan_inds))
xlabel('Frequency (Hz)');
ylabel('(in)');
legend(num2str(chan_inds'))
xlim([0.5 10])

figure
plot(disp)
ylabel('displacement (in)');
legend(num2str(chan_inds'))

%% identify maximum shape conditions
% top flange bending
[val ind1] = max(abs(mean(disp(:,[2 4]),2)-mean(disp(:,[7 8]),2)))
[val ind2] = max(abs(diff(disp(:,[2 4]),1,2)-diff(disp(:,[7 8]),1,2)));


%plot base sxn
n=1;
h = figure;
for ii = 1:size(lx,1)
    base_lh(ii) = line(lx{ii,1},ly{ii,1});
end
th = text(5,-15,num2str(dt,4));
for jj = (1):32:(4*fs) %size(lx,2)
    %plot deformation
    
    for ii = 1:size(lx,1)
        if n==1 
            lh(ii) = line(lx{ii,jj},ly{ii,jj},'color','red');
            
        else
            lh(ii).XData = lx{ii,jj};
            lh(ii).YData = ly{ii,jj};
            th.String = num2str((jj-1)*dt,4);
        end
    end
    drawnow
    pause
    
    % Capture the plot as an image 
      frame = getframe(h); 
      im{n} = frame2im(frame); 
     n=n+1;
end

imfname = 'testAnimated.gif'; % Specify the output file name
delay = dt*32*2;
for idx = 1:length(im)
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,imfname,'gif','LoopCount',Inf,'DelayTime',delay);
    else
        imwrite(A,map,imfname,'gif','WriteMode','append','DelayTime',delay);
    end
end

%displacement of top and bottom flanges
h = figure;
for ii = 1:size(lx,1)
    base_lh(ii) = line(lx{ii,1},ly{ii,1});
    lh(ii) = line(lx{ii,1},ly{ii,1},'color','red');
end
 sec_inds = [1.91 1.99 3.18]*fs;
for ii = 1:size(lx,1)
    lh(ii).XData = lx{ii,sec_inds(3)};
    lh(ii).YData = ly{ii,sec_inds(3)};
end
text(
drawnow
plot(mean(dat(:,[2 4]),2)-mean(dat(:,[7 8]),2))