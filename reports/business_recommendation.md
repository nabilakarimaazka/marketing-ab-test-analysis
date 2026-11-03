# Business Recommendation — Ad Campaign A/B Test

## TL;DR
The ad campaign works: users who saw product ads converted at 2.56% vs
1.79% for the control group (+0.77 percentage points, ≈43% relative).
**Recommendation: continue the campaign**, run a cost-benefit check
before scaling, and test ad frequency next, because the effect is
concentrated among the most heavily exposed users.

## Key Results
| Question | Answer |
|---|---|
| Do ads increase conversion? | Yes — statistically significant (p < 0.001) |
| How large is the effect? | +0.77 pp (95% CI: 0.60 to 0.94 pp) |
| In business terms | ≈770 extra conversions per 100,000 users reached (plausible range: 600–940) |
| Was the test sensitive enough? | Yes — the smallest detectable effect was 0.25 pp, well below the observed lift |
| Where is the effect strongest? | Users with the highest ad exposure (34+ ads): +3.80 pp. Near zero for the other 80% of users |

## Recommendations

**1. Continue the campaign.**
The lift is clearly positive, and even the most conservative estimate
(0.60 pp) is a substantial increase over a 1.79% baseline.

**2. Run a cost-benefit check before scaling up.**
The dataset contains no cost or revenue data, so ROI could not be
estimated. The campaign pays off if:

    extra conversions per user × value per conversion > ad cost per user
    (0.0077 × value per conversion) > ad cost per user

Finance or marketing should plug in actual cost per user reached and
average order value.

**3. Test ad frequency in a follow-up experiment.**
The entire lift comes from users who saw 34+ ads; users with fewer
exposures show almost no effect. This could mean ads need repeated
exposure to work, or that highly engaged users are simply more
responsive. These two explanations call for different strategies, and
the current data cannot distinguish them. A follow-up test that
randomly assigns users to different frequency caps would answer this
directly.

**4. Do not reallocate budget by day or hour yet.**
Monday–Wednesday showed stronger lifts (0.96–1.60 pp), but confidence
intervals overlap with other days, and no clear hour-of-day pattern was
found. If day-of-week scheduling is of interest, test it as a
pre-registered hypothesis in a dedicated experiment.

**5. Keep a small control group, but size it with power analysis.**
The 96/4 split worked here because the effect was large relative to the
test's sensitivity. A 50/50 split would have been ~2.5× more sensitive
but would have cost roughly 2,000 conversions during the test. Future
tests looking for smaller effects (e.g., frequency tests) may need a
larger control group; run a power analysis before launch.

## Limitations
- No cost, revenue, or experiment-duration data; ROI is not estimated.
- Segment variables (day, hour, total ads) were measured during the
  experiment, so segment differences are exploratory, not causal.
- `total ads` strongly reflects user engagement: conversion rises with
  exposure even in the PSA group (0.18% → 6.03%).
- The planned allocation ratio is undocumented; the observed 96/4 split
  is consistent with an assumed 96/4 design.

## Next Steps
1. Obtain cost and revenue data to complete the ROI calculation.
2. Design a frequency-cap experiment, with power analysis and a
   pre-registered brief.
3. In future experiments, record pre-experiment user characteristics
   (e.g., past activity) so segments can be analyzed without
   post-treatment bias.