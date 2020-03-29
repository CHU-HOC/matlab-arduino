if exist('s','var')
    fclose(s);
    delete(s)
    clear s
end

clear;
clc;

FolderPath = 'F:\Last_Ausgabe\';
Name='_Last_LKW_';

s = serial('COM6');

set(s,'BaudRate',115200,'Terminator','LF','Parity','None');

fopen(s);
s1.BytesAvailableFcnMode = 'terminator';


AbstandData=zeros();
in=zeros();

LKW_Counter = 0;

DateStringInitialized = false;

 
while(1)

ind = [];

 if(s.BytesAvailable >0  )  %check byte from Arduino 
    
     AbstandData=[];
     LKW_Counter =LKW_Counter+1;
         
    while( isempty(ind)  )   %receive untill end mark   
  
        if(~DateStringInitialized)
            dtstr= datestr(now,'yyyy-mm-dd_HH.MM.SS');
            DateStringInitialized  = true;
        end
        
        in=fgetl(s);
        disp(in)
    
        AbstandData = [AbstandData, in];
       
        ind=strfind(in,'-777');
    end
    
    disp('Datei gespeichert')
    
    %pathstr='C:\\Users\khalaf\Desktop\Test\';

    filename = sprintf('%s%s%s%d%s',FolderPath,dtstr,Name,LKW_Counter,'.txt');

    %filename = strrep(filename,' ','');
    
    disp(filename)

    dlmwrite(filename,AbstandData,'')
  
    flushinput(s);
 end % end if check byte from Arduino 
end % end while receive untill end mark 

 fclose(s);
 delete(s)
 clear s

