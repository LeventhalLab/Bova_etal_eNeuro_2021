import numpy as np
import mat_data_io
import matplotlib.pyplot as plt
import matplotlib.collections
from matplotlib import gridspec
import eneuro_dabest_analysis
import os


def create_final_plots_fig(figsize=(8.5, 11), nrows=6, ncols=2, figrect=[0.1,0.1,0.9,0.9]):
    '''
    create the figure with plot layouts for an individual rat. Returns a figure handle and list of axes in which to make
     the plots
    :param figsize: size of figure, typically 8.5 x 11 inches
    :param nrows: number of rows of figures
    :param ncols: number of columns of figures
    :param figrect: bounding rectangle within the figure as left, bottom, right, top. Units are in fraction of the
        full figure area
    :return: f - figure object; ax - 2D list of axes objects
    '''

    f = plt.figure(figsize=figsize)
    gs = gridspec.GridSpec(nrows=nrows, ncols=ncols, figure=f, left=figrect[0], bottom=figrect[1], right=figrect[2], top=figrect[3])

    ax = []
    for i_row in range(nrows):
        ax_row = []
        for i_col in range(ncols):
            ax_row.append(f.add_subplot(gs[i_row, i_col]))
        ax.append(ax_row)

    return f, ax


def create_rat_summary_plots(rat_list, learning_rats, kinematics_base_folder, figs_base_folder):

    for rat_num in rat_list:
        final_multiple_plots_per_fig(rat_num, kinematics_base_folder, figs_base_folder)


def set_all_linewidths(ax, lw):
    '''
    create a uniform line width for all lines in a given axes
    :param ax:
    :param lw:
    :return:
    '''

    line_handles = ax.lines

    for lh in line_handles:
        lh.set_linewidth(lw)


def format_sharedcontrol_plot(ax, title, ylabel, swarm_ylim, xticks, xticklabels, contrast_ylim, fontsize, title_y, title_pad, keep_legend=False):
    '''
    standard formatting for each shared control plot - hiding legends, moving ticklabels to the right spot,
    eliminating xticklabels except for the bottom plots, etc.
    :param ax:
    :param title:
    :param ylabel:
    :param swarm_ylim:
    :param xticks:
    :param xticklabels:
    :param contrast_ylim:
    :param fontsize:
    :param title_y:
    :param title_pad:
    :param keep_legend:
    :return:
    '''

    ax.set_title(title, fontsize=fontsize, y=title_y, pad=title_pad, fontweight='bold')
    if 'endpoint' in ylabel:
        ax.set_ylabel(ylabel, fontsize=fontsize, fontweight='bold')
    else:
        ax.set_ylabel(ylabel, fontsize=fontsize)
    ax.set_ylim(swarm_ylim)
    ax.set_yticks(swarm_ylim)
    [ytl.set_fontsize(fontsize) for ytl in ax.get_yticklabels()]

    swarm_yticklabels = ax.yaxis.get_ticklabels()
    swarm_yticklabels[0].set_verticalalignment('bottom')
    swarm_yticklabels[-1].set_verticalalignment('top')

    ax.set_xticks([])
    ax.set_xticklabels([])
    ax.contrast_axes.set_xticks(xticks)
    ax.contrast_axes.set_xticklabels(xticklabels, rotation=45, fontsize=fontsize)
    ax.contrast_axes.set_ylim(contrast_ylim)
    if 0 in contrast_ylim:
        contrast_yticks = contrast_ylim
    else:
        contrast_yticks = [contrast_ylim[0], 0, contrast_ylim[1]]
    ax.contrast_axes.set_yticks(contrast_yticks)
    [ytl.set_fontsize(fontsize) for ytl in ax.contrast_axes.get_yticklabels()]

    contrast_yticklabels = ax.contrast_axes.yaxis.get_ticklabels()
    contrast_yticklabels[0].set_verticalalignment('bottom')
    contrast_yticklabels[-1].set_verticalalignment('top')

    # remove reflines
    # find linecollections in the swarm axes
    swarm_linecollections = [lc for lc in ax.get_children() if isinstance(lc, matplotlib.collections.LineCollection)]
    for lc in swarm_linecollections:
        lc.set_visible(False)

    contrast_linecollections = [lc for lc in ax.contrast_axes.get_children() if isinstance(lc, matplotlib.collections.LineCollection)]
    for lc in contrast_linecollections:
        lc.set_visible(False)

    # draw a vertical black line for the y-axis (shared control plots are offset by 0.5 to create space)
    ax.vlines(-0.5, swarm_ylim[0], swarm_ylim[1], colors='k')
    ax.contrast_axes.vlines(-0.5, contrast_ylim[0], contrast_ylim[1], colors='k')

    ax.contrast_axes.set_ylabel('')

    if not keep_legend:
        ax.get_legend().remove()

    set_all_linewidths(ax, 1)
    set_all_linewidths(ax.contrast_axes, 1)

    l, b, w, h = ax.contrast_axes.get_position().bounds
    ax.contrast_axes.set_position([l, b - .2, w, h])

    ax.tick_params(axis='y', pad=0)
    ax.contrast_axes.tick_params(axis='y', pad=0)


def add_panel_label(ax, panel_letter, xy=(0.01,0.9), fontsize=12):
    '''
    short function to add panel labels in the right spot on plot axes
    :param ax:
    :param panel_letter:
    :param xy:
    :param fontsize:
    :return:
    '''

    ax.annotate(panel_letter, xy, xycoords='axes fraction', fontsize=fontsize, fontweight='bold')


def final_multiple_plots_per_fig(rat_num, kinematics_base_folder, figs_base_folder):
    '''
    master function for creating all the plots in the summary sheet
    :param rat_num: number of the rat for which to make the sheet
    :param kinematics_base_folder:
    :param figs_base_folder:
    :return:
    '''

    alfa = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    panel_label_coords_A = (-0.125, 0.935)
    panel_label_coords_B = (-0.135, 1.1)
    panel_label_coords_C = (-0.125, 1.)
    panel_label_coords_D = (-0.125, 0.94)

    raw_marker_size = 1.25
    es_marker_size = 2

    fig_title_pad = -5
    fontsize = 9

    fig_right_edge = 0.86
    fig_left_edge = 0.14
    fig_bottom = 0.15
    fig_top = 0.9

    top_rect_bottoms = 0.532

    rect_left = 0.095

    mean_dist_swarm_lims = (0, 25)

    rat_list = [216, 218, 221, 222, 283, 309, 310, 311, 312, 383, 384, 385, 386, 387]
    learning_rats = [218, 309, 312, 384]

    ratID = 'R{:04d}'.format(rat_num)
    rat_idx = rat_list.index(rat_num)

    all_outcomes = eneuro_dabest_analysis.identify_outcomes(ratID, kinematics_base_folder)

    fname_learning_summaries = os.path.join(kinematics_base_folder, 'learning_summaries.mat')
    learning_summary = mat_data_io.import_learning_summaries(fname_learning_summaries, 'learning_summary')


    f, ax = create_final_plots_fig(figsize=(8.5, 11), nrows=6, ncols=2, figrect=[fig_left_edge,fig_bottom,fig_right_edge,fig_top])

    if rat_num in learning_rats:
        figtitle = 'rat ' + alfa[rat_list.index(rat_num)] + ', learner'
        succ_color = 'green'
    else:
        figtitle = 'rat ' + alfa[rat_list.index(rat_num)] + ', non-learner'
        succ_color = 'magenta'
    f.suptitle(figtitle, x=0.5, y=0.95)

    # plot success rates
    cur_ax = ax[0][0]
    frs = learning_summary['firstReachSuccess'][:, rat_idx]
    ars = learning_summary['anyReachSuccess'][:, rat_idx]
    cur_ax.plot(frs, color=succ_color)
    cur_ax.plot(ars, color='black')
    cur_ax.set_ylim((0, 1))
    cur_ax.set_yticks([0, 1])
    cur_ax.set_yticklabels([0, 1], fontsize=fontsize)
    cur_ax.set_xticks([i_sn for i_sn in range(10)])
    cur_ax.set_xticklabels([])
    cur_ax.set_ylabel('success rate', fontsize=fontsize)
    cur_ax.legend(['1st reach', 'any reach'], fontsize=fontsize, frameon=False)
    set_all_linewidths(cur_ax, 1)

    succ_pos = cur_ax.get_position().bounds
    cur_ax.set_position([succ_pos[0], succ_pos[1]+0.02, succ_pos[2], succ_pos[3]])
    add_panel_label(cur_ax, 'A', xy=panel_label_coords_A, fontsize=12)

    # plot reach and grasp pd trajectory changes
    cur_ax = ax[1][0]
    traj_type = 'segmented_pd_trajectory_reach'
    traj_variability = eneuro_dabest_analysis.collect_trajectory_variability(ratID, traj_type,
                                                                             kinematics_base_folder)
    df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(traj_variability, all_outcomes)

    eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color)
    format_sharedcontrol_plot(cur_ax,
                              title='distance from mean reach trajectory',
                              ylabel='hand dist (mm)',
                              swarm_ylim=mean_dist_swarm_lims,
                              xticks=[],
                              xticklabels=[],
                              contrast_ylim=[-10, 5],
                              fontsize=fontsize,
                              title_y=1.0,
                              title_pad=5)
    cur_ax.yaxis.set_label_coords(-0.075, -0.1)
    add_panel_label(cur_ax, 'C', xy=panel_label_coords_C, fontsize=12)

    # plot decrease in digit 2 distance from mean trajectory
    cur_ax = ax[2][0]
    traj_type = 'segmented_dig_trajectory_reach'
    dig_to_test = 1
    traj_variability = eneuro_dabest_analysis.collect_digit_trajectory_variability(ratID,
                                                                                   traj_type,
                                                                                   kinematics_base_folder)
    single_dig_variability = [tv[dig_to_test, :] for tv in traj_variability]
    df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(single_dig_variability, all_outcomes)
    legend_kwargs = {'loc': 'upper left',
                     'fontsize': fontsize,
                     'markerscale': 0.5,
                     'labelspacing': 0.25,
                     'ncol': 3,
                     'columnspacing': 1.0,
                     'handletextpad': 0.2,
                     'bbox_to_anchor': (0.0,1.5)}
    eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color,
                                                          legend_kwargs=legend_kwargs)
    format_sharedcontrol_plot(cur_ax,
                              title='',
                              ylabel='digit 2 dist (mm)',
                              swarm_ylim=mean_dist_swarm_lims,
                              xticks=[],
                              xticklabels=[],
                              contrast_ylim=[-10, 5],
                              fontsize=fontsize,
                              title_y=1.0,
                              title_pad=fig_title_pad,
                              keep_legend=True)
    cur_ax.yaxis.set_label_coords(-0.075, -0.1)

    l = rect_left
    b = top_rect_bottoms
    w = 0.38
    h = 0.263

    f.patches.extend([plt.Rectangle((l, b), w, h, fill=False, color='k', transform=f.transFigure, figure=f)])

    reach_endpts, grasp_endpts = eneuro_dabest_analysis.collect_pd_endpoints(ratID, kinematics_base_folder)
    dig_reach_end_pts, dig_grasp_end_pts = eneuro_dabest_analysis.collect_dig_endpoints(ratID, kinematics_base_folder, dig_idx=1)
    ax_list = ['x', 'y', 'z']
    xlim = [-5, 15]
    ylim = [-5, 25]
    zlim = [-25, 5]
    for i_axis, ax_id in enumerate(ax_list):
        if ax_id == 'y':
            reach_ax_endpt = [-ep[:, i_axis] for ep in reach_endpts]
            grasp_ax_endpt = [-ep[:, i_axis] for ep in grasp_endpts]
            dig_reach_ax_endpt = [-ep[:, i_axis]-reach_ax_endpt[i_session] for i_session, ep in enumerate(dig_reach_end_pts)]
            pd_axlim = ylim
            pd_difflim = [-15, 15]
            dig_axlim = [-10, 5]
            dig_difflim = [-5, 5]
        elif ax_id == 'x':
            if np.nanmean(reach_endpts[0][:, 0]) < 0:
                reach_ax_endpt = [-ep[:, i_axis] for ep in reach_endpts]
                grasp_ax_endpt = [-ep[:, i_axis] for ep in grasp_endpts]
                dig_reach_ax_endpt = [-ep[:, i_axis] - reach_ax_endpt[i_session] for i_session, ep in enumerate(dig_reach_end_pts)]
            else:
                reach_ax_endpt = [ep[:, i_axis] for ep in reach_endpts]
                grasp_ax_endpt = [ep[:, i_axis] for ep in grasp_endpts]
                dig_reach_ax_endpt = [ep[:, i_axis] - reach_ax_endpt[i_session] for i_session, ep in enumerate(dig_reach_end_pts)]
            pd_axlim = xlim
            pd_difflim = [-10, 10]
            dig_axlim = [-10, 5]
            dig_difflim = [-5, 5]
        else:
            reach_ax_endpt = [-ep[:, i_axis] for ep in reach_endpts]
            grasp_ax_endpt = [-ep[:, i_axis] for ep in grasp_endpts]
            dig_reach_ax_endpt = [-ep[:, i_axis] - reach_ax_endpt[i_session] for i_session, ep in enumerate(dig_reach_end_pts)]
            pd_axlim = zlim
            pd_difflim = [-10, 10]
            dig_axlim = [5, 20]
            dig_difflim = [-5, 5]

        cur_ax = ax[3+i_axis][0]
        df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(reach_ax_endpt, all_outcomes)
        eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color)
        if i_axis == 2:
            format_sharedcontrol_plot(cur_ax,
                                      title='',
                                      ylabel='',
                                      swarm_ylim=pd_axlim,
                                      xticks=[i_sn for i_sn in range(10)],
                                      xticklabels=['d{:02d}'.format(i_sn + 1) for i_sn in range(10)],
                                      contrast_ylim=pd_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=fig_title_pad)
        elif i_axis == 0:
            format_sharedcontrol_plot(cur_ax,
                                      title='reach endpoint, hand',
                                      ylabel='',
                                      swarm_ylim=pd_axlim,
                                      xticks=[],
                                      xticklabels=[],
                                      contrast_ylim=pd_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=0)
        else:
            format_sharedcontrol_plot(cur_ax,
                                      title='',
                                      ylabel='',
                                      swarm_ylim=pd_axlim,
                                      xticks=[],
                                      xticklabels=[],
                                      contrast_ylim=pd_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=fig_title_pad)
        # cur_ax.annotate('x', (0.5, 0.4), xycoords='figure fraction', va='bottom', ha='center', fontweight='bold')

        cur_ax = ax[3 + i_axis][1]
        df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(dig_reach_ax_endpt, all_outcomes)
        eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size,
                                                              es_marker_size=es_marker_size, succ_color=succ_color)
        if i_axis == 2:
            format_sharedcontrol_plot(cur_ax,
                                      title='',
                                      ylabel=ax_id + ' endpoint (mm)',
                                      swarm_ylim=dig_axlim,
                                      xticks=[i_sn for i_sn in range(10)],
                                      xticklabels=['d{:02d}'.format(i_sn + 1) for i_sn in range(10)],
                                      contrast_ylim=dig_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=fig_title_pad)
        elif i_axis == 0:
            format_sharedcontrol_plot(cur_ax,
                                      title='reach endpoint w.r.t. hand, digit 2',
                                      ylabel=ax_id + ' endpoint (mm)',
                                      swarm_ylim=dig_axlim,
                                      xticks=[],
                                      xticklabels=[],
                                      contrast_ylim=dig_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=0)
        else:
            format_sharedcontrol_plot(cur_ax,
                                      title='',
                                      ylabel=ax_id + ' endpoint (mm)',
                                      swarm_ylim=dig_axlim,
                                      xticks=[],
                                      xticklabels=[],
                                      contrast_ylim=dig_difflim,
                                      fontsize=fontsize,
                                      title_y=1.0,
                                      title_pad=fig_title_pad)
        cur_ax.yaxis.set_label_coords(-0.1, -0.1)

    add_panel_label(ax[3][0], 'D', xy=panel_label_coords_D, fontsize=12)

    tl_pos = ax[3][0].get_position().bounds
    br_pos = ax[5][1].get_position().bounds

    # l = tl_pos[0] - 0.1
    # b = br_pos[1]
    # w = br_pos[0] + br_pos[2]
    # h = tl_pos[1] + tl_pos[3]

    l = rect_left
    b = fig_bottom - 0.04
    w = fig_right_edge - l + 0.01
    h = 0.418

    f.patches.extend([plt.Rectangle((l, b), w, h, fill=False, color='k', transform=f.transFigure, figure=f)])

    # plot aperture
    cur_ax = ax[0][1]
    end_parameter = 'aperture'
    end_param_values = eneuro_dabest_analysis.collect_end_parameter(ratID, end_parameter, kinematics_base_folder)
    df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(end_param_values, all_outcomes)
    eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color)
    format_sharedcontrol_plot(cur_ax,
                              title='hand shape at reach end',
                              ylabel='aperture (mm)',
                              swarm_ylim=[5, 25],
                              xticks=[],
                              xticklabels=[],
                              contrast_ylim=[-7, 7],
                              fontsize=fontsize,
                              title_y=1.0,
                              title_pad=5)
    cur_ax.yaxis.set_label_coords(-0.1, -0.1)
    add_panel_label(cur_ax, 'B', xy=panel_label_coords_B, fontsize=12)

    # plot orientation
    cur_ax = ax[1][1]
    end_parameter = 'orientation'
    end_param_values = eneuro_dabest_analysis.collect_end_parameter(ratID, end_parameter, kinematics_base_folder)
    # convert to degrees
    for i_epv, epv in enumerate(end_param_values):
        end_param_values[i_epv] = [ep * 180 / np.pi for ep in epv]
        # if angles are > 90 degrees, must be left-pawed. Switch to right-pawed orientation
        if np.nanmean(end_param_values[i_epv]) > 90:
            end_param_values[i_epv] = 180. - np.array(end_param_values[i_epv])
    df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(end_param_values, all_outcomes)
    eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color)
    format_sharedcontrol_plot(cur_ax,
                              title='',
                              ylabel='orientation (deg)',
                              swarm_ylim=[0, 90],
                              xticks=[],
                              xticklabels=[],
                              contrast_ylim=[-30, 30],
                              fontsize=fontsize,
                              title_y=1.0,
                              title_pad=fig_title_pad)
    cur_ax.yaxis.set_label_coords(-0.1, -0.1)

    # plot digit flexion
    cur_ax = ax[2][1]
    end_parameter = 'flexion'
    end_param_values = eneuro_dabest_analysis.collect_end_parameter(ratID, end_parameter, kinematics_base_folder)
    df = eneuro_dabest_analysis.create_independent_samples_with_outcomes_df(end_param_values, all_outcomes)
    eneuro_dabest_analysis.shared_control_across_sessions(df, ax=cur_ax, raw_marker_size=raw_marker_size, es_marker_size=es_marker_size, succ_color=succ_color)
    format_sharedcontrol_plot(cur_ax,
                              title='',
                              ylabel='flexion (deg)',
                              swarm_ylim=[0, 90],
                              xticks=[],
                              xticklabels=[],
                              contrast_ylim=[-30, 30],
                              fontsize=fontsize,
                              title_y=1.0,
                              title_pad=fig_title_pad)
    cur_ax.yaxis.set_label_coords(-0.1, -0.1)

    l = 0.48
    b = top_rect_bottoms
    w = fig_right_edge - l + 0.01
    h = 0.393
    f.patches.extend([plt.Rectangle((l, b), w, h, fill=False, color='k', transform=f.transFigure, figure=f)])

    fname = os.path.join(figs_base_folder, ratID + '_final_summary.pdf')
    fname = os.path.join(figs_base_folder, 'ExtendedDataFigure6-{:d}'.format(rat_list.index(rat_num) + 3) + '.pdf')
    plt.savefig(fname)
    plt.close(f)


def create_multigroup_color_palette(learner_color='green', nonlearner_color='magenta'):
    learner_palette = dict([('l {:02d}'.format(i_sn + 1), learner_color) for i_sn in range(10)])
    nonlearner_palette = dict([('nl {:02d}'.format(i_sn + 1), nonlearner_color) for i_sn in range(10)])
    return {**learner_palette, **nonlearner_palette}