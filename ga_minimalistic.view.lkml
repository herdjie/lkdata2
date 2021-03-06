view: ga_minimalistic {
  derived_table: {
    sql: select
      game_info.bundle_id,
      ga_base.*,
      (session_count * avg_session_length)/DAU as playtime
      From(
          SELECT
          arrival_date,
          --COALESCE(ios_bundle_id,android_bundle_id) as bundle_id,
          user_meta_install_ts,
          arrival_ts,
          game_id,
          UPPER(user_id) as user_id,
          ios_idfa,
          ios_idfv,
          country_code as country,
          user_meta_install_campaign as install_campaign,
          limited_ad_tracking as LAT,
          platform,
          custom_01,
          custom_02,
          custom_03,
          COUNT(DISTINCT user_id) as DAU,
          COUNT(DISTINCT session_id) as session_count,
          AVG(length) as avg_session_length

          from gameanalytics.GA_session_end as ga
          --WHERE ga.arrival_date >= ((DATE(TIMESTAMP_TRUNC(CAST(TIMESTAMP_ADD(TIMESTAMP_TRUNC(CURRENT_TIMESTAMP(), DAY), INTERVAL -7 DAY) AS TIMESTAMP), DAY))))
          group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14
          ) ga_base

      --Join in games table to get the bundle_id
      join (select
            id,
            bundle_id,
            CASE
              WHEN store_platform = 'apple_ios' then 'ios'
              WHEN store_platform = 'google_play' then 'android'
              WHEN store_platform = 'other' then 'web'
              ELSE NULL
            END AS platform
            from gameanalytics.games) game_info
      on game_info.id = ga_base.game_id
      and game_info.platform = ga_base.platform
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension_group: since_install {
    type: duration
    intervals: [day]
    sql_start: ${install_ts_date::datetime} ;;
    sql_end: ${arrival_ts_date::datetime} ;;
  }

  dimension_group: arrival_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: TIMESTAMP_SECONDS(${TABLE}.arrival_ts) ;;
  }

  dimension_group: install_ts {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    # sql: TIMESTAMP_SECONDS(${TABLE}.install_ts) ;;
    sql: TIMESTAMP_SECONDS(${TABLE}.user_meta_install_ts) ;;
  }


  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: install_campaign {
    type: string
    sql: ${TABLE}.install_campaign ;;
  }

  dimension: LAT {
    type: yesno
    sql: ${TABLE}.LAT ;;
  }

  dimension: bundle_id {
    type: string
    sql: ${TABLE}.bundle_id ;;
  }

  dimension: arrival_date {
    type: date
    datatype: date
    sql: ${TABLE}.arrival_date ;;
  }

  dimension: game_id {
    type: number
    sql: ${TABLE}.game_id ;;
  }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
  }

  dimension: ios_idfa {
    type: string
    sql: ${TABLE}.ios_idfa ;;
  }

  dimension: ios_idfv {
    type: string
    sql: ${TABLE}.ios_idfv ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: custom_01 {
    type: string
    sql: ${TABLE}.custom_01 ;;
  }

  dimension: custom_02 {
    type: string
    sql: ${TABLE}.custom_02 ;;
  }

  dimension: custom_03 {
    type: string
    sql: ${TABLE}.custom_03 ;;
  }

  measure: dau {
    type: count_distinct
    sql: ${TABLE}.user_id ;;
  }

  measure: session_count {
    type: sum
    sql: ${TABLE}.session_count ;;
  }

  measure: avg_session_length {
    type: average
    sql: ${TABLE}.avg_session_length;;
    value_format:"#.#"
  }

  measure: playtime {
    type: sum
    sql: ${TABLE}.playtime;;
    value_format:"#.#"
  }

  measure: avg_playtime {
    type: average
    sql: ${TABLE}.playtime;;
    value_format:"#.#"
  }

  measure: avg_session_count {
    type: average
    sql: ${TABLE}.session_count;;
    value_format:"#.#"
  }

  set: detail {
    fields: [
      bundle_id,
      arrival_date,
      game_id,
      user_id,
      ios_idfa,
      ios_idfv,
      platform,
      custom_01,
      custom_02,
      custom_03,
      dau,
      session_count,
      avg_session_length,
      playtime
    ]
  }
}
