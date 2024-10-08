
count=0;
startrepit=1;
 repicount=zeros(5,1);
for repit = 1000:1000:5000

 repi=0;

    for image = 1:100
        filename = sprintf('%d_Rep(%d).jpg', repit, image);  
        path=fullfile('C:\Users\User\Downloads\HWTBench2023-main\Images\train\common',filename);
         if exist(path, 'file') == 2
             count=count+1;
             repi=repi+1;
             
         end
    end
    repicount(startrepit,:)=repi;
    startrepit=startrepit+1;
end
run=1;
x_new_input=zeros(count,44);
         
y_class_p=zeros(count,1);

for repit = 1000:1000:5000
    for image = 1:100
        filename = sprintf('%d_Rep(%d).jpg', repit, image);  
        path=fullfile('C:\Users\User\Downloads\HWTBench2023-main\Images\train\common',filename);
         if exist(path, 'file') == 2
             disp(filename); 
            img=imread(path);
            img = imresize(img, [16 16]);
            
           dims = size(img);
            third = dims(3);    
            f=struct();
            
                                 filter1_x = [-1 0 1 0 0;
                               -2 0 2 0 0;
                               -1 0 1 0 0;
                                0 0 0 0 0;
                                0 0 0 0 0];

                    filter1_y = [-1 -2 -1 0 0;
                                0  0  0 0 0;
                                1  2  1 0 0;
                                0  0  0 0 0;
                                0  0  0 0 0];
                            
                            f.filter1=sqrt(filter1_x.^2+filter1_y.^2);
                        filter2_x = [-1 0 1 0 0;
                                 -1 0 1 0 0;
                                 -1 0 1 0 0;
                                  0 0 0 0 0;
                                  0 0 0 0 0];

                    filter2_y = [-1 -1 -1 0 0;
                                  0  0  0 0 0;
                                  1  1  1 0 0;
                                  0  0  0 0 0;
                                  0  0  0 0 0];

                     f.filter2=sqrt(filter2_x.^2+filter2_y.^2);
                               
                    filter3_x = [-3 0 3 0 0;
                               -10 0 10 0 0;
                                -3 0 3 0 0;
                                 0 0 0 0 0;
                                 0 0 0 0 0];

                    filter3_y = [-3 -10 -3 0 0;
                                0   0   0 0 0;
                                3   10  3 0 0;
                                0   0   0 0 0;
                                0   0   0 0 0];
                            
                     f.filter3=sqrt(filter3_x.^2+filter3_y.^2);
                      

                    f.filter4 = [1  4  6  4  1;
                                4 16 24 16  4;
                                6 24 36 24  6;
                                4 16 24 16  4;
                                1  4  6  4  1] / 256;

                    f.filter5 = [0  0 -1  0  0;
                                 0 -1 -2 -1  0;
                                -1 -2 16 -2 -1;
                                 0 -1 -2 -1  0;
                                 0  0 -1  0  0];
               filters=5;
               for start=1:filters
                   
                       filterName = sprintf('filter%d', start);
                       cf=f.(filterName);
                       
                       sum=0;
                    for chan=1:third
                        so_mag(:,:,chan)=conv2(img(:,:,chan), double(cf), 'valid');
                         sum=sum+so_mag(:,:,chan);
                    end
                    assign_matrix(:,:,start)=sum;
               end
               
               relu_activated = max(0, assign_matrix);
                disp('relu');
                
                [m, n, p] = size(relu_activated);
                pooled_matrix = zeros(floor(m/2), floor(n/2), p);           
                
                for k = 1:p
                    for i = 1:2:m-1
                        for j = 1:2:n-1
                            pooled_matrix((i+1)/2, (j+1)/2, k) = mean(mean(relu_activated(i:i+1, j:j+1, k)));
                        end
                    end
                end
                
                 dims = size(pooled_matrix);
                 
                    
                    third = dims(3);
                    
                                      
                                    f.filter1 = [-1 -2  0  2  1;
                                                 -1 -2  0  2  1;
                                                 -1 -2  0  2  1;
                                                 -1 -2  0  2  1;
                                                 -1 -2  0  2  1];

                                   
                                    f.filter2 = [-1 -1 -1 -1 -1;
                                                 -2 -2 -2 -2 -2;
                                                  0  0  0  0  0;
                                                  2  2  2  2  2;
                                                  1  1  1  1  1];

                                    f.filter3 = [1  4  6  4  1;
                                                 4 16 24 16  4;
                                                 6 24 36 24  6;
                                                 4 16 24 16  4;
                                                 1  4  6  4  1] / 256;

                                   
                                    f.filter4 = [ 0  0 -1  0  0;
                                                  0 -1 -2 -1  0;
                                                 -1 -2 16 -2 -1;
                                                  0 -1 -2 -1  0;
                                                  0  0 -1  0  0];

                                   
                                    f.filter5 = [ 0  0  1  0  0;
                                                  0  1  2  1  0;
                                                  1  2 -16  2  1;
                                                  0  1  2  1  0;
                                                  0  0  1  0  0];

                                   
                                    f.filter6 = [1 1 1 1 1;
                                                 0 0 0 0 0;
                                                 0 0 0 0 0;
                                                 0 0 0 0 0;
                                                 0 0 0 0 0] / 5;

                                    
                                    f.filter7 = [1 0 0 0 0;
                                                 1 0 0 0 0;
                                                 1 0 0 0 0;
                                                 1 0 0 0 0;
                                                 1 0 0 0 0] / 5;

                                    
                                    f.filter8 = [1 1 1 1 1;
                                                 1 1 1 1 1;
                                                 1 1 1 1 1;
                                                 1 1 1 1 1;
                                                 1 1 1 1 1] / 25;

                                   
                                    f.filter9 = [-1 -1 -1 -1 -1;
                                                  0  0  0  0  0;
                                                  1  1  1  1  1;
                                                  0  0  0  0  0;
                                                 -1 -1 -1 -1 -1];

                                    
                                    f.filter10 = [-1 -1 -1 -1 -1;
                                                  -1  9  9  9 -1;
                                                  -1  9  24 9 -1;
                                                  -1  9  9  9 -1;
                                                  -1 -1 -1 -1 -1];

                                    
                                    f.filter11 = [-2 -1  0  1  2;
                                                  -1  0  1  0 -1;
                                                   0  1  0 -1  0;
                                                  -1  0 -1  0 -1;
                                                  -2 -1  0  1  2];

                                                                     
                                   filters=11;
                                   for start=1:filters

                                           filterName = sprintf('filter%d', start);
                                           cf=f.(filterName);

                                           sum=0;
                                        for chan=1:third
                                            so_mag1(:,:,chan)=conv2(pooled_matrix(:,:,chan), double(cf), 'same');
                                             sum=sum+so_mag1(:,:,chan);
                                        end
                                        assign_matrix1(:,:,start)=sum;
                                   end
             
                                                                             [m, n, p] = size(assign_matrix1);
                                    pooled_matrix = zeros(floor(m/3), floor(n/3), p); 

                                    for k = 1:p
                                        for i = 1:3:m-2
                                            for j = 1:3:n-2
                                                
                                                region = assign_matrix1(i:i+2, j:j+2, k);

                                               
                                                pooled_matrix(ceil(i/3), ceil(j/3), k) = max(region(:));
                                            end
                                        end
                                    end
                
                                   x_new_input(run,:) = (pooled_matrix(:)');              
                                   run=run+1;
               
            
         else
             
         end
         
       
    end
end



for assignclass=1:count
    if (assignclass<=repicount(1,1))
        y_class_p(assignclass,1)=1;
    else
        y_class_p(assignclass,1)=0;
    end
    
end 

correlation_matrix=zeros(44,1);
  for k=1:44
  correlation_matrix(k,1)=corr(x_new_input(:,k),y_class_p);
  end
  
  a=0;b=0;c=0;d=0;e=0;
  for k=1:44
      if abs((correlation_matrix(k,1)))>0.1 && abs((correlation_matrix(k,1)))<0.2
          a=a+1;
      elseif abs((correlation_matrix(k,1)))>0.2  && abs((correlation_matrix(k,1)))<0.3
              b=b+1;
          elseif abs((correlation_matrix(k,1)))>0.3  && abs((correlation_matrix(k,1)))<0.4
              c=c+1;
           elseif abs((correlation_matrix(k,1)))>0.4 && abs((correlation_matrix(k,1)))<0.5
              d=d+1;
            elseif abs((correlation_matrix(k,1)))>0.5
              e=e+1;
      end
  end
  
  
i=1;
  
    for j = 1:44
    if abs(correlation_matrix(j,1))>0.1  
        new_matx(:,i) = x_new_input(:,j);  
        i = i + 1;  
    end
    end
    
    
  constant_columns = find(var(new_matx) == 0);
new_matx(:, constant_columns) = [];


[rowb,colb]=size(x_new_input);
newc=1;
for colrun=1:colb
    if var(x_new_input(:,colrun))==0
        new_matx_myip(:,newc) = x_new_input(:,colrun);
        newc=newc+1;
    end
end
% 





x_new_input=x_new_input(1:229,:);
y_class_p=y_class_p(1:229,:);
y_class_p=y_class_p+1;

 options = statset('MaxIter', 2000);
bias = mnrfit(zscore(x_new_input), y_class_p);


c1=repicount(1,1);
c2=repicount(1,1)+repicount(2,1);
c3=c2+repicount(3,1);

c4=c3+repicount(4,1);%postponed.
c5=c4+repicount(5,1);;



for assignclass=1:count
    if (assignclass>c2 && assignclass<=c3)
        y_class_third(assignclass,1)=1;
    else
        y_class_third(assignclass,1)=0;
    end
    
end

for assignclass=1:count
    if (assignclass>c1 && assignclass<=c2)
        y_class_t(assignclass,1)=1;
    else
        y_class_t(assignclass,1)=0;
    end
    
end

for assignclass=1:count
    if (assignclass>c3 && assignclass<=c4)
        y_class_fo(assignclass,1)=1;
    else
        y_class_fo(assignclass,1)=0;
    end
    
end

for assignclass=1:count
    if (assignclass>c4 && assignclass<=c5)
        y_class_fi(assignclass,1)=1;
    else
        y_class_fi(assignclass,1)=0;
    end
    
end

x_new_input=x_new_input(1:229,:);
 y_class_t= y_class_t(1:229,:);
 y_class_t= y_class_t+1;
bias1=mnrfit(zscore(x_new_input), y_class_t);
[~,ypredt]=max(mnrval(bias1,zscore(x_new_input)),[],2);

x_new_input=x_new_input(1:229,:);
 y_class_third= y_class_third(1:229,:);
 y_class_third= y_class_third+1;
bias2=mnrfit(zscore(x_new_input), y_class_third);
[~,ypredthird]=max(mnrval(bias1,zscore(x_new_input)),[],2);
    
y_class_fo=y_class_fo+1;
bias3=mnrfit(zscore(x_new_input), y_class_fo);
[~,ypredfo]=max(mnrval(bias3,zscore(x_new_input)),[],2);

y_class_fi=y_class_fi+1;
bias4=mnrfit(zscore(x_new_input), y_class_fi);
[~,ypredfi]=max(mnrval(bias4,zscore(x_new_input)),[],2);










