import numpy as np
import pandas as pd
import dabest
import scipy.io as sio
import matplotlib.pyplot as plt
import mat_data_io


def create_independent_samples_dabest_df(session_data):

    # make sure session_data rows represent days, columns represent different rats.

    # if session_data is np.array:

    session_names = ['session_{:02d}'.format(i_sn + 1) for i_sn in range(len(session_data))]

    # if all elements are nan's (there were no trials for this session), stick a zero in to make dabest happy
    for i_sd, sd in enumerate(session_data):
        try:
            np.isnan(sd).all()
        except TypeError:
            pass
        if np.isnan(sd).all():
            session_data[i_sd][0] = 0.
    d = dict([('d {:02d}'.format(i_sn + 1), list(session_data[i_sn])) for i_sn in range(len(session_data))])
    df = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in d.items()]))

    return df


def create_independent_samples_with_outcomes_df(session_data, all_outcomes):

    # make sure session_data rows represent days, columns represent different rats.

    # if session_data is np.array:

    session_names = ['d{:02d}'.format(i_sn + 1) for i_sn in range(len(session_data))]
    session_outcome_names = ['d{:02d} outcomes'.format(i_sn + 1) for i_sn in range(len(session_data))]
    # if all elements are nan's (there were no trials for this session), stick a zero in to make dabest happy
    for i_sd, sd in enumerate(session_data):
        try:
            np.isnan(sd).all()
        except TypeError:
            pass
        if np.isnan(sd).all():
            session_data[i_sd][0] = 0.
    d = dict([(session_names[i_sn], list(session_data[i_sn])) for i_sn in range(len(session_data))])
    outcome_d = dict([(session_outcome_names[i_sn], list(all_outcomes[i_sn])) for i_sn in range(len(session_data))])
    df = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in d.items()]))
    df_outcomes = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in outcome_d.items()]))

    #todo: figure out how to make a dataframe where each row is a single point, with columns session_name, value, outcome
    # here's a start:
    new_frame = pd.melt(df, value_vars=session_names)
    new_outcomes_frame = pd.melt(df_outcomes, value_vars=session_outcome_names)

    new_frame['outcome'] = new_outcomes_frame['value']

    # eliminate rows with nan's for value
    new_frame.dropna(subset = ['value'], inplace=True)

    return new_frame


def create_repeated_measures_dabest_df(session_data):

    # make sure session_data rows represent days, columns represent different rats.
    data_shape = np.shape(session_data)
    # work-around to make sure array is the right shape, with sessions as the first dimension and
    # individual rats as the second
    if data_shape[1] == 10:
        # session_data = np.transpose(session_data)
        Ns = data_shape[0]
    else:
        Ns = data_shape[1]

    id_col = pd.Series(range(1, Ns + 1))

    df = pd.DataFrame({'d01': session_data[0], 'd02': session_data[1],
                       'd03': session_data[2], 'd04': session_data[3],
                       'd05': session_data[4], 'd06': session_data[5],
                       'd07': session_data[6], 'd08': session_data[7],
                       'd09': session_data[8], 'd10': session_data[9],
                       'ID': id_col})

    return df


def shared_control_across_sessions(df, ax=None, raw_marker_size=3, es_marker_size=3, succ_color='green', fail_color='black', legend_kwargs=None):

    # arrange data into a pandas dataframe suitable for dabest
    # df = create_dabest_df(session_data)

    if 'outcome' in df.columns:
        idx_list = ['d{:02d}'.format(i_sn+1) for i_sn in range(10)]
        shared_control_long = dabest.load(df, idx=idx_list, x='variable', y='value')
        col_palette = {
            'failed': fail_color,
            'first success': succ_color,
            'other': 'gray'
        }
        if ax == None:
            fig = shared_control_long.mean_diff.plot(color_col='outcome', custom_palette=col_palette, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size)
        else:
            fig = ax.get_figure()
            shared_control_long.mean_diff.plot(color_col='outcome', custom_palette=col_palette, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, ax=ax,
                                               legend_kwargs=legend_kwargs)
    else:
        shared_control = dabest.load(df, idx=("d01", "d02",
                                              "d03", "d04",
                                              "d05", "d06",
                                              "d07", "d08",
                                              "d09", "d10")
                                           )
        if ax == None:
            fig = shared_control.mean_diff.plot(color_col='outcome', custom_palette=col_palette, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size)
        else:
            fig = ax.get_figure()
            shared_control.mean_diff.plot(color_col='outcome', custom_palette=col_palette, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, ax=ax)

    return fig


def paired_data(session_data, sessions_to_compare=("session_01", "session_10")):

    # arrange data into a pandas dataframe suitable for dabest
    df = create_dabest_df(session_data)

    two_groups_paired = dabest.load(df, idx=sessions_to_compare, paired=True, id_col="ID")

    two_groups_paired.mean_diff.plot()


def plot_individual_rats(session_data, axs, ylim, fmt='b-'):

    # data should be in columns
    session_data = np.transpose(session_data)
    for i_rat, rat_data in enumerate(session_data):
        cur_col = int(np.floor(i_rat / 7.0))
        cur_row = int(i_rat % 7.0)

        axs[cur_row, cur_col].plot(rat_data, fmt)
        axs[cur_row, cur_col].set_ylim(ylim[0], ylim[1])

    return axs


def create_secondary_axes(axs):

    new_axs = np.empty_like(axs)
    for i_row, ax_row in enumerate(axs):
        for i_col, ax_col in enumerate(ax_row):
            new_axs[i_row, i_col] = ax_col.twinx()

    return new_axs


def calc_session_stats(reach_data, feature):
    '''

    :param reach_data:
    :param feature:
    :return:
    '''

    # collect all feature values in one array

    # for rd in reach_data:
    if feature in ['orientation', 'orientation_grasp', 'aperture', 'aperture_grasp', 'flexion', 'flexion_grasp']:
        # these are features that occur as lists of vectors
        fv = [rd[feature][0][-1][0] for rd in reach_data]   # fv = feature vector

        pass


def collect_trajectory_variability(ratID, traj_type, parent_kinematics_folder):

    session_dates, session_fnames = mat_data_io.collect_session_data_files(parent_kinematics_folder, ratID)

    traj_variability = []
    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)

        session_traj_variability = calc_mean_dist_from_mean_trajectory(reach_data, traj_type)
        traj_variability.append(session_traj_variability)

    return traj_variability


def collect_endpoint_variability(ratID, traj_type, parent_kinematics_folder):

    pass


def identify_session_success_fail(reach_data):

    outcomes = []
    for i_rd, rd in enumerate(reach_data):

        trial_scores = rd['trial_scores']

        if (4 in trial_scores) or (7 in trial_scores) or (2 in trial_scores):   # pellet remaining, pellet knocked off, or multi-reach success (means first reach failed)
            outcomes.append('failed')
        elif 1 in trial_scores:
            outcomes.append('first success')
        else:
            outcomes.append('other')

    return outcomes


def identify_outcomes(ratID, parent_kinematics_folder):
    session_dates, session_fnames = mat_data_io.collect_session_data_files(parent_kinematics_folder, ratID)

    all_outcomes = []
    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)
        all_outcomes.append(identify_session_success_fail(reach_data))

    return all_outcomes


def collect_digit_trajectory_variability(ratID, traj_type, parent_kinematics_folder):

    session_dates, session_fnames = mat_data_io.collect_session_data_files(parent_kinematics_folder, ratID)

    traj_variability = []
    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)

        session_dig_traj_variability = calc_mean_dist_from_mean_digit_trajectories(reach_data, traj_type)
        traj_variability.append(session_dig_traj_variability)

    return traj_variability


def calc_mean_dist_from_mean_trajectory(reach_data, traj_type):

    # figure out how many points in the trajectory
    sample_trajectory = reach_data[0][traj_type]
    num_points = 100  # np.shape(sample_trajectory)[0]
    num_trajectories = len(reach_data)   # may need to change this if filter out correct/failed trials...

    all_trajectories = np.empty((num_points, 3, num_trajectories))
    for i_rd, rd in enumerate(reach_data):

        if np.any(rd[traj_type]):
            try:
                all_trajectories[:,:,i_rd] = rd[traj_type]
            except ValueError:
                pass
        else:
            all_trajectories[:,:,i_rd] = np.nan

    mean_trajectory = np.nanmean(all_trajectories, 2)

    diff_from_mean_traj = np.empty((num_points, 3, num_trajectories))
    dist_from_mean_traj = np.empty((num_points, num_trajectories))
    mean_dist_from_mean = np.empty(num_trajectories)
    for i_traj in range(num_trajectories):
        diff_from_mean_traj[:,:,i_traj] = np.subtract(all_trajectories[:,:,i_traj], mean_trajectory)
        dist_from_mean_traj[:,i_traj] = np.sqrt(np.sum(np.square(diff_from_mean_traj[:,:,i_traj]), 1))
        mean_dist_from_mean[i_traj] = np.mean(dist_from_mean_traj[:,i_traj])

    return mean_dist_from_mean


def calc_mean_dist_from_mean_digit_trajectories(reach_data, traj_type):

    # this is for digit trajectories
    sample_trajectory = reach_data[0][traj_type]
    num_points = 100 # np.shape(sample_trajectory)[0]
    num_trajectories = len(reach_data)

    all_trajectories = np.empty((num_points, 3, 4, num_trajectories))

    for i_rd, rd in enumerate(reach_data):
        if rd[traj_type].any():
            all_trajectories[:,:,:,i_rd] = rd[traj_type]
        else:
            all_trajectories[:, :, :, i_rd] = np.nan

    mean_trajectory = np.empty((num_points,3,4))
    diff_from_mean_traj = np.empty((num_points, 3, 4, num_trajectories))
    dist_from_mean_traj = np.empty((num_points, 4, num_trajectories))
    mean_dist_from_mean = np.empty((4, num_trajectories))
    for i_dig in range(4):
        temp = np.squeeze(all_trajectories[:,:,i_dig,:])
        mean_trajectory[:,:,i_dig] = np.nanmean(temp, 2)

        for i_traj in range(num_trajectories):
            diff_from_mean_traj[:,:,i_dig,i_traj] = np.subtract(np.squeeze(all_trajectories[:,:,i_dig,i_traj]),
                                                              np.squeeze(mean_trajectory[:,:,i_dig]))
            cur_diff = np.squeeze(diff_from_mean_traj[:,:,i_dig,i_traj])
            dist_from_mean_traj[:,i_dig,i_traj] = np.sqrt(np.sum(np.square(cur_diff), 1))
            mean_dist_from_mean[i_dig,i_traj] = np.mean(np.squeeze(dist_from_mean_traj[:,i_dig,i_traj]))

    return mean_dist_from_mean


def collect_end_parameter(ratID, end_parameter, kinematics_base_folder):

    session_dates, session_fnames = mat_data_io.collect_session_data_files(kinematics_base_folder, ratID)

    end_param_values = []
    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)

        ep_values = collect_end_values(reach_data, end_parameter)
        end_param_values.append(ep_values)

    return end_param_values


def collect_end_values(reach_data, end_parameter):

    ev = []
    for i_rd, rd in enumerate(reach_data):
        if len(rd[end_parameter]) > 0:
            try:
                len(rd[end_parameter][0])
                # if the above throws an error, ignore this trial
                if len(rd[end_parameter][0]) > 0:
                    try:
                        ev.append(rd[end_parameter][0][-1][0])
                    except IndexError:
                        ev.append(np.nan)
                else:
                    ev.append(np.nan)
            except TypeError:
                ev.append(np.nan)
        else:
            ev.append(np.nan)

    return ev


def collect_pd_endpoints(ratID, kinematics_base_folder):

    session_dates, session_fnames = mat_data_io.collect_session_data_files(kinematics_base_folder, ratID)

    reach_end_pts = []
    grasp_end_pts = []
    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)

        cur_reach_endpts = get_pd_endpts(reach_data, 'pd_endpts_reach')
        reach_end_pts.append(cur_reach_endpts)

        cur_grasp_endpts = get_pd_endpts(reach_data, 'pd_endpts_graspstart')
        grasp_end_pts.append(cur_grasp_endpts)

    return reach_end_pts, grasp_end_pts


def collect_dig_endpoints(ratID, kinematics_base_folder, dig_idx=1):
    session_dates, session_fnames = mat_data_io.collect_session_data_files(kinematics_base_folder, ratID)

    reach_end_pts = []
    grasp_end_pts = []

    for session_file in session_fnames:
        session_info, reach_data = mat_data_io.import_session_summary(session_file)

        cur_reach_endpts = get_dig_endpts(reach_data, 'dig_endpoints_reach', dig_idx=dig_idx)
        reach_end_pts.append(cur_reach_endpts)

        cur_grasp_endpts = get_dig_endpts(reach_data, 'dig_endpoints_grasp', dig_idx=dig_idx)
        grasp_end_pts.append(cur_grasp_endpts)

    return reach_end_pts, grasp_end_pts


def get_pd_endpts(reach_data, pos_key):

    pd_endpts = []
    for i_rd, rd in enumerate(reach_data):
        try:
            cur_pt = rd[pos_key][0]
            pd_endpts.append(cur_pt)
        except IndexError:
            pd_endpts.append(np.array([np.nan for ii in range(3)]))

    return np.array(pd_endpts)


def get_dig_endpts(reach_data, pos_key, dig_idx=1):
    '''
    extract digit endpoints from reach_data structure (contains individual trial-level data)
    :param reach_data:
    :param pos_key:
    :param dig_idx:
    :return:
    '''
    dig_endpts = []
    for i_rd, rd in enumerate(reach_data):
        try:
            cur_pt = rd[pos_key][0][dig_idx]
            dig_endpts.append(cur_pt)
        except IndexError:
            dig_endpts.append(np.array([np.nan for ii in range(3)]))

    return np.array(dig_endpts)


def create_multigroup_df(learner_summary, nonlearner_summary, param_name):

    learner_data = learner_summary[param_name]
    nonlearner_data = nonlearner_summary[param_name]

    return organize_multigroup_df(learner_data, nonlearner_data)


def organize_multigroup_df(learner_data, nonlearner_data):
    '''

    :param learner_data: num_sessions x num_learner_rats array
    :param nonlearner_data: num_sessions x num_nonlearner_rats array
    :return:
    '''
    learner_session_list = ['l {:02d}'.format(i_sn+1) for i_sn in range(10)]
    nonlearner_session_list = ['nl {:02d}'.format(i_sn + 1) for i_sn in range(10)]

    learner_d = dict([(learner_session_list[i_sn], learner_data[i_sn, :]) for i_sn in range(10)])
    nonlearner_d = dict([(nonlearner_session_list[i_sn], nonlearner_data[i_sn, :]) for i_sn in range(10)])
    merged_d = {**learner_d, **nonlearner_d}
    # df = pd.DataFrame(merged_d)
    try:
        df = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in merged_d.items()]))
    except ValueError:
        pass

    return df


def summarize_trajectory_variability(rat_list, learning_rats,  kinematics_base_folder):

    num_sessions = 10
    traj_type = 'segmented_pd_trajectory_reach'
    # save_folder = os.path.join(figs_base_folder, traj_type)
    # if not os.path.isdir(save_folder):
    #     os.makedirs(save_folder)
    num_learners = len(learning_rats)
    num_nonlearners = len(rat_list) - num_learners
    l_traj_variability = np.empty((num_sessions, num_learners))
    nl_traj_variability = np.empty((num_sessions, num_nonlearners))
    all_traj_variability = np.empty((num_sessions, len(rat_list)))

    i_learner = 0
    i_nonlearner = 0
    for i_rat, rat_num in enumerate(rat_list):
        ratID = 'R{:04d}'.format(rat_num)

        traj_variability = collect_trajectory_variability(ratID, traj_type, kinematics_base_folder)
        # traj_variability contains the mean distance from the mean trajectory for each trial across sessions

        for i_session, tv in enumerate(traj_variability):
            all_traj_variability[i_session, i_rat] = np.nanmean(tv)

        if rat_num in learning_rats:
            for i_session, tv in enumerate(traj_variability):
                l_traj_variability[i_session, i_learner] = np.nanmean(tv)
            i_learner += 1
        else:
            for i_session, tv in enumerate(traj_variability):
                nl_traj_variability[i_session, i_nonlearner] = np.nanmean(tv)
            i_nonlearner += 1

    return l_traj_variability, nl_traj_variability, all_traj_variability



def summarize_endpoint_variability(rat_list, learning_rats,  kinematics_base_folder, figs_base_folder):

    num_sessions = 10
    traj_type = 'segmented_pd_trajectory_reach'
    # save_folder = os.path.join(figs_base_folder, traj_type)
    # if not os.path.isdir(save_folder):
    #     os.makedirs(save_folder)
    num_rats = len(rat_list)
    num_learners = len(learning_rats)
    num_nonlearners = num_rats - num_learners

    all_pd_endpt_var = {'axis_vars_reach': np.empty((num_sessions, num_rats, 3)),
                      'gen_var_reach': np.empty((num_sessions, num_rats)),
                      'axis_vars_grasp': np.empty((num_sessions, num_rats, 3)),
                      'gen_var_grasp': np.empty((num_sessions, num_rats))
    }
    l_pd_endpt_var = {'axis_vars_reach': np.empty((num_sessions, num_learners, 3)),
                      'gen_var_reach': np.empty((num_sessions, num_learners)),
                      'axis_vars_grasp': np.empty((num_sessions, num_learners, 3)),
                      'gen_var_grasp': np.empty((num_sessions, num_learners))
    }
    nl_pd_endpt_var = {'axis_vars_reach': np.empty((num_sessions, num_nonlearners, 3)),
                      'gen_var_reach': np.empty((num_sessions, num_nonlearners)),
                      'axis_vars_grasp': np.empty((num_sessions, num_nonlearners, 3)),
                      'gen_var_grasp': np.empty((num_sessions, num_nonlearners))
    }
    all_dig_endpt_var = {'axis_vars_reach': [np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3))],
                       'gen_var_reach': [np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats))],
                       'axis_vars_wrt_pd_reach': [np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3))],
                       'gen_var_wrt_pd_reach': [np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats))],
                       'axis_vars_grasp': [np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3))],
                       'gen_var_grasp': [np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats))],
                       'axis_vars_wrt_pd_grasp': [np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3)),np.empty((num_sessions, num_rats, 3))],
                       'gen_var_wrt_pd_grasp': [np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats)),np.empty((num_sessions, num_rats))]
                       }
    l_dig_endpt_var = {'axis_vars_reach': [np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3))],
                       'gen_var_reach': [np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners))],
                       'axis_vars_wrt_pd_reach': [np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3))],
                       'gen_var_wrt_pd_reach': [np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners))],
                       'axis_vars_grasp': [np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3))],
                       'gen_var_grasp': [np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners))],
                       'axis_vars_wrt_pd_grasp': [np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3)),np.empty((num_sessions, num_learners, 3))],
                       'gen_var_wrt_pd_grasp': [np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners)),np.empty((num_sessions, num_learners))]
                       }
    nl_dig_endpt_var = {'axis_vars_reach': [np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3))],
                       'gen_var_reach': [np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners))],
                       'axis_vars_wrt_pd_reach': [np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3))],
                       'gen_var_wrt_pd_reach': [np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners))],
                       'axis_vars_grasp': [np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3))],
                       'gen_var_grasp': [np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners))],
                       'axis_vars_wrt_pd_grasp': [np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3)),np.empty((num_sessions, num_nonlearners, 3))],
                       'gen_var_wrt_pd_grasp': [np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners)),np.empty((num_sessions, num_nonlearners))]
                       }

    i_learner = 0
    i_nonlearner = 0

    for i_rat, rat_num in enumerate(rat_list):
        ratID = 'R{:04d}'.format(rat_num)

        pd_reach_end_pts, pd_grasp_end_pts = collect_pd_endpoints(ratID, kinematics_base_folder)
        num_sessions = len(pd_reach_end_pts)
        # calculate variability along x, y, and z

        for i_session in range(num_sessions):
            cur_pd_reach_endpts = pd_reach_end_pts[i_session][~np.isnan(pd_reach_end_pts[i_session]).any(axis=1)]
            pd_reach_session_cov = np.cov(cur_pd_reach_endpts.T)

            all_pd_endpt_var['axis_vars_reach'][i_session, i_rat, :] = [pd_reach_session_cov[ii][ii] for ii in range(3)]  # diagonals of covariance matrix are variance along each direction
            all_pd_endpt_var['gen_var_reach'][i_session, i_rat] = np.linalg.det(pd_reach_session_cov)

            cur_pd_grasp_endpts = pd_reach_end_pts[i_session][~np.isnan(pd_grasp_end_pts[i_session]).any(axis=1)]
            pd_grasp_session_cov = np.cov(cur_pd_grasp_endpts.T)

            all_pd_endpt_var['axis_vars_grasp'][i_session, i_rat, :] = [pd_grasp_session_cov[ii][ii] for ii in range(3)]  # diagonals of covariance matrix are variance along each direction
            all_pd_endpt_var['gen_var_grasp'][i_session, i_rat] = np.linalg.det(pd_grasp_session_cov)

            for i_dig in range(4):
                dig_reach_end_pts, dig_grasp_end_pts = collect_dig_endpoints(ratID, kinematics_base_folder,
                                                                             dig_idx=i_dig)
                # eliminate rows with NaNs
                cur_dig_reach_end_pts = dig_reach_end_pts[i_session][
                    ~np.isnan(dig_reach_end_pts[i_session]).any(axis=1)]
                dig_reach_session_cov = np.cov(np.transpose(cur_dig_reach_end_pts))
                all_dig_endpt_var['axis_vars_reach'][i_dig][i_session, i_rat, :] = [dig_reach_session_cov[ii][ii] for ii in range(3)]
                all_dig_endpt_var['gen_var_reach'][i_dig][i_session, i_rat] = np.linalg.det(dig_reach_session_cov)

                dig_reach_end_pts_wrt_pd = dig_reach_end_pts[i_session] - pd_reach_end_pts[i_session]
                cur_dig_reach_end_pts_wrt_pd = dig_reach_end_pts_wrt_pd[~np.isnan(dig_reach_end_pts_wrt_pd).any(axis=1)]
                dig_reach_session_wrt_pd_cov = np.cov(np.transpose(cur_dig_reach_end_pts_wrt_pd))
                all_dig_endpt_var['axis_vars_wrt_pd_reach'][i_dig][i_session, i_rat, :] = [dig_reach_session_wrt_pd_cov[ii][ii] for ii in range(3)]
                all_dig_endpt_var['gen_var_wrt_pd_reach'][i_dig][i_session, i_rat] = np.linalg.det(dig_reach_session_wrt_pd_cov)

                cur_dig_grasp_end_pts = dig_grasp_end_pts[i_session][~np.isnan(dig_grasp_end_pts[i_session]).any(axis=1)]
                dig_grasp_session_cov = np.cov(np.transpose(cur_dig_grasp_end_pts))
                all_dig_endpt_var['axis_vars_grasp'][i_dig][i_session, i_rat, :] = [dig_grasp_session_cov[ii][ii] for ii in range(3)]
                all_dig_endpt_var['gen_var_grasp'][i_dig][i_session, i_rat] = np.linalg.det(dig_grasp_session_cov)

                dig_grasp_end_pts_wrt_pd = dig_grasp_end_pts[i_session] - pd_grasp_end_pts[i_session]
                cur_dig_grasp_end_pts_wrt_pd = dig_reach_end_pts_wrt_pd[~np.isnan(dig_grasp_end_pts_wrt_pd).any(axis=1)]
                dig_grasp_session_wrt_pd_cov = np.cov(np.transpose(cur_dig_grasp_end_pts_wrt_pd))
                all_dig_endpt_var['axis_vars_wrt_pd_grasp'][i_dig][i_session, i_rat, :] = [dig_grasp_session_wrt_pd_cov[ii][ii] for ii in range(3)]
                all_dig_endpt_var['gen_var_wrt_pd_grasp'][i_dig][i_session, i_rat] = np.linalg.det(dig_grasp_session_wrt_pd_cov)

            if rat_num in learning_rats:
                # pd_reach_session_cov = np.cov(pd_reach_end_pts[i_session].T)
                l_pd_endpt_var['axis_vars_reach'][i_session, i_learner, :] = all_pd_endpt_var['axis_vars_reach'][i_session, i_rat, :]   # diagonals of covariance matrix are variance along each direction
                l_pd_endpt_var['gen_var_reach'][i_session, i_learner] = all_pd_endpt_var['gen_var_reach'][i_session, i_rat]

                l_pd_endpt_var['axis_vars_grasp'][i_session, i_learner, :] = [pd_grasp_session_cov[ii][ii] for ii in range(3)]   # diagonals of covariance matrix are variance along each direction
                l_pd_endpt_var['gen_var_grasp'][i_session, i_learner] = all_pd_endpt_var['gen_var_grasp'][i_session, i_rat]

                for i_dig in range(4):
                    l_dig_endpt_var['axis_vars_reach'][i_dig][i_session, i_learner, :] = all_dig_endpt_var['axis_vars_reach'][i_dig][i_session, i_rat, :]
                    l_dig_endpt_var['gen_var_reach'][i_dig][i_session, i_learner] = all_dig_endpt_var['gen_var_reach'][i_dig][i_session, i_rat]

                    l_dig_endpt_var['axis_vars_wrt_pd_reach'][i_dig][i_session, i_learner, :] = all_dig_endpt_var['axis_vars_wrt_pd_reach'][i_dig][i_session, i_rat, :]
                    l_dig_endpt_var['gen_var_wrt_pd_reach'][i_dig][i_session, i_learner] = all_dig_endpt_var['gen_var_wrt_pd_reach'][i_dig][i_session, i_rat]

                    l_dig_endpt_var['axis_vars_grasp'][i_dig][i_session, i_learner, :] = all_dig_endpt_var['axis_vars_grasp'][i_dig][i_session, i_rat, :]
                    l_dig_endpt_var['gen_var_grasp'][i_dig][i_session, i_learner] = all_dig_endpt_var['gen_var_grasp'][i_dig][i_session, i_rat]

                    l_dig_endpt_var['axis_vars_wrt_pd_grasp'][i_dig][i_session, i_learner, :] = all_dig_endpt_var['axis_vars_wrt_pd_grasp'][i_dig][i_session, i_rat, :]
                    l_dig_endpt_var['gen_var_wrt_pd_grasp'][i_dig][i_session, i_learner] = all_dig_endpt_var['gen_var_wrt_pd_grasp'][i_dig][i_session, i_rat]
            else:
                nl_pd_endpt_var['axis_vars_reach'][i_session, i_nonlearner, :] = all_pd_endpt_var['axis_vars_reach'][i_session, i_rat, :]   # diagonals of covariance matrix are variance along each direction
                nl_pd_endpt_var['gen_var_reach'][i_session, i_nonlearner] = all_pd_endpt_var['gen_var_reach'][i_session, i_rat]

                nl_pd_endpt_var['axis_vars_grasp'][i_session, i_nonlearner, :] = all_pd_endpt_var['axis_vars_grasp'][i_session, i_rat, :]   # diagonals of covariance matrix are variance along each direction
                nl_pd_endpt_var['gen_var_grasp'][i_session, i_nonlearner] = all_pd_endpt_var['gen_var_grasp'][i_session, i_rat]

                for i_dig in range(4):
                    nl_dig_endpt_var['axis_vars_reach'][i_dig][i_session, i_nonlearner, :] = all_dig_endpt_var['axis_vars_reach'][i_dig][i_session, i_rat, :]
                    nl_dig_endpt_var['gen_var_reach'][i_dig][i_session, i_nonlearner] = all_dig_endpt_var['gen_var_reach'][i_dig][i_session, i_rat]

                    nl_dig_endpt_var['axis_vars_wrt_pd_reach'][i_dig][i_session, i_nonlearner, :] = all_dig_endpt_var['axis_vars_wrt_pd_reach'][i_dig][i_session, i_rat, :]
                    nl_dig_endpt_var['gen_var_wrt_pd_reach'][i_dig][i_session, i_nonlearner] = all_dig_endpt_var['gen_var_wrt_pd_reach'][i_dig][i_session, i_rat]

                    nl_dig_endpt_var['axis_vars_grasp'][i_dig][i_session, i_nonlearner, :] = all_dig_endpt_var['axis_vars_grasp'][i_dig][i_session, i_rat, :]
                    nl_dig_endpt_var['gen_var_grasp'][i_dig][i_session, i_nonlearner] = all_dig_endpt_var['gen_var_grasp'][i_dig][i_session, i_rat]

                    nl_dig_endpt_var['axis_vars_wrt_pd_grasp'][i_dig][i_session, i_nonlearner, :] = all_dig_endpt_var['axis_vars_wrt_pd_grasp'][i_dig][i_session, i_rat, :]
                    nl_dig_endpt_var['gen_var_wrt_pd_grasp'][i_dig][i_session, i_nonlearner] = all_dig_endpt_var['gen_var_wrt_pd_grasp'][i_dig][i_session, i_rat]

        if rat_num in learning_rats:
            i_learner += 1
        else:
            i_nonlearner += 1

    return l_pd_endpt_var, nl_pd_endpt_var, l_dig_endpt_var, nl_dig_endpt_var, all_pd_endpt_var, all_dig_endpt_var

