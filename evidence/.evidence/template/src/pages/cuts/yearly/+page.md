---
title: Yearly
---

```sql park_visits
SELECT
  DATETRUNC('month',(Year::INT||'-'||Month::INT||'-'||01)::DATE) as dt,
  ParkName,
  replace(RecreationVisits, ',','')::DOUBLE as num_visits,
  Year
FROM nps.parks_data
```

```sql single_park_visits
SELECT
  *
FROM ${park_visits}
  WHERE 1=1
  AND Year::VARCHAR = ${inputs.year.value}
  AND ParkName like '${inputs.park.value}'
  AND num_visits > 0
```
```sql park_visits_l10
SELECT
  *
FROM ${park_visits}
  WHERE 1=1
  AND Year > 2014
```

```sql parks
  SELECT
    DISTINCT ParkName as park
  FROM nps.parks_data
```

```sql years
  SELECT
    DISTINCT year as year
  FROM nps.parks_data
  ORDER BY 1 DESC
  LIMIT 10
```


<Dropdown data={parks} name=park value=park>
    <DropdownOption value="%" valueLabel="All Parks"/>
</Dropdown>

<Dropdown data={years} name=year value=year>
    <DropdownOption value="2023" valueLabel="2023"/>
</Dropdown>

<BarChart
    data={single_park_visits}
    title="🌲 Park visits by month, {inputs.year.value}"
    x=dt
    y=num_visits
    xFmt="m/d"
    yFmt="num1m"
    series=ParkName
/>


```sql overnight_stays
SELECT
  DATETRUNC('month',(Year::INT||'-'||Month::INT||'-'||01)::DATE) as dt,
  ParkName,
  replace(TentCampers, ',','')::DOUBLE as num_tent,
  replace(RVCampers, ',','')::DOUBLE as num_rv,
  replace(Backcountry, ',','')::DOUBLE as num_backcountry,
  replace(MiscellaneousOvernightStays, ',','')::DOUBLE as num_misc,
  num_tent + num_rv + num_backcountry + num_misc as tot_overnight
FROM nps.parks_data
WHERE 1=1
  AND Year::VARCHAR = ${inputs.year.value}
  AND ParkName like '${inputs.park.value}'
  AND tot_overnight > 0
```

<BarChart
    data={overnight_stays}
    title="🏕️ Overnight stays by month, {inputs.year.value}"
    x=dt
    y=tot_overnight
    xFmt="m/d"
    yFmt="num1k"
    series=ParkName
/>