#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Sun Apr 16 16:46:04 2017

@author: nithya
"""


import mne
import numpy as np
import matplotlib.pyplot as plt
import os.path as op

from mne.minimum_norm import (make_inverse_operator, apply_inverse,
                              write_inverse_operator,read_inverse_operator)
from mayavi import mlab  # noqa
from surfer import Brain  # noqa
###############################################################################
datapath='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/'
stcs = list()
#Chronic=S01,S02,S04,S05,S07,S08,S09,S20,S22,S24,S40,S41,S44,S45,S46,S50
#EARLY=S13,S17,S19,S21,S23,S28,S30,S32,S34,S35,S36,S39

#exclude = [3,6,10,11,12,14,15,16,18,25,26,27,29,31,33,37,38,42,43,47,48,49] 
#for run in range(1, 51):
#early
exclude = [1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,18,20,22,24,25,26,27,29,31,33,37,38,40,41,42,43,44,45,46,47,48,49,50] 
for run in range(1, 51):
    if run in exclude:
        continue
    subject = "s%02d" % run
    stc_fname = op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/stc/', '%s_40hz' % (subject))
    fssub = "S%02d" % run
    subjects_dir=op.join('/raid5/rcho/PSYCH_CFC/fMRI/', '%s/RAW/fs_test/' % (fssub))
    print("processing subject: %s" % subject)
    stc=mne.read_source_estimate(stc_fname, subject=subject)
#    morphed = stc.morph(subject_from=fssub, subject_to='fsaverage',
#                        subjects_dir=subjects_dir, grade=4)
    fs_vertices = [np.arange(10242)] * 2  # fsaverage is special this way
    morph_mat = mne.compute_morph_matrix(fssub, 'fsaverage', stc.vertices,
                                     fs_vertices, smooth=None,
                                     subjects_dir=subjects_dir)
    stc_fsaverage = stc.morph_precomputed('fsaverage', fs_vertices, morph_mat)
    #morphed.save(op.join(datapath, '%s-morphed' % (subject)))
    stcs.append(stc_fsaverage)

data = np.average([s.data for s in stcs], axis=0)
stc_e = mne.SourceEstimate(data, stcs[0].vertices, stcs[0].tmin, stcs[0].tstep)
stc_e.save(op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/', 'STCearly_average'))
###########################################
#plotting
stc_e_fname=op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/', 'STCearly_average')  
stc_e=mne.read_source_estimate(stc_e_fname)
tmin=0.150
tmax=0.900
stc_e_mean = stc_e.copy().crop(tmin, tmax).mean()

vertno_max, time_max = stc_h.get_peak(hemi='lh')
    
brain_fsaverage = stc_e_mean.plot(subject='fsaverage',surface='inflated', hemi='lh', 
                             subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/S13/RAW/fs_test/', 
                             clim=dict(kind='value', lims=[3, 3.5, 5]), 
                             initial_time=0.8, time_unit='s'
                             size=(800, 800), smoothing_steps=5)

    
brain_fsaverage = stc_e_mean.plot(subject='fsaverage',surface='inflated', hemi='rh', 
                             subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/S13/RAW/fs_test/', 
                             clim=dict(kind='value', lims=[1.5, 2, 4]))
brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/Early40hz_150-900_rh_avgASSR.jpeg')

#brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_0.jpeg')
#brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_100.jpeg')
#brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_200.jpeg')
#brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_300.jpeg')
#brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_500.jpeg')
brain_fsaverage.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_lh_800.jpeg')

##############################################################################

datapath='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/'
method = "dSPM"
snr = 1.
lambda2 = 1. / snr ** 2
stcvects = list()
#exclude = [3,6,10,11,12,14,15,16,18,25,26,27,29,31,33,37,38,42,43,47,48,49] 
#for run in range(1, 51):
#early
exclude = [1,2,3,4,5,6,7,8,9,10,11,12,14,15,16,18,20,22,24,25,26,27,29,31,33,37,38,40,41,42,43,44,45,46,47,48,49,50] 
for run in range(1, 51):
    if run in exclude:
        continue
#exclude = [2,6,9,10,12,17,18] 
#for run in range(1, 25):    
#    if run in exclude:
#        continue
    subject = "s%02d" % run
    print("processing subject: %s" % subject)
    fssub = "S%02d" % run
    subjects_dir=op.join('/raid5/rcho/PSYCH_CFC/fMRI/', '%s/RAW/fs_test/' % (fssub))
    fname40=op.join(datapath, 'epochs/', '%s_40epo.fif' % (subject))
    inv40_fname=op.join(datapath,'inv/', '%s_40hz-meg-oct-6-inv.fif' % (subject))
    epochs40=mne.read_epochs(fname40, proj=True, preload=True, verbose=None)
    evoked40 = epochs40.average()
    inverse_operator40=mne.minimum_norm.read_inverse_operator(inv40_fname)
    stc_vec = apply_inverse(evoked40, inverse_operator40, lambda2,
                        method=method, pick_ori='vector')
    fs_vertices = [np.arange(10242)] * 2  # fsaverage is special this way
    morph_vec_mat = mne.compute_morph_matrix(fssub, 'fsaverage', stc_vec.vertices,
                                     fs_vertices, smooth=None,
                                     subjects_dir=subjects_dir)
    stc_vec_fsaverage = stc_vec.morph_precomputed('fsaverage', fs_vertices, morph_vec_mat)
    stcvects.append(stc_vec_fsaverage)
    
data_vect = np.average([s.data for s in stcvects], axis=0)
stc_vect_e = mne.VectorSourceEstimate(data_vect, stcvects[0].vertices, stcvects[0].tmin, stcvects[0].tstep)
stc_vect_e.save(op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/', 'STC_Dipole_early_average'))
#################################################
#plotting 
vertno_max, time_max = stc_vect_e.get_peak(hemi='rh')

stc_vect_e_fname=op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/', 'STC_Dipole_early_average')
stc_vect_e=mne.read_source_estimate(stc_vect_e_fname)
tmin=0.250
tmax=0.900
stc_vect_e_mean = stc_vect_e.copy().crop(tmin, tmax).mean()


vectorplot=stc_vect_e_mean.plot(subject='fsaverage',hemi='lh', subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/S13/RAW/fs_test/',
             clim=dict(kind='value', lims=[1, 2, 4]),time_unit='s',scale_factor=5)


#vectorplot=stc_vect_e_mean.plot(subject='fsaverage',hemi='rh', subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/S13/RAW/fs_test/', 
                               #clim=dict(kind='value', lims=[1.5, 2, 4]),time_unit='s',scale_factor=5)

vectorplot.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/Early40hz_lh_avgASSR_new.jpeg')




    
    
data = np.average([s.data for s in stcs], axis=0)
stc_p = mne.SourceEstimate(data, stcs[0].vertices, stcs[0].tmin, stcs[0].tstep)
stc_p.save(op.join('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/patient/', 'STCpatient_average'))

#For plotting
brain = stc.plot(subject='fsaverage',hemi='rh', subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/H01/RAW/fs_test/',surface='inflated',time_label='DICS source power at %s Hz' % (stc.times*1000))
brain = stc.plot(subject='S01',hemi='rh', subjects_dir='/raid5/rcho/PSYCH_CFC/fMRI/S01/RAW/fs_test/',surface='inflated', time_viewer=True)

brain.show_view('lateral')
brain.scale_data_colormap(fmin=1.05,fmid=1.07, fmax=1.1, transparent=True)
brain.scale_data_colormap(fmin=1.07e+00, fmid=1.8e+00, fmax=1.1e+00, transparent=True)
brain.scale_data_colormap(fmin=0.8, fmid=1.10e+00, fmax=1.15e+00, transparent=True)
brain.save_image('/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/group/healthy/Healthy40hz_STC_rh.jpeg')
