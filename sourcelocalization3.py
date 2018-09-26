#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# MEG SOURCE LOCALIZATION module No.2 - Nithya Ramakrishnan, UTH, Texas, USA, 2017

# Use of this module is to compute and apply a linear inverse method such as dSPM (dynamic Statistical Parametric Mapping)
# on evoked data. This pipeline was adapted from the martinos MNE source localization tutorial. 

# Contents summary:

"""
Created on Fri Apr  7 16:58:41 2017

@author: nithya
"""
import mne
from mne.minimum_norm import (make_inverse_operator, apply_inverse,
                              write_inverse_operator)
import numpy as np
import matplotlib.pyplot as plt
import numpy as np  # noqa
import os.path as op
from mne.minimum_norm import read_inverse_operator
from mne.time_frequency import csd_epochs
from mne.beamformer import dics_source_power
from mne.beamformer import dics

print(__doc__)

data_path='/raid5/rcho/MEG_NM_NR_testing/FINALMNE/DATA/'
#healthy_ids = [1,2,3,4,5,6,7,8,10,11,13,14,15,16,17,18,19,20,21,22,23] #current ids in our workspace 
#patient_ids = [1,2,3,4,5,6,7,8,9,13,17,18,19,20,21,22,23,24,28,29,30,32,34,35,36] #current ids in our workspace 

exclude = [2,6,9,10] 
for run in range(1, 11):
    if run in exclude:
        continue
    
#initialize names     
    subject = "h%02d" % run
    fssub = "H%02d" % run #freesurfer subject 
    subjects_dir=op.join('/raid5/rcho/PSYCH_CFC/fMRI/', '%s/RAW/fs_test/' % (fssub))
    
    #this is the file that resulted from the MEG-MRI coregistration that was done using MNE_ANALYZE
    trans=op.join('/raid5/rcho/PSYCH_CFC/MEG_raw_data/%s_%s/ssaep/%s_SSAEP-trans.fif' %(subject, subject, fssub)) 
    #these files result from the structural_processing_script 
    bem=op.join('/raid5/rcho/PSYCH_CFC/fMRI/%s/RAW/fs_test/%s/bem/%s-20480-bem-sol.fif' %(fssub, fssub, fssub))
    src_fname=op.join('/raid5/rcho/PSYCH_CFC/fMRI/%s/RAW/fs_test/%s/bem/%s-oct-6-src.fif' %(fssub, fssub, fssub))
    #epochs created from the preprocessing pipeline 
    fname20=op.join(data_path, 'epochs/', '%s_20epo.fif' % (subject))
    fname30=op.join(data_path, 'epochs/', '%s_30epo.fif' % (subject))
    fname40=op.join(data_path, 'epochs/', '%s_40epo.fif' % (subject))

#initialize names to write to     
    fwd_fname20=op.join(data_path, 'fwd/', '%s_20.fwd.fif' % (subject))
    fwd_fname30=op.join(data_path, 'fwd/', '%s_30.fwd.fif' % (subject))
    fwd_fname40=op.join(data_path, 'fwd/', '%s_40.fwd.fif' % (subject))
    
    cov20_fname=op.join(data_path, 'noise_cov/', '%s_noise_20-cov.fif' % (subject))
    cov30_fname=op.join(data_path, 'noise_cov/', '%s_noise_30-cov.fif' % (subject))
    cov40_fname=op.join(data_path, 'noise_cov/', '%s_noise_40-cov.fif' % (subject))

    inv20_fname=op.join(data_path, 'inv/', '%s_20hz-meg-oct-6-inv.fif' % (subject))
    inv30_fname=op.join(data_path,'inv/', '%s_30hz-meg-oct-6-inv.fif' % (subject))
    inv40_fname=op.join(data_path,'inv/', '%s_40hz-meg-oct-6-inv.fif' % (subject))

    stc20_fname=op.join(data_path,'stc/', '%s_20hz' % (subject))
    stc30_fname=op.join(data_path,'stc/', '%s_30hz' % (subject))
    stc40_fname=op.join(data_path,'stc/', '%s_40hz' % (subject))
    
    
    stc40_fname2=op.join(data_path,'stc2/', '%s_40hz' % (subject))
    stc40_fname3=op.join(data_path,'stc3/', '%s_40hz' % (subject))
    
    stc30_fname2=op.join(data_path,'stc2/', '%s_30hz' % (subject))
    stc30_fname3=op.join(data_path,'stc3/', '%s_30hz' % (subject))
    
    stc20_fname2=op.join(data_path,'stc2/', '%s_20hz' % (subject))
    stc20_fname3=op.join(data_path,'stc3/', '%s_20hz' % (subject))




#start processing    
    print("processing subject: %s" % subject)
#initialize all filenames - change only this for all subjects ....

###############################################################################


    src = mne.read_source_spaces(src_fname)
#computing foward solution 
    fwd20=mne.make_forward_solution(fname20, trans=trans, src=src, bem=bem,
                                fname=None, meg=True, eeg=False,
                                mindist=5.0, n_jobs=2)
    fwd30=mne.make_forward_solution(fname30, trans=trans, src=src, bem=bem,
                                fname=None, meg=True, eeg=False,
                                mindist=5.0, n_jobs=2)
    fwd40=mne.make_forward_solution(fname40, trans=trans, src=src, bem=bem,
                                fname=None, meg=True, eeg=False,
                                mindist=5.0, n_jobs=2)

    mne.write_forward_solution(fwd_fname20,fwd20,overwrite=False,verbose=None)
    mne.write_forward_solution(fwd_fname30,fwd30,overwrite=False,verbose=None)
    mne.write_forward_solution(fwd_fname40,fwd40,overwrite=False,verbose=None)

#writing and reading it in as surf_ori is set to true in the process 
    fwd20 =  mne.read_forward_solution(fwd_fname20, surf_ori=True)
    fwd30 =  mne.read_forward_solution(fwd_fname30, surf_ori=True)
    fwd40 =  mne.read_forward_solution(fwd_fname40, surf_ori=True)

    epochs20=mne.read_epochs(fname20, proj=True, preload=True, verbose=None)
    epochs30=mne.read_epochs(fname30, proj=True, preload=True, verbose=None)
    epochs40=mne.read_epochs(fname40, proj=True, preload=True, verbose=None)

    noise_cov20 = mne.compute_covariance(epochs20, tmax=0., method=['shrunk'])
    noise_cov30 = mne.compute_covariance(epochs30, tmax=0., method=['shrunk'])
    noise_cov40 = mne.compute_covariance(epochs40, tmax=0., method=['shrunk'])

    mne.write_cov(cov20_fname, noise_cov20)
    mne.write_cov(cov30_fname, noise_cov30)
    mne.write_cov(cov40_fname, noise_cov40)

    evoked20 = epochs20.average()
    evoked30 = epochs30.average()
    evoked40 = epochs40.average()



# make an MEG inverse operator
    info20 = evoked20.info
    info30 = evoked30.info
    info40 = evoked40.info

    inverse_operator20 = make_inverse_operator(info20, fwd20, noise_cov30,
                                         loose=0.2, depth=0.8)
    inverse_operator30 = make_inverse_operator(info30, fwd30, noise_cov30,
                                         loose=0.2, depth=0.8)
    inverse_operator40 = make_inverse_operator(info40, fwd40, noise_cov40,
                                         loose=0.2, depth=0.8)

    write_inverse_operator(inv20_fname,inverse_operator20)
    write_inverse_operator(inv30_fname,inverse_operator30)
    write_inverse_operator(inv40_fname,inverse_operator40)

    method = "dSPM"
    snr = 1.
    lambda2 = 1. / snr ** 2
    stc40 = apply_inverse(evoked40, inverse_operator40, lambda2,
                    method=method, pick_ori=None)

    stc30 = apply_inverse(evoked30, inverse_operator30, lambda2,
                    method=method, pick_ori=None)

    stc20 = apply_inverse(evoked20, inverse_operator20, lambda2,
                    method=method, pick_ori=None)

 
    stc40.save(stc40_fname, ftype='stc')
    stc30.save(stc30_fname, ftype='stc')
    stc20.save(stc20_fname, ftype='stc')

  ##40 hz#######################################################  
    data_csd40 = csd_epochs(epochs40, mode='multitaper', tmin=0.01, tmax=0.50,
                      fmin=35, fmax=45)
    noise_csd40 = csd_epochs(epochs40, mode='multitaper', tmin=-0.49, tmax=0.00,
                       fmin=35, fmax=45)
    stc40_2=dics_source_power(epochs40.info, fwd40, noise_csd40, data_csd40)
    # Compute DICS spatial filter and estimate source power
    stc40_3 = dics(evoked40, fwd40, noise_csd40, data_csd40, reg=0.05)
    
    stc40_2.save(stc40_fname2, ftype='stc')
    stc40_3.save(stc40_fname3, ftype='stc')
 ################################################################
 ####30 hz#######################################################  
    data_csd30 = csd_epochs(epochs30, mode='multitaper', tmin=0.01, tmax=0.50,
                      fmin=25, fmax=35)
    noise_csd30 = csd_epochs(epochs30, mode='multitaper', tmin=-0.49, tmax=0.00,
                       fmin=25, fmax=35)
    stc30_2=dics_source_power(epochs30.info, fwd30, noise_csd30, data_csd30 )
    stc30_3 = dics(evoked30, fwd30, noise_csd30, data_csd30, reg=0.05)
    
    stc30_2.save(stc30_fname2, ftype='stc')
    stc30_3.save(stc30_fname3, ftype='stc')
 ################################################################ 
 ####20 hz  #####################################################
    data_csd20 = csd_epochs(epochs20, mode='multitaper', tmin=0.01, tmax=0.50,
                      fmin=15, fmax=25)
    noise_csd20 = csd_epochs(epochs20, mode='multitaper', tmin=-0.49, tmax=0.00,
                       fmin=15, fmax=25)
    stc20_2=dics_source_power(epochs20.info, fwd20, noise_csd20, data_csd20 )
    stc20_3 = dics(evoked20, fwd20, noise_csd20, data_csd20, reg=0.05)
    
    stc20_2.save(stc20_fname2, ftype='stc')
    stc20_3.save(stc20_fname3, ftype='stc')
 ################################################################

