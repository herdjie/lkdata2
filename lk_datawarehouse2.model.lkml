connection: "lk-datawarehouse"

# include all the views
include: "*.view"

datagroup: lk_datawarehouse2_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: lk_datawarehouse2_default_datagroup

explore: ad_engagements {
  join: apps {
    type: left_outer
    sql_on: ${ad_engagements.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${ad_engagements.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: ad_networks {}

explore: apps {}

explore: ltv_for_14_30_60_and_90_days {
  join: ad_networks {
    type: left_outer
    sql_on: ${ltv_for_14_30_60_and_90_days.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${ltv_for_14_30_60_and_90_days.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${ltv_for_14_30_60_and_90_days.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }
  }

explore: bucket_campaign_info {
  join: apps {
    type: left_outer
    sql_on: ${bucket_campaign_info.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${bucket_campaign_info.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: campaign_buckets {
  join: apps {
    type: left_outer
    sql_on: ${campaign_buckets.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaign_buckets.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: campaigns {
  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: campaigns_targeting_tags {
  join: targeting_tags {
    type: left_outer
    sql_on: ${campaigns_targeting_tags.targeting_tag_id} = ${targeting_tags.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${campaigns_targeting_tags.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: cohort_behavior {
  join: campaigns {
    type: left_outer
    sql_on: ${cohort_behavior.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }

  join: ltv_predict{
    type: left_outer
    sql_on: ${cohort_behavior.xday} = ${ltv_predict.xday} ;;
    relationship: many_to_one
  }
}

explore: countries {}

explore: daily_ad_revenue {
  join: publisher_apps {
    type: left_outer
    sql_on: ${daily_ad_revenue.publisher_app_id} = ${publisher_apps.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${publisher_apps.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${publisher_apps.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: daily_behavior {
  join: campaigns {
    type: left_outer
    sql_on: ${daily_behavior.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: daily_country_spend {
  join: campaigns {
    type: left_outer
    sql_on: ${daily_country_spend.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: daily_spend {
  join: campaigns {
    type: left_outer
    sql_on: ${daily_spend.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${campaigns.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${campaigns.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: events {
  join: apps {
    type: left_outer
    sql_on: ${events.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }
}

explore: game_analytics {
  label: "Game Analytics"
}

explore: pg_aggregate {}

explore: pg_am {}

explore: pg_amop {}

explore: pg_amproc {}

explore: pg_attrdef {}

explore: pg_attribute {}

explore: pg_bar_repos {}

explore: pg_cast {}

explore: pg_class {}

explore: pg_conf {}

explore: pg_constraint {}

explore: pg_conversion {}

explore: pg_default_acl {}

explore: pg_depend {}

explore: pg_description {}

explore: pg_highwatermark {}

explore: pg_index {}

explore: pg_indexes {}

explore: pg_language {}

explore: pg_locks {}

explore: pg_namespace {}

explore: pg_opclass {}

explore: pg_operator {}

explore: pg_proc {}

explore: pg_resize {}

explore: pg_rewrite {}

explore: pg_rules {}

explore: pg_shdepend {}

explore: pg_table_def {}

explore: pg_tables {}

explore: pg_test {}

explore: pg_trigger {}

explore: pg_type {}

explore: pg_views {}

explore: publisher_apps {
  join: apps {
    type: left_outer
    sql_on: ${publisher_apps.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: ad_networks {
    type: left_outer
    sql_on: ${publisher_apps.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }
}

explore: reporting_cohort_metrics {
  join: ad_networks {
    type: left_outer
    sql_on: ${reporting_cohort_metrics.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${reporting_cohort_metrics.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${reporting_cohort_metrics.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }
}

explore: reporting_metrics_Trac_Ins {
  join: ad_networks {
    type: left_outer
    sql_on: ${reporting_metrics_Trac_Ins.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${reporting_metrics_Trac_Ins.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${reporting_metrics_Trac_Ins.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

#   join: ltv_for_14_30_60_and_90_days {
#     type: left_outer
#     sql_on: ${reporting_metrics.Key} = ${ltv_for_14_30_60_and_90_days.Key} ;;
#     relationship: many_to_one
#   }
}

explore: reporting_metrics {
  join: ad_networks {
    type: left_outer
    sql_on: ${reporting_metrics.ad_network_id} = ${ad_networks.id} ;;
    relationship: many_to_one
  }

  join: apps {
    type: left_outer
    sql_on: ${reporting_metrics.app_id} = ${apps.id} ;;
    relationship: many_to_one
  }

  join: campaigns {
    type: left_outer
    sql_on: ${reporting_metrics.campaign_id} = ${campaigns.id} ;;
    relationship: many_to_one
  }

  join: campaign_buckets {
    type: left_outer
    sql_on: ${campaigns.campaign_bucket_id} = ${campaign_buckets.id} ;;
    relationship: many_to_one
  }

#   join: ltv_for_14_30_60_and_90_days {
#     type: left_outer
#     sql_on: ${reporting_metrics.Key} = ${ltv_for_14_30_60_and_90_days.Key} ;;
#     relationship: many_to_one
#   }
}

explore: schema_migrations {}

explore: targeting_tags {}

explore: updated_at {}
