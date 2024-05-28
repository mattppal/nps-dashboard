---
title: Welcome
---

This site is designed to bring NPS public data on US Parks attendance to the masses. The data used is publicly available at the [NPS IRMA](https://irma.nps.gov/Stats/) site.

```sql park_visits
SELECT
  DATETRUNC('month',(Year::INT||'-'||Month::INT||'-'||01)::DATE) as dt,
  ParkName,
  replace(RecreationVisits, ',','')::DOUBLE as num_visits,
  Year,
  replace(TentCampers, ',','')::DOUBLE as num_tent,
  replace(RVCampers, ',','')::DOUBLE as num_rv,
  replace(Backcountry, ',','')::DOUBLE as num_backcountry,
  replace(MiscellaneousOvernightStays, ',','')::DOUBLE as num_misc,
  replace(ConcessionerCamping, ',','')::DOUBLE as num_concessioner,
  num_tent + num_rv + num_backcountry + num_misc as tot_overnight,
  tot_overnight / num_visits as pct_overnight
FROM nps.parks_data
```

```sql single_park_visits
SELECT
  *
FROM ${park_visits}
  WHERE 1=1
  AND Year > 2014
  AND num_visits > 0
```
```sql park_visits_l10
SELECT
  *
FROM ${park_visits}
  WHERE 1=1
  AND Year > 2014
```

<AreaChart 
    data={park_visits_l10}  
    title="Share of park visits by month"
    x=dt 
    y=num_visits
    series=ParkName
    yFmt=pct0
    type=stacked100
/>