[dat_name, fname] = uigetfile('.txt');
dat_file = file();
dat_file.name = dat_name; 
dat_file.path = fname;

dat_raw = dlmread(dat_file.fullname);
fs = 3200;

dat = dat_raw(:,2:end);

%% lets look at displacement
% Because of the sensors used and the nature of the loading...
% Accel data is not below 0.5Hz or above 2KHz
% Therefore we will only examine the displacement caused by vibrations
% between 1 and 60 Hz
dt = 1/fs;
dat_imp = dat*386.09;
freq_bounds =[10 100]; %Hz
event_inds = [874488 889886];
clear disp A
for ii = 1:size(dat,2)
 [disp(:,ii) A(:,ii)] = iomega_freq(dat_imp(event_inds(1):event_inds(2),ii),dt,3,1,freq_bounds);
end

%% Plot cross section
% build nodal coordinates
sxn_dat = [zeros(1,size(disp,2)); disp];
flange_width = 6;
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
    lx{1,modes} = [c_dat(7,1) c_dat(7,1)-1.5*flange_width];
    ly{1,modes} = [c_dat(7,2) c_dat(7,2)];
    lx{2,modes} = [c_dat(8,1) c_dat(8,1)+1.5*flange_width];
    ly{2,modes} = [c_dat(8,2) c_dat(8,2)];
    lx{3,modes} = linspace(c_dat(1,1),c_dat(3,1),num_points);
    ly{3,modes} = polyval(polyfit(c_dat([1 2 3],1),c_dat([1 2 3],2),2),lx{3});
    lx{4,modes} = c_dat([2 5],1);
    ly{4,modes} = c_dat([2 5],2);
    lx{5,modes} = c_dat([4 6],1);
    ly{5,modes} = c_dat([4 6],2);
end

%plot base sxn
n=1;
h = figure;
for ii = 1:size(lx,1)
    base_lh(ii) = line(lx{ii,1},ly{ii,1});
end
th = text(9,-37,[num2str(dt,4) 'sec']);
ylabel('deformation x100 [in]');
xticks([]);
axis manual
xlim([-13 13]); ylim([-40 10]);
for jj = (2.1*fs):32:(3.1*fs) %size(lx,2)
    %plot deformation
    
    for ii = 1:size(lx,1)
        if n==1 
            lh(ii) = line(lx{ii,jj},ly{ii,jj},'color','red');
            
        else
            lh(ii).XData = lx{ii,jj};
            lh(ii).YData = ly{ii,jj};
        end
    end
   th.String = [num2str((jj)*dt-2.1,4) ' sec'];

    drawnow
    pause(0.03)
    
    % Capture the plot as an image 
      frame = getframe(h); 
      im{n} = frame2im(frame); 
     n=n+1;
end

imfname = 'sxn_event1.gif'; % Specify the output file name
delay = dt*32*8;
for idx = 1:length(im)
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,imfname,'gif','LoopCount',Inf,'DelayTime',delay);
    else
        imwrite(A,map,imfname,'gif','WriteMode','append','DelayTime',delay);
    end
end
