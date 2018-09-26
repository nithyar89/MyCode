%Nithya Ramakrishnan 07/09/2018
clear;clc;
addpath('/raid5/rcho/PSYCH_CFC/MEG_raw_data/scripts/mne/MNE-2.7.3-3268-Linux-x86_64/share/matlab/')
mridir='/raid5/rcho/PSYCH_CFC/fMRI/';
fstest='/RAW/fs_test/';
stcpath='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/functional_label/stc/';

chronic40path='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/ASSR_Paper/data/timefreq_updatesJune2018/pca_testing/chronic40/';
chronic40_l=dir([chronic40path,'s*left.mat']);
chronic40_r=dir([chronic40path,'s*right.mat']);

early40path='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/ASSR_Paper/data/timefreq_updatesJune2018/pca_testing/early40/';
early40_l=dir([early40path,'s*left.mat']);
early40_r=dir([early40path,'s*right.mat']);

control40path='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/ASSR_Paper/data/timefreq_updatesJune2018/pca_testing/controls40/';
control40_l=dir([control40path,'h*left.mat']);
control40_r=dir([control40path,'h*right.mat']);


CR_l={chronic40_l.name}';
EA_l={early40_l.name}';
HC_l={control40_l.name}';

CR_r={chronic40_r.name}';
EA_r={early40_r.name}';
HC_r={control40_r.name}';

for iter = 1:length(CR_l)
    a = [chronic40path, CR_l{iter}];
    load(a)
    candidate1=output.mask.origROI;
    candidate2=output.mask.elbowROI;
    candidate3=output.mask.clusterROI;
    candidate4=output.mask.toptenROI;
    candidate5=output.mask.VertCorROI;
    candidate6=output.mask.SurrStatsROI;
    
    ID=a(end-15:end-13);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_lh_xyz = read_label(CID, 'lh.superiortemporal');
    transversetemp_lh_xyz = read_label(CID, 'lh.transversetemporal');
    both_lh_xyz=[superiortemp_lh_xyz; transversetemp_lh_xyz];
    
    anat_lh=mne_read_stc_file([stcpath ID '_anat-40hz-lh-lh.stc']);
    vertices_lh_1=anat_lh.vertices([candidate1'],:);
    vertices_pca_lh_xyz_1 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_1),:);
    vertices_lh_2=anat_lh.vertices([candidate2'],:);
    vertices_pca_lh_xyz_2 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_2),:);
    vertices_lh_3=anat_lh.vertices([candidate3'],:);
    vertices_pca_lh_xyz_3 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_3),:);
    vertices_lh_4=anat_lh.vertices([candidate4'],:);
    vertices_pca_lh_xyz_4 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_4),:);
    vertices_lh_5=anat_lh.vertices([candidate5'],:);
    vertices_pca_lh_xyz_5 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_5),:);
    vertices_lh_6=anat_lh.vertices([candidate6'],:);
    vertices_pca_lh_xyz_6 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_6),:);
    
    vertices_all_lh = anat_lh.vertices;
    vertices_all_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1),vertices_all_lh),:);
    
    if iter==1;
        cr_vert_all_l= vertices_all_lh_xyz;
        cr_both_lh_xyz=both_lh_xyz;
        
        cr_vert_pca_l_1= vertices_pca_lh_xyz_1;
        cr_vert_pca_l_2= vertices_pca_lh_xyz_2;
        cr_vert_pca_l_3= vertices_pca_lh_xyz_3;
        cr_vert_pca_l_4= vertices_pca_lh_xyz_4;
        cr_vert_pca_l_5= vertices_pca_lh_xyz_5;
        cr_vert_pca_l_6= vertices_pca_lh_xyz_6;
        
    else
        cr_vert_all_l= [cr_vert_all_l;vertices_all_lh_xyz];
        cr_both_lh_xyz= [cr_both_lh_xyz;both_lh_xyz];
        
        cr_vert_pca_l_1= [cr_vert_pca_l_1;vertices_pca_lh_xyz_1];
        cr_vert_pca_l_2= [cr_vert_pca_l_2;vertices_pca_lh_xyz_2];
        cr_vert_pca_l_3= [cr_vert_pca_l_3;vertices_pca_lh_xyz_3];
        cr_vert_pca_l_4= [cr_vert_pca_l_4;vertices_pca_lh_xyz_4];
        cr_vert_pca_l_5= [cr_vert_pca_l_5;vertices_pca_lh_xyz_5];
        cr_vert_pca_l_6= [cr_vert_pca_l_6;vertices_pca_lh_xyz_6];
                  
    end
    
end

for iter = 1:length(CR_r)
    a = [chronic40path, CR_r{iter}];
    load(a)
    candidate1=output.mask.origROI;
    candidate2=output.mask.elbowROI;
    candidate3=output.mask.clusterROI;
    candidate4=output.mask.toptenROI;
    candidate5=output.mask.VertCorROI;
    candidate6=output.mask.SurrStatsROI;

    ID=a(end-16:end-14);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_rh_xyz = read_label(CID, 'rh.superiortemporal');
    transversetemp_rh_xyz = read_label(CID, 'rh.transversetemporal');
    both_rh_xyz=[superiortemp_rh_xyz; transversetemp_rh_xyz];
    
    anat_rh=mne_read_stc_file([stcpath ID '_anat-40hz-rh-rh.stc']);
    vertices_rh_1=anat_rh.vertices([candidate1'],:);
    vertices_pca_rh_xyz_1 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_1),:);
    vertices_rh_2=anat_rh.vertices([candidate2'],:);
    vertices_pca_rh_xyz_2 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_2),:);
    vertices_rh_3=anat_lh.vertices([candidate3'],:);
    vertices_pca_rh_xyz_3 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_3),:);
    vertices_rh_4=anat_lh.vertices([candidate4'],:);
    vertices_pca_rh_xyz_4 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_4),:);
    vertices_rh_5=anat_lh.vertices([candidate5'],:);
    vertices_pca_rh_xyz_5 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_5),:);
    vertices_rh_6=anat_lh.vertices([candidate6'],:);
    vertices_pca_rh_xyz_6 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_6),:);
    vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);
    vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);
    
    if iter==1;
        cr_vert_all_r= vertices_all_rh_xyz;
        cr_both_rh_xyz=both_r_xyz;
        
        cr_vert_pca_r_1= vertices_pca_rh_xyz_1;
        cr_vert_pca_r_2= vertices_pca_rh_xyz_2;
        cr_vert_pca_r_3= vertices_pca_rh_xyz_3;
        cr_vert_pca_r_4= vertices_pca_rh_xyz_4;
        cr_vert_pca_r_5= vertices_pca_rh_xyz_5;
        cr_vert_pca_r_6= vertices_pca_rh_xyz_6;
        
    else
        cr_vert_all_r= [cr_vert_all_r;vertices_all_rh_xyz];
        cr_both_xyz= [cr_both_rh_xyz;both_rh_xyz];
        
        cr_vert_pca_r_1= [cr_vert_pca_r_1;vertices_pca_rh_xyz_1];
        cr_vert_pca_r_2= [cr_vert_pca_r_2;vertices_pca_rh_xyz_2];
        cr_vert_pca_r_3= [cr_vert_pca_r_3;vertices_pca_rh_xyz_3];
        cr_vert_pca_r_4= [cr_vert_pca_r_4;vertices_pca_rh_xyz_4];
        cr_vert_pca_r_5= [cr_vert_pca_r_5;vertices_pca_rh_xyz_5];
        cr_vert_pca_r_6= [cr_vert_pca_r_6;vertices_pca_rh_xyz_6];
        
    end
    
end

for iter = 1:length(EA_l)
    a = [early40path, EA_l{iter}];
    load(a)
    candidate1=output.mask.origROI;
    candidate2=output.mask.elbowROI;
    candidate3=output.mask.clusterROI;
    candidate4=output.mask.toptenROI;
    candidate5=output.mask.VertCorROI;
    candidate6=output.mask.SurrStatsROI;
   
    
    ID=a(end-15:end-13);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_lh_xyz = read_label(CID, 'lh.superiortemporal');
    transversetemp_lh_xyz = read_label(CID, 'lh.transversetemporal');
    both_lh_xyz=[superiortemp_lh_xyz; transversetemp_lh_xyz];
    
    anat_lh=mne_read_stc_file([stcpath ID '_anat-40hz-lh-lh.stc']);
    vertices_lh_1=anat_lh.vertices([candidate1'],:);
    vertices_pca_lh_xyz_1 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_1),:);
    vertices_lh_2=anat_lh.vertices([candidate2'],:);
    vertices_pca_lh_xyz_2 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_2),:);
    vertices_lh_3=anat_lh.vertices([candidate3'],:);
    vertices_pca_lh_xyz_3 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_3),:);
    vertices_lh_4=anat_lh.vertices([candidate4'],:);
    vertices_pca_lh_xyz_4 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_4),:);
    vertices_lh_5=anat_lh.vertices([candidate5'],:);
    vertices_pca_lh_xyz_5 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_5),:);
    vertices_lh_6=anat_lh.vertices([candidate6'],:);
    vertices_pca_lh_xyz_6 = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh_6),:);
   
    vertices_all_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1),vertices_all_lh),:);
    vertices_pca_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh),:);
    
    if iter==1;
        ea_vert_all_l= vertices_all_lh_xyz;
        ea_both_lh_xyz=both_lh_xyz;
            
        ea_vert_pca_l_1= vertices_pca_lh_xyz_1;
        ea_vert_pca_l_2= vertices_pca_lh_xyz_2;
        ea_vert_pca_l_3= vertices_pca_lh_xyz_3;
        ea_vert_pca_l_4= vertices_pca_lh_xyz_4;
        ea_vert_pca_l_5= vertices_pca_lh_xyz_5;
        ea_vert_pca_l_6= vertices_pca_lh_xyz_6;
        
    else
        ea_vert_all_l= [ea_vert_all_l;vertices_all_lh_xyz];
        ea_both_lh_xyz= [ea_both_lh_xyz;both_lh_xyz];
        
        ea_vert_pca_l_1= [ea_vert_pca_l_1;vertices_pca_lh_xyz_1];
        ea_vert_pca_l_2= [ea_vert_pca_l_2;vertices_pca_lh_xyz_2];
        ea_vert_pca_l_3= [ea_vert_pca_l_3;vertices_pca_lh_xyz_3];
        ea_vert_pca_l_4= [ea_vert_pca_l_4;vertices_pca_lh_xyz_4];
        ea_vert_pca_l_5= [ea_vert_pca_l_5;vertices_pca_lh_xyz_5];
        ea_vert_pca_l_6= [ea_vert_pca_l_6;vertices_pca_lh_xyz_6];
                   
    end
end

for iter = 1:length(EA_r)
    a = [early40path, EA_r{iter}];
    load(a)
    candidate1=output.mask.origROI;
    candidate2=output.mask.elbowROI;
    candidate3=output.mask.clusterROI;
    candidate4=output.mask.toptenROI;
    candidate5=output.mask.VertCorROI;
    candidate6=output.mask.SurrStatsROI;

    ID=a(end-16:end-14);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_rh_xyz = read_label(CID, 'rh.superiortemporal');
    transversetemp_rh_xyz = read_label(CID, 'rh.transversetemporal');
    both_rh_xyz=[superiortemp_rh_xyz; transversetemp_rh_xyz];
    
    anat_rh=mne_read_stc_file([stcpath ID '_anat-40hz-rh-rh.stc']);
    vertices_rh_1=anat_rh.vertices([candidate1'],:);
    vertices_pca_rh_xyz_1 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_1),:);
    vertices_rh_2=anat_rh.vertices([candidate2'],:);
    vertices_pca_rh_xyz_2 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_2),:);
    vertices_rh_3=anat_lh.vertices([candidate3'],:);
    vertices_pca_rh_xyz_3 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_3),:);
    vertices_rh_4=anat_lh.vertices([candidate4'],:);
    vertices_pca_rh_xyz_4 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_4),:);
    vertices_rh_5=anat_lh.vertices([candidate5'],:);
    vertices_pca_rh_xyz_5 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_5),:);
    vertices_rh_6=anat_lh.vertices([candidate6'],:);
    vertices_pca_rh_xyz_6 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_6),:);
    vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);
    vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);
    
    vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);
    vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);
    
    if iter==1;
        ea_vert_all_r= vertices_all_rh_xyz;
        ea_both_rh_xyz=both_rh_xyz;
           
        ea_vert_pca_r_1= vertices_pca_rh_xyz_1;
        ea_vert_pca_r_2= vertices_pca_rh_xyz_2;
        ea_vert_pca_r_3= vertices_pca_rh_xyz_3;
        ea_vert_pca_r_4= vertices_pca_rh_xyz_4;
        ea_vert_pca_r_5= vertices_pca_rh_xyz_5;
        ea_vert_pca_r_6= vertices_pca_rh_xyz_6;
        
    else
        ea_vert_all_r= [ea_vert_all_r;vertices_all_rh_xyz];
        ea_both_rh_xyz= [ea_both_rh_xyz;both_rh_xyz];
            
        ea_vert_pca_r_1= [ea_vert_pca_r_1;vertices_pca_rh_xyz_1];
        ea_vert_pca_r_2= [ea_vert_pca_r_2;vertices_pca_rh_xyz_2];
        ea_vert_pca_r_3= [ea_vert_pca_r_3;vertices_pca_rh_xyz_3];
        ea_vert_pca_r_4= [ea_vert_pca_r_4;vertices_pca_rh_xyz_4];
        ea_vert_pca_r_5= [ea_vert_pca_r_5;vertices_pca_rh_xyz_5];
        ea_vert_pca_r_6= [ea_vert_pca_r_6;vertices_pca_rh_xyz_6];
        
    end
end

for iter = 1:length(HC_l)
    a = [control40path, HC_l{iter}];
    load(a)
    candidate1=output.mask.origROI;
    candidate2=output.mask.elbowROI;
    candidate3=output.mask.clusterROI;
    candidate4=output.mask.toptenROI;
    candidate5=output.mask.VertCorROI;
    candidate6=output.mask.SurrStatsROI;
    
    ID=a(end-15:end-13);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_lh_xyz = read_label(CID, 'lh.superiortemporal');
    transversetemp_lh_xyz = read_label(CID, 'lh.transversetemporal');
    both_lh_xyz=[superiortemp_lh_xyz; transversetemp_lh_xyz];
    
    anat_rh=mne_read_stc_file([stcpath ID '_anat-40hz-rh-rh.stc']);
    vertices_rh_1=anat_rh.vertices([candidate1'],:);
    vertices_pca_rh_xyz_1 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_1),:);
    vertices_rh_2=anat_rh.vertices([candidate2'],:);
    vertices_pca_rh_xyz_2 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_2),:);
    vertices_rh_3=anat_lh.vertices([candidate3'],:);
    vertices_pca_rh_xyz_3 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_3),:);
    vertices_rh_4=anat_lh.vertices([candidate4'],:);
    vertices_pca_rh_xyz_4 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_4),:);
    vertices_rh_5=anat_lh.vertices([candidate5'],:);
    vertices_pca_rh_xyz_5 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_5),:);
    vertices_rh_6=anat_lh.vertices([candidate6'],:);
    vertices_pca_rh_xyz_6 = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh_6),:);
    vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);
    vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);
  
    vertices_all_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1),vertices_all_lh),:);
    vertices_pca_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh),:);
    
    if iter==1;
        hc_vert_all_l= vertices_all_lh_xyz;
        hc_vert_pca_l= vertices_pca_lh_xyz;
        hc_both_lh_xyz=both_lh_xyz;
        
        
    else
        hc_vert_all_l= [hc_vert_all_l;vertices_all_lh_xyz];
        hc_vert_pca_l= [hc_vert_pca_l;vertices_pca_lh_xyz];
        hc_both_lh_xyz= [hc_both_lh_xyz;both_lh_xyz];
        
        
    end
end

for iter = 1:length(HC_r)
    a = [control40path, HC_r{iter}];
    load(a)
    candidate=output.mask.VertCorROI;
    
    ID=a(end-16:end-14);CID=upper(ID);
    envi=[mridir CID fstest];setenv('SUBJECTS_DIR', envi);
    
    superiortemp_rh_xyz = read_label(CID, 'rh.superiortemporal');
    transversetemp_rh_xyz = read_label(CID, 'rh.transversetemporal');
    both_rh_xyz=[superiortemp_rh_xyz; transversetemp_rh_xyz];
    
    anat_rh=mne_read_stc_file([stcpath ID '_anat-40hz-rh-rh.stc']);
    vertices_rh=anat_rh.vertices([candidate'],:);vertices_all_rh = anat_rh.vertices;
    
    vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);
    vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);
    
    if iter==1;
        hc_vert_all_r= vertices_all_rh_xyz;
        hc_vert_pca_r= vertices_pca_rh_xyz;
        hc_both_rh_xyz=both_rh_xyz;
        
    else
        hc_vert_all_r= [hc_vert_all_r;vertices_all_rh_xyz];
        hc_vert_pca_r= [hc_vert_pca_r;vertices_pca_rh_xyz];
        hc_both_rh_xyz= [hc_both_rh_xyz;both_rh_xyz];
        
        
    end
end

figure;title('chronic')
h1=plot3(cr_vert_pca_l(:,2),cr_vert_pca_l(:,3),cr_vert_pca_l(:,4),'k.','MarkerSize',20);
hold on;
h2=plot3(cr_both_lh_xyz(:,2),cr_both_lh_xyz(:,3),cr_both_lh_xyz(:,4),'go','MarkerSize',1);
hold on;
h3=plot3(cr_vert_pca_r(:,2),cr_vert_pca_r(:,3),cr_vert_pca_r(:,4),'k.','MarkerSize',20);
hold on;
h4=plot3(cr_both_rh_xyz(:,2),cr_both_rh_xyz(:,3),cr_both_rh_xyz(:,4),'yo','MarkerSize',1);

figure;title('early')
h1=plot3(ea_vert_pca_l(:,2),ea_vert_pca_l(:,3),ea_vert_pca_l(:,4),'k.','MarkerSize',20);
hold on;
h2=plot3(ea_both_lh_xyz(:,2),ea_both_lh_xyz(:,3),ea_both_lh_xyz(:,4),'go','MarkerSize',1);
hold on
h3=plot3(ea_vert_pca_r(:,2),ea_vert_pca_r(:,3),ea_vert_pca_r(:,4),'k.','MarkerSize',20);
hold on;
h4=plot3(ea_both_rh_xyz(:,2),ea_both_rh_xyz(:,3),ea_both_rh_xyz(:,4),'yo','MarkerSize',1);

figure;title('controls')
h1=plot3(hc_vert_pca_l(:,2),hc_vert_pca_l(:,3),hc_vert_pca_l(:,4),'k.','MarkerSize',20);
hold on;
h2=plot3(hc_both_lh_xyz(:,2),hc_both_lh_xyz(:,3),hc_both_lh_xyz(:,4),'go','MarkerSize',1);
hold on
h3=plot3(hc_vert_pca_r(:,2),hc_vert_pca_r(:,3),hc_vert_pca_r(:,4),'k.','MarkerSize',20);
hold on;
h4=plot3(hc_both_rh_xyz(:,2),hc_both_rh_xyz(:,3),hc_both_rh_xyz(:,4),'yo','MarkerSize',1);




