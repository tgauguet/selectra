# Level 6

During the year, providers apply additional season costs.

## Instructions

The initial (prior to any further calculations) electricity bill is now calculated as follows:
- Spring: +1%
- Summer: -1.5%
- Autumn: average of +0.7% with average of previous spring and summer. If spring and/or summer are not present, only output the +0.7% result
- Winter: no additional cost

Assumptions:
- if `start_date` and `end_date` are in the same season, apply its corresponding extra fee only once
- monthly consumption is always constant, and you can get it from `yearly_consumption`

Write code that generates `output.json` from `data.json`
