function [ID,CID, both_lh_xyz,both_rh_xyz,vertices_all_lh_xyz,vertices_all_rh_xyz,vertices_pca_lh_xyz,vertices_pca_rh_xyz] = xyzplotting_pca(subject,candidate)
%subject in lower case : 'h01'
%capssubject, first letter upper case: 'H01'
%candidate: ROI
% Nithya Ramakrishnan,07/09/2018
addpath('/raid5/rcho/PSYCH_CFC/MEG_raw_data/scripts/mne/MNE-2.7.3-3268-Linux-x86_64/share/matlab/')
mridir='/raid5/rcho/PSYCH_CFC/fMRI/';
fstest='/RAW/fs_test/';
stcpath='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/functional_label/stc/';

% hfiles=dir([mridir 'H*']); h_files={hfiles.name}'; %'H*'
% sfiles=dir([mridir 'S*']); s_files={sfiles.name}';
% ID=[h_files; s_files];   
ID=subject;
CID =upper(subject);
envi=[mridir CID fstest];

setenv('SUBJECTS_DIR', envi);

superiortemp_lh_xyz = read_label(CID, 'lh.superiortemporal');
superiortemp_rh_xyz = read_label(CID, 'rh.superiortemporal');
transversetemp_lh_xyz = read_label(CID, 'lh.transversetemporal');
transversetemp_rh_xyz = read_label(CID, 'rh.transversetemporal');
anat_lh=mne_read_stc_file([stcpath ID '_anat-40hz-lh-lh.stc']);
anat_rh=mne_read_stc_file([stcpath ID '_anat-40hz-rh-rh.stc']);

both_lh_xyz=[superiortemp_lh_xyz; transversetemp_lh_xyz];
both_rh_xyz=[superiortemp_rh_xyz; transversetemp_rh_xyz];

vertices_lh=anat_lh.vertices([sourcesL{iter}'],:);
vertices_rh=anat_rh.vertices([sourcesR{iter}'],:);

vertices_all_lh = anat_lh.vertices; 
vertices_all_rh = anat_rh.vertices;

vertices_all_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1),vertices_all_lh),:);
vertices_all_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1),vertices_all_rh),:);

vertices_pca_lh_xyz = both_lh_xyz(ismember(both_lh_xyz(:,1), vertices_lh),:);
vertices_pca_rh_xyz = both_rh_xyz(ismember(both_rh_xyz(:,1), vertices_rh),:);

% figure;
% h1=plot3(superiortemp_rh_xyz(:,2),superiortemp_rh_xyz(:,3), superiortemp_rh_xyz(:,4),'ro');
% hold on; 
% h2=plot3(transversetemp_rh_xyz(:,2),transversetemp_rh_xyz(:,3), transversetemp_rh_xyz(:,4),'go');
% %hold on;
% %plot3(vertices_pca_rh_xyz(:,2),vertices_pca_rh_xyz(:,3),vertices_pca_rh_xyz(:,4),'k.','MarkerSize',10);
% % hold on;
% % scatter2=plot3(cortex_rh_xyz(:,2), cortex_rh_xyz(:,3), cortex_rh_xyz(:,4),'MarkerFaceColor','k');
% % scatter2.Color(4)=0.01;
% % hold on;
% % scatter1=plot3(cortex_lh_xyz(:,2), cortex_lh_xyz(:,3), cortex_lh_xyz(:,4),'MarkerFaceColor','k');
% % scatter1.Color(4)=0.01;
% hold on;
% h3=plot3(superiortemp_lh_xyz(:,2),superiortemp_lh_xyz(:,3), superiortemp_lh_xyz(:,4),'bo');
% hold on; 
% h4=plot3(transversetemp_lh_xyz(:,2), transversetemp_lh_xyz(:,3), transversetemp_lh_xyz(:,4),'yo');
% hold on;
% h(5)=plot3(vertices_all_rh_xyz(:,2),vertices_all_rh_xyz(:,3),vertices_all_rh_xyz(:,4),'k.','MarkerSize',10);
% uistack(h(5),'top')
% hold on;
% h6=plot3(vertices_pca_rh_xyz(:,2),vertices_pca_rh_xyz(:,3),vertices_pca_rh_xyz(:,4),'k.','MarkerSize',10);
% uistack(h6,'top')
figure;
h1=plot3(superiortemp_rh_xyz(:,2),superiortemp_rh_xyz(:,3), superiortemp_rh_xyz(:,4),'ro');
hold on; 
h2=plot3(transversetemp_rh_xyz(:,2),transversetemp_rh_xyz(:,3), transversetemp_rh_xyz(:,4),'go');
hold on;
h6=plot3(vertices_pca_rh_xyz(:,2),vertices_pca_rh_xyz(:,3),vertices_pca_rh_xyz(:,4),'k.','MarkerSize',50);
uistack(h6,'top')

hold on;
h6=plot3(vertices_pca_lh_xyz(:,2),vertices_pca_lh_xyz(:,3),vertices_pca_lh_xyz(:,4),'k.','MarkerSize',50);
uistack(h6,'top')
h3=plot3(superiortemp_lh_xyz(:,2),superiortemp_lh_xyz(:,3), superiortemp_lh_xyz(:,4),'bo');
hold on; 
h4=plot3(transversetemp_lh_xyz(:,2), transversetemp_lh_xyz(:,3), transversetemp_lh_xyz(:,4),'yo');
hold on;



