function toplexon(num)          % CES 2/22/12
if(num<15625)                   % Sends any number 0-15624 (inclusive) to Plexon with a timestamp
    daq=DaqDeviceIndex;         % To access data:
    DaqDConfigPort(daq(1),0,0);
    DaqDOut(daq,0,(2^5));       % 1) Have PlexControl send EVT01-EVT06 to Matlab
    pause(0.000001);          	% 2) Save Matlab Workspace as .mat
    DaqDOut(daq,0,0);           % 3) 'load' .mat
    pause(0.000001);            % 4) Run 'getstrobes()' on EVT01-EVT06
    base5 = str2num(dec2base(num, 5));
    evt(1) = floor(base5/100000);
    evt(2) = floor((base5-(evt(1)*100000))/10000);
    evt(3) = floor((base5-((evt(1)*100000)+(evt(2)*10000)))/1000);
    evt(4) = floor((base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)))/100);
    evt(5) = floor((base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)+(evt(4)*100)))/10);
    evt(6) = base5-((evt(1)*100000)+(evt(2)*10000)+(evt(3)*1000)+(evt(4)*100)+(evt(5)*10));
    for i=1:6
        if(evt(i)==0), DaqDOut(daq,0,(2^0));end
        if(evt(i)==1), DaqDOut(daq,0,(2^1));end
        if(evt(i)==2), DaqDOut(daq,0,(2^2));end
        if(evt(i)==3), DaqDOut(daq,0,(2^3));end
        if(evt(i)==4), DaqDOut(daq,0,(2^4));end
        pause(0.000001);
        DaqDOut(daq,0,0);
        pause(0.000001);
    end
else
    disp('toplexon needs a smaller #!');
end
end