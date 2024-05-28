---
title: Toplin
---

```sql park_visits_agg
SELECT
  DATETRUNC('month',(Year::INT||'-'||Month::INT||'-'||01)::DATE) as dt,
  Year,

  SUM(replace(RecreationVisits, ',','')::DOUBLE) as num_visits,
  SUM(replace(TentCampers, ',','')::DOUBLE) as num_tent,
  SUM(replace(RVCampers, ',','')::DOUBLE) as num_rv,
  SUM(replace(Backcountry, ',','')::DOUBLE) as num_backcountry,
  SUM(replace(MiscellaneousOvernightStays, ',','')::DOUBLE) as num_misc,
  SUM(replace(ConcessionerCamping, ',','')::DOUBLE) as num_concessioner,
  num_tent + num_rv + num_backcountry + num_misc as tot_overnight,
  tot_overnight / num_visits as pct_overnight
FROM nps.parks_data
  WHERE 1=1
  AND Year > 2014
GROUP BY 1,2
```


<BarChart
    data={park_visits_agg}
    title="🌲 Park visits by month"
    x=dt
    y=num_visits
    xFmt="m/d"
    yFmt="num1m"
/>

<BarChart
    data={park_visits_agg}
    title="🏕️ Overnight stays by month"
    x=dt
    y=tot_overnight
    y2=pct_overnight
    y2SeriesType=line 
    xFmt="m/d"
    yFmt="num1m"
    y2Fmt="pct0"
/>