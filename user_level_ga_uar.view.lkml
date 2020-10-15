view: user_level_ga_uar {
  derived_table: {
    sql: select
      filtered_uid,
      created_date,
      bundle_id,
      build,
      platform,
      country,
      ip,
      ad_network,
      ad_unit,
      AB_custom_01,
      AB_custom_02,
      AB_custom_03,
      playtime,
      avg_session_length,
      session_count,
      revenue,
      impressions
      from(
        SELECT
          game_analytics.ios_idfa  AS idfa,
          REPLACE(LOWER(game_analytics.user_id), '-', '') as filtered_uid,
          game_analytics.custom_01  AS AB_custom_01,
          game_analytics.custom_02  AS AB_custom_02,
          game_analytics.custom_03  AS AB_custom_03,
          game_analytics.build  AS build,
          game_analytics.bundle_id  AS bundle_id,
          game_analytics.ip  AS ip,
          AVG(game_analytics.length ) AS avg_session_length,
          (COUNT(DISTINCT game_analytics.session_id )) * (AVG(game_analytics.length )) / (COUNT(DISTINCT game_analytics.user_id ))  AS playtime,
          COUNT(DISTINCT game_analytics.session_id ) AS session_count
        FROM game_analytics.data_export_new  AS game_analytics

        WHERE (((TIMESTAMP_SECONDS(game_analytics.arrival_ts) ) >= ((TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY))) AND (TIMESTAMP_SECONDS(game_analytics.arrival_ts) ) < ((TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY)))))
        GROUP BY 1,2,3,4,5,6,7,8
        ORDER BY 2 DESC
      )a
      inner join (
      SELECT
        CAST(CAST(user_ad_revenue.date_created  AS TIMESTAMP) AS DATE) AS created_date,
        user_attributes.country  AS country,
        user_ad_revenue.advertising_id  AS advertising_id,
        user_ad_revenue.impressions  AS impressions,
        user_ad_revenue.ad_network  AS ad_network,
        user_ad_revenue.platform  AS platform,
        user_ad_revenue.ad_unit  AS ad_unit,
        SUM(user_ad_revenue.revenue) / COUNT(DISTINCT user_ad_revenue.user_id)  AS arpdau,
        COALESCE(SUM(user_ad_revenue.revenue ), 0) AS revenue
      FROM tenjin_BigQuery.user_ad_revenue  AS user_ad_revenue
      LEFT JOIN tenjin_BigQuery.rs_user_attributes  AS user_attributes ON (COALESCE(user_attributes.advertising_id, user_attributes.developer_device_id)) = user_ad_revenue.advertising_id
      LEFT JOIN tenjin_BigQuery.campaigns  AS campaigns ON user_attributes.campaign_id = campaigns.id
      LEFT JOIN tenjin_BigQuery.apps  AS apps ON campaigns.app_id = apps.id

      WHERE (((user_ad_revenue.date_created ) >= ((DATE(TIMESTAMP_TRUNC(CAST(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY) AS TIMESTAMP), DAY)))) AND (user_ad_revenue.date_created ) < ((DATE(TIMESTAMP_TRUNC(CAST(TIMESTAMP_ADD(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -29 DAY), INTERVAL 30 DAY) AS TIMESTAMP), DAY))))))
      GROUP BY 1,2,3,4,5,6,7
      ORDER BY 7 DESC,6
      )b
      on a.filtered_uid = b.advertising_id
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: filtered_uid {
    type: string
    sql: ${TABLE}.filtered_uid ;;
  }

  dimension: created_date {
    type: date
    datatype: date
    sql: ${TABLE}.created_date ;;
  }

  dimension: bundle_id {
    type: string
    sql: ${TABLE}.bundle_id ;;
  }

  dimension: build {
    type: string
    sql: ${TABLE}.build ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: ip {
    type: string
    sql: ${TABLE}.ip ;;
  }

  dimension: ad_network {
    type: string
    sql: ${TABLE}.ad_network ;;
  }

  dimension: ad_unit {
    type: string
    sql: ${TABLE}.ad_unit ;;
  }

  dimension: ab_custom_01 {
    type: string
    sql: ${TABLE}.AB_custom_01 ;;
  }

  dimension: ab_custom_02 {
    type: string
    sql: ${TABLE}.AB_custom_02 ;;
  }

  dimension: ab_custom_03 {
    type: string
    sql: ${TABLE}.AB_custom_03 ;;
  }

  dimension: playtime {
    type: number
    sql: ${TABLE}.playtime ;;
  }

  dimension: avg_session_length {
    type: number
    sql: ${TABLE}.avg_session_length ;;
  }

  dimension: session_count {
    type: number
    sql: ${TABLE}.session_count ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  set: detail {
    fields: [
      filtered_uid,
      created_date,
      bundle_id,
      build,
      platform,
      country,
      ip,
      ad_network,
      ad_unit,
      ab_custom_01,
      ab_custom_02,
      ab_custom_03,
      playtime,
      avg_session_length,
      session_count,
      revenue,
      impressions
    ]
  }
}