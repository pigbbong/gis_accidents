-- 사고건수 집계 뷰
DROP VIEW IF EXISTS vw_gis_accident_frequency;

CREATE OR REPLACE VIEW vw_gis_accident_frequency AS
WITH combined AS (
    SELECT
        gu,
        year,
        geom_wkt,
        SUM(tot_acc_cnt) AS total_acc_cnt
    FROM gis_accident
    GROUP BY gu, geom_wkt, year
    UNION ALL
    SELECT
        gu,
        9999 AS year,
        geom_wkt,
        SUM(tot_acc_cnt) AS total_acc_cnt
    FROM gis_accident
    GROUP BY gu, geom_wkt
)
SELECT
    (year::bigint * 1000 + ROW_NUMBER() OVER (PARTITION BY year ORDER BY gu)) AS id,
    gu,
    year,
    ST_SetSRID(ST_GeomFromText(geom_wkt), 5179)::geometry(Polygon,5179) AS geom,
    geom_wkt,
    total_acc_cnt,
    NTILE(7) OVER (PARTITION BY year ORDER BY total_acc_cnt DESC) AS risk_rank,
    CASE NTILE(7) OVER (PARTITION BY year ORDER BY total_acc_cnt DESC)
        WHEN 1 THEN '#8B0000'
        WHEN 2 THEN '#FF4500'
        WHEN 3 THEN '#FF8C00'
        WHEN 4 THEN '#FFD700'
        WHEN 5 THEN '#ADFF2F'
        WHEN 6 THEN '#7CFC00'
        WHEN 7 THEN '#98FB98'
    END AS color
FROM combined;



-- 사망자 수, 사망률 집계 뷰
DROP VIEW IF EXISTS vw_gis_accident_fatality;

CREATE OR REPLACE VIEW vw_gis_accident_fatality AS
WITH combined AS (
    -- 연도별 데이터
    SELECT gu, year, geom_wkt,
           SUM(tot_acc_cnt) AS total_acc_cnt,
           SUM(tot_dth_dnv_cnt) AS total_deaths
    FROM gis_accident
    GROUP BY gu, geom_wkt, year

    UNION ALL

    -- 전체 연도 데이터 (9999)
    SELECT gu, 9999 AS year, geom_wkt,
           SUM(tot_acc_cnt) AS total_acc_cnt,
           SUM(tot_dth_dnv_cnt) AS total_deaths
    FROM gis_accident
    GROUP BY gu, geom_wkt
)
SELECT (year::bigint * 1000 + ROW_NUMBER() OVER (PARTITION BY year ORDER BY gu)) AS id,
       gu,
       year,
       ST_SetSRID(ST_GeomFromText(geom_wkt), 5179)::geometry(Polygon,5179) AS geom,
       geom_wkt,
       total_acc_cnt,
       total_deaths,
       CASE 
           WHEN total_acc_cnt > 0 THEN ROUND(total_deaths::numeric / total_acc_cnt, 4)
           ELSE 0 
       END AS fatality_rate,
       NTILE(7) OVER (
           PARTITION BY year
           ORDER BY total_deaths DESC, 
                    CASE WHEN total_acc_cnt > 0 THEN total_deaths::numeric / total_acc_cnt ELSE 0 END DESC
       ) AS risk_grade,
       CASE 
	   		NTILE(7) OVER (
           	PARTITION BY year
           	ORDER BY total_deaths DESC, 
            CASE WHEN total_acc_cnt > 0 THEN total_deaths::numeric / total_acc_cnt ELSE 0 END DESC
       )
           WHEN 1 THEN '#8B0000'
           WHEN 2 THEN '#FF4500'
           WHEN 3 THEN '#FF8C00'
           WHEN 4 THEN '#FFD700'
           WHEN 5 THEN '#ADFF2F'
           WHEN 6 THEN '#7CFC00'
           WHEN 7 THEN '#98FB98'
       END AS color
FROM combined;