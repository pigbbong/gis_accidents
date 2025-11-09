# Seoul Traffic Accident Risk Area Analysis

서울특별시의 자치구별 교통사고 다발 지역 데이터를 수집하고,  
PostgreSQL(PostGIS) 및 QGIS를 활용하여 시각화하였고, 
Jupyter Notebook에서 EDA, 통계적 가설 검정을 진행한 프로젝트입니다.


## 데이터 개요

- **출처:** [도로교통공단 교통사고 위험지역 OpenAPI](https://opendata.koroad.or.kr/api/selectAcdntRiskAreaDataSet.do)  
- **범위:** 서울특별시 25개 자치구  
- **내용:** 반경 50m 내에서 8건 이상 사고 발생 지역



## 분석 내용 요약

1. **기초 EDA**  
   - 데이터프레임의 구조와 컬럼들의 분포, 그리고 결측치와 고유값 등을 확인

2. **확장 EDA**  
   - 자치구별 사망자수 및 사망률 비교  
   - 중상자/경상자 비율 누적 막대 그래프  
   - 연도별 사고 추이 및 주요 원인 변화  
   - 사망률 기준 위험 지역 / 산포도 분석  

3. **통계적 검정**  
   - 단일 vs 복합 사고의 사망률 차이 검정 (t-test / Mann–Whitney U)  
   - 사고 원인 수와 사망률의 상관관계 분석 (pearson)



## QGIS 시각화

- PostGIS 기반 뷰(`vw_gis_accident_frequency`, `vw_gis_accident_fatality`)를 불러와  
  **사고 위험도 단계(7단계 색상 등급)** 로 시각화  
- 사고 위험도 상위 등급부터 **진한 빨강 → 노랑 → 연두색**으로 구분 (등급 숫자가 낮을수록 위험도가 높은 지역)
- 지도 상의 사고 지점에 마우스를 대면, 해당 구역의 사고 건수 및 위험 등급 등을 시각적으로 확인할 수 있다.

예시)
![QGIS 시각화 결과](https://github.com/user-attachments/assets/fc3740bb-1736-4e83-a787-43c63b385ff8)

