#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Aug  7 14:10:16 2017

@author: nithya
"""

import mne
import numpy as np
import scipy.io
import os.path as op

data_path='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/'


exclude = [3,4,6,10,11,12,14,15,16,18,25,26,27,29,31,33,37,38,42,43,47,48,49] 
for run in range(1, 51):
    if run in exclude:
        continue
    subject = "s%02d" % run
    fssub = "S%02d" % run #freesurfer subject 
    print("processing subject: %s" % subject)

    stc_save_name_transverse_rh=op.join(data_path,'functional_label/20hz/', '%s_transverse-20hz_rh' % (subject))
    stc_save_name_transverse_lh=op.join(data_path,'functional_label/20hz/', '%s_transverse-20hz_lh' % (subject))

    stc_save_name_both_rh=op.join(data_path,'functional_label/20hz/', '%s_both-20hz_rh' % (subject))
    stc_save_name_both_lh=op.join(data_path,'functional_label/20hz/', '%s_both-20hz_lh' % (subject))

    stc_save_name_anat_transverse_rh=op.join(data_path,'functional_label/20hz/', '%s_anat_transverse-20hz_rh' % (subject))
    stc_save_name_anat_transverse_lh=op.join(data_path,'functional_label/20hz/', '%s_anat_transverse-20hz_lh' % (subject))

    stc_save_name_anat_both_rh=op.join(data_path,'functional_label/20hz/', '%s_anat_both-20hz_rh' % (subject))
    stc_save_name_anat_both_lh=op.join(data_path,'functional_label/20hz/', '%s_anat_both-20hz_lh' % (subject))


    stcs20_transverse_rh=np.load(stc_save_name_transverse_rh+'.npy')
    stcs20_transverse_lh=np.load(stc_save_name_transverse_lh+'.npy')

    stcs20_both_rh=np.load(stc_save_name_both_rh+'.npy')
    stcs20_both_lh=np.load(stc_save_name_both_lh+'.npy')

    stcs20_anat_transverse_rh=np.load(stc_save_name_anat_transverse_rh+'.npy')
    stcs20_anat_transverse_lh=np.load(stc_save_name_anat_transverse_lh+'.npy')

    stcs20_anat_both_rh=np.load(stc_save_name_anat_both_rh+'.npy')
    stcs20_anat_both_lh=np.load(stc_save_name_anat_both_lh+'.npy')

    
    mat_save_name_transverse_rh=op.join(data_path,'functional_label/matlab/20/', '%s_transverse-20hz_rh.mat' % (subject))
    mat_save_name_transverse_lh=op.join(data_path,'functional_label/matlab/20/', '%s_transverse-20hz_lh.mat' % (subject))

    mat_save_name_both_rh=op.join(data_path,'functional_label/matlab/20/', '%s_both-20hz_rh.mat' % (subject))
    mat_save_name_both_lh=op.join(data_path,'functional_label/matlab/20/', '%s_both-20hz_lh.mat' % (subject))

    mat_save_name_anat_transverse_rh=op.join(data_path,'functional_label/matlab/20/', '%s_anat_transverse-20hz_rh.mat' % (subject))
    mat_save_name_anat_transverse_lh=op.join(data_path,'functional_label/matlab/20/', '%s_anat_transverse-20hz_lh.mat' % (subject))

    mat_save_name_anat_both_rh=op.join(data_path,'functional_label/matlab/20/', '%s_anat_both-20hz_rh.mat' % (subject))
    mat_save_name_anat_both_lh=op.join(data_path,'functional_label/matlab/20/', '%s_anat_both-20hz_lh.mat' % (subject))


    scipy.io.savemat(mat_save_name_transverse_rh, {"stcs20_transverse_rh":stcs20_transverse_rh})
    scipy.io.savemat(mat_save_name_transverse_lh, {"stcs20_transverse_lh":stcs20_transverse_lh})
    
    scipy.io.savemat(mat_save_name_both_rh, {"stcs20_both_rh":stcs20_both_rh})
    scipy.io.savemat(mat_save_name_both_lh, {"stcs20_both_lh":stcs20_both_lh})

    scipy.io.savemat(mat_save_name_anat_transverse_rh, {"stcs20_anat_transverse_rh":stcs20_anat_transverse_rh})
    scipy.io.savemat(mat_save_name_anat_transverse_lh, {"stcs20_anat_transverse_lh":stcs20_anat_transverse_lh})
    
    scipy.io.savemat(mat_save_name_anat_both_rh, {"stcs20_anat_both_rh":stcs20_anat_both_rh})
    scipy.io.savemat(mat_save_name_anat_both_lh, {"stcs20_anat_both_lh":stcs20_anat_both_lh})





