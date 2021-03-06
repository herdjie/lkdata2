# view: ltv_model_all_campaigns_v2 {
#   derived_table: {
#     persist_for: "10 minutes"
#     # datagroup_trigger: tenjin_test2_model_datagroup
#     sql: select a.campaign_name, a.ad_networks_name, ln(a.days_since_install) as days_since_install,ln(a.daily_active_users/b.daily_active_users) as Retention from
#           ( SELECT cast(campaigns.name as STRING) as campaign_name,
#           cast(ad_networks.name as STRING)  AS ad_networks_name,
#               CAST(reporting_cohort_metrics.days_since_install AS INT64) AS days_since_install,
#               CAST(SUM(reporting_cohort_metrics.daily_active_users ) AS INT64) AS daily_active_users
#             FROM tenjin_BigQuery.reporting_cohort_metrics  AS reporting_cohort_metrics
#             LEFT JOIN tenjin_BigQuery.campaigns  AS campaigns ON reporting_cohort_metrics.campaign_id = campaigns.id
#             LEFT JOIN tenjin_BigQuery.apps  AS apps ON campaigns.app_id = apps.id
#             LEFT JOIN tenjin_BigQuery.ad_networks  AS ad_networks ON campaigns.ad_network_id = ad_networks.id

#             WHERE (reporting_cohort_metrics.install_date ) < (DATE_ADD(CURRENT_DATE(), interval -3 month))
#             and (reporting_cohort_metrics.install_date ) >= (DATE_ADD(CURRENT_DATE(), interval -15 month))
#             and (apps.bundle_id = 'com.luckykat.kaijurush') AND (apps.platform = 'ios')
#             and reporting_cohort_metrics.days_since_install>0
#             GROUP BY 1,2,3
#             ORDER BY 1,2,3) as a inner join ( SELECT cast(campaigns.name as STRING) as campaign_name,
#             cast(ad_networks.name as STRING)  AS ad_networks_name,

#               CAST(SUM(reporting_cohort_metrics.daily_active_users ) AS INT64) AS daily_active_users
#             FROM tenjin_BigQuery.reporting_cohort_metrics  AS reporting_cohort_metrics
#             LEFT JOIN tenjin_BigQuery.campaigns  AS campaigns ON reporting_cohort_metrics.campaign_id = campaigns.id
#             LEFT JOIN tenjin_BigQuery.apps  AS apps ON campaigns.app_id = apps.id
#             LEFT JOIN tenjin_BigQuery.ad_networks  AS ad_networks ON campaigns.ad_network_id = ad_networks.id

#             WHERE (reporting_cohort_metrics.install_date ) < (DATE_ADD(CURRENT_DATE(), interval -3 month))
#             and (reporting_cohort_metrics.install_date ) >= (DATE_ADD(CURRENT_DATE(), interval -15 month))
#             and (apps.bundle_id = 'com.luckykat.kaijurush') AND (apps.platform = 'ios')
#             and reporting_cohort_metrics.days_since_install=0
#             GROUP BY 1,2
#             ORDER BY 1,2
#             ) as b on a.campaign_name=b.campaign_name and a.ad_networks_name=b.ad_networks_name where a.daily_active_users>0
#                 ;;
#   }

#   dimension: campaign_name {type: string}
#   dimension: ad_networks_name {type: string}

#   dimension: days_since_install {type: number}
#   dimension: days_since_install_final {type: number
#     sql: round(exp(${days_since_install}),0);;
#   }
#   dimension: Retention {type:number}
#   measure:  Ret {type:sum
#     sql:${Retention};;}
#   dimension: Retention_final {type: number
#     sql: exp(${Retention});;
#   }

# }
# explore: ltv_model_all_campaigns_v2 {}

# view: ltv_reg_v2 {
#   derived_table: {
#     persist_for: "24 hours"
#     #datagroup_trigger: tenjin_test2_model_datagroup
#     sql_create:
#       CREATE OR REPLACE MODEL
#         ${SQL_TABLE_NAME}
#       OPTIONS
#           ( model_type='linear_reg',
#             labels=['Retention'],
#             min_rel_progress = 0.00001,
#             max_iteration = 50 )
#       AS
#       SELECT
#         *
#       FROM
#         ${ltv_model_all_campaigns_v2.SQL_TABLE_NAME}
#     ;;
#   }
# }



# explore: ltv_eval_v2 {}
# explore: ltv_reg_v2 {}

# view: ltv_eval_v2 {
#   derived_table: {
#     sql:
#       Select
#       *
#       FROM
#       ML.EVALUATE(MODEL ${ltv_reg_v2.SQL_TABLE_NAME}),
#       (SELECT
#         *
#       FROM
#         ${ltv_model_all_campaigns_v2.SQL_TABLE_NAME});;
#   }
#   dimension: mean_absolute_error {type: number}
#   dimension: mean_squared_error {type: number}
#   dimension: mean_squared_log_error {type: number}
#   dimension: median_absolute_error {type: number}
#   dimension: r2_score {type: number}
#   dimension: explained_variance {type: number}
# }

# view: ltv_train_v2 {
#   derived_table: {
#     sql:
#       Select
#       *
#       FROM
#       ML.TRAINING_INFO(MODEL ${ltv_reg_v2.SQL_TABLE_NAME}),
#       (SELECT
#         *
#       FROM
#         ${ltv_model_all_campaigns_v2.SQL_TABLE_NAME});;
#   }
#   dimension: training_run {type: number}
#   dimension: iteration {type: number}
#   dimension: loss {type: number}
#   dimension: eval_loss {type: number}
#   dimension: duration_ms {label:"Duration (ms)" type: number}
#   dimension: learning_rate{type: number}
#   measure: iterations {type: count}
#   measure: total_loss {type: sum sql:${loss} ;;}
# }

# explore: ltv_train_v2 {}
# explore: ltv_pred_v2 {
#   join: ltv_model_all_campaigns_v2 {
#     type: left_outer
#     sql_on: ${ltv_pred_v2.campaign_name} = ${ltv_model_all_campaigns_v2.campaign_name} and
#       ${ltv_pred_v2.days_since_install_final} = ${ltv_model_all_campaigns_v2.days_since_install_final};;
#     relationship: many_to_one
#   }

# }

# view: ltv_pred_all_campaigns_v2 {
#   derived_table: {
#     persist_for: "10 minutes"
#     # datagroup_trigger: tenjin_test2_model_datagroup
#     sql: SELECT
#       b.campaign_name, b.ad_networks_name, ln(a.days_since_install) as days_since_install

#       FROM  (select CAST(reporting_cohort_metrics.days_since_install AS INT64)  AS days_since_install from tenjin_BigQuery.reporting_cohort_metrics  AS reporting_cohort_metrics
#       LEFT JOIN tenjin_BigQuery.campaigns  AS campaigns ON reporting_cohort_metrics.campaign_id = campaigns.id
#       LEFT JOIN tenjin_BigQuery.apps  AS apps ON campaigns.app_id = apps.id
#       where reporting_cohort_metrics.days_since_install>0 and days_since_install<=365
#       GROUP BY 1
#       ORDER BY 1) as a cross join
#       (select cast(campaigns.name as STRING) as campaign_name,
#       cast(ad_networks.name as STRING)  AS ad_networks_name
#       from tenjin_BigQuery.reporting_cohort_metrics  AS reporting_cohort_metrics
#       LEFT JOIN tenjin_BigQuery.campaigns  AS campaigns ON reporting_cohort_metrics.campaign_id = campaigns.id
#       LEFT JOIN tenjin_BigQuery.apps  AS apps ON campaigns.app_id = apps.id
#       LEFT JOIN tenjin_BigQuery.ad_networks  AS ad_networks ON campaigns.ad_network_id = ad_networks.id

#       WHERE (reporting_cohort_metrics.install_date ) < (DATE_ADD(CURRENT_DATE(), interval -3 month))
#             and (reporting_cohort_metrics.install_date ) >= (DATE_ADD(CURRENT_DATE(), interval -15 month))
#             and (apps.bundle_id = 'com.luckykat.kaijurush') AND (apps.platform = 'ios')
#       GROUP BY 1,2
#       ORDER BY 1,2
#       ) as b
#           ;;
#   }

#   dimension: campaign_name {type: string}
#   dimension: ad_networks_name {type: string}

#   dimension: days_since_install {type: number}
# #   measure: daily_user {type:sum
# #     sql: ${TABLE}.daily_user ;;
# #   }

# }
# explore: ltv_pred_all_campaigns_v2 {}

# view: ltv_pred_v2 {
#   derived_table: {
#     sql:
#       Select
#       *
#       FROM
#       ML.PREDICT(MODEL ${ltv_reg_v2.SQL_TABLE_NAME},
#       (SELECT
#         *
#       FROM
#         ${ltv_pred_all_campaigns_v2.SQL_TABLE_NAME}));;
#   }
#   dimension: campaign_name {type: string}
#   dimension: ad_networks_name {type: string}
#   measure: Channel_count {type: count_distinct
#     sql: ${ad_networks_name};;}
#   dimension: days_since_install {type: number}
#   dimension: days_since_install_final {type: number
#     sql:round(exp(${days_since_install}),0);;}

#   dimension: predicted_Retention {type: number}
#   dimension: predicted_Ret_final {type:number
#     sql: exp(${predicted_Retention});; }

# }

# # If necessary, uncomment the line below to include explore_source.

# # include: "ltv_model_all_campaigns.view.lkml"

# view: ltv_pred_final_v2 {
#   derived_table: {
#     explore_source: ltv_pred_v2 {
#       column: ad_networks_name {}
#       column: campaign_name {}
#       column: days_since_install {}
#       column: days_since_install_final {}
#       column: Retention { field: ltv_model_all_campaigns_v2.Retention }
#       column: Retention_final { field: ltv_model_all_campaigns_v2.Retention_final }
#       column: predicted_Retention {}
#       column: predicted_Ret_final {}
#     }
#   }
#   dimension: ad_networks_name {}
#   dimension: campaign_name {}
#   dimension: days_since_install {
#     type: number
#   }
#   dimension: days_since_install_final {
#     type: number
#   }
#   dimension: Retention {
#     type: number
#   }
#   dimension: Retention_final {
#     type: number
#   }
#   dimension: predicted_Retention {
#     type: number
#   }
#   dimension: predicted_Ret_final {
#     type: number
#   }
#   dimension: Pred_actual_Ret { type: number
#     sql: case when ${Retention_final} is null then ${predicted_Ret_final} else ${Retention_final} end  ;;
#   }
#   measure: Pred_actual_Ret_measure {type:sum
#     sql:${Pred_actual_Ret};;}
# }

# explore: ltv_pred_final_v2 {}
