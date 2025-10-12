CREATE EXTENSION IF NOT EXISTS postgis;

DROP TABLE IF EXISTS gis_accident;
CREATE TABLE gis_accident (
    acc_risk_area_nm      TEXT,
    acc_risk_area_id      VARCHAR(20),
    geom_wkt              TEXT,
    tot_acc_cnt           INT,
    tot_dth_dnv_cnt       INT,
    tot_se_dnv_cnt        INT,
    tot_sl_dnv_cnt        INT,
    tot_wnd_dnv_cnt       INT,
    cntpnt_utmk_x_crd     DOUBLE PRECISION,
    cntpnt_utmk_y_crd     DOUBLE PRECISION,
    cause_anals_ty_nm     TEXT,
    guGun                 INT,
    year                  INT,
    gu                    TEXT
);

-- 데이터 적재
COPY gis_accident
FROM 'C:\Program Files\PostgreSQL\18\data\pratice\gis.csv'
WITH (
    FORMAT csv,
    HEADER true,
    ENCODING 'UTF8'
);

-- geom 칼럼 추가
ALTER TABLE gis_accident
ADD COLUMN geom geometry(Polygon, 5179);

-- WKT 텍스트를 공간 객체로 변환
UPDATE gis_accident
SET geom = ST_GeomFromText(geom_wkt, 5179)
WHERE geom_wkt IS NOT NULL;


