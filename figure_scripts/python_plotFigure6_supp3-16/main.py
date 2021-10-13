# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

import os
import eneuro_summary_plots


# Press the green button in the gutter to run the script.

# note that a modified version of plotter.py from the dabest package is included. This allows the legend to be moved
# around the figure in a more flexible way.

if __name__ == '__main__':

    # run this to create summary plots for each rat
    rat_list = [216, 218, 221, 222, 283, 309, 310, 311, 312, 383, 384, 385, 386, 387]
    learning_rats = [218, 309, 312, 384]

    ratID_list = ['R{:04d}'.format(rat) for rat in rat_list]

    # set kinematics_base_folder to the parent folder for the kinematics summaries
    kinematics_base_folder = '/Users/dan/Documents/GitHub/eneuro_dabest/rat_kinematic_summaries'
    # kinematics_base_folder = '/Users/dleventh/Documents/GitHub/eneuro_dabest/rat_kinematic_summaries'

    # set figs_base_folder to the parent folder for where you would like to write the figures
    figs_base_folder = '/Users/dan/Dropbox (University of Michigan)/manuscripts/2021/SR_learning/eNeuro_submission/revision/python_figs'
    # figs_base_folder = '/Users/dleventh/Dropbox (University of Michigan)/manuscripts/2021/SR_learning/eNeuro_submission/revision/python_figs'

    fname_expt_summaries = os.path.join(kinematics_base_folder, 'experiment_summaries_by_outcome.mat')
    fname_learner_summaries = os.path.join(kinematics_base_folder, 'learner_summaries.mat')
    fname_learning_summaries = os.path.join(kinematics_base_folder, 'learning_summaries.mat')
    fname_nonlearner_summaries = os.path.join(kinematics_base_folder, 'nonLearner_summaries.mat')
    fname_slidewin_kinematics = os.path.join(kinematics_base_folder, 'slidingWindowKinematics.mat')
    fname_within_sess_success = os.path.join(kinematics_base_folder, 'succRateWithinSess.mat')

    eneuro_summary_plots.create_rat_summary_plots(rat_list, learning_rats, kinematics_base_folder, figs_base_folder)