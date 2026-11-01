# Experiment Brief — Marketing Ad Campaign A/B Test

## 1. Background
The company ran an online advertising campaign and wants to know whether
the ads actually increase conversions (purchases). A small share of users
was held out as a control group and shown a Public Service Announcement
(PSA) in the same ad slots instead of the product ad.

## 2. Business Question
Does the ad campaign produce a higher conversion rate than the control
group? If so, how large is the effect, and is it large enough to justify
the cost of the campaign?

## 3. Experiment Design
- Unit of randomization & analysis : user (`user id`)
- Treatment                        : `ad` group — shown product ads
- Control                          : `psa` group — shown public service
                                     announcements (placebo)
- Allocation                       : unbalanced (~96% ad / ~4% psa);
                                     the planned allocation ratio is not
                                     documented
- Data source                      : Kaggle, faviovaz/marketing-ab-testing

## 4. Metrics
- Primary metric : conversion rate
                   = number of converted users / number of users in group
- Secondary      : none (the dataset contains no revenue data)
- Guardrail      : not available in the dataset (noted as a limitation)

## 5. Hypotheses (two-sided test)
- H0 : p_ad = p_psa  (ads do not change the conversion rate)
- H1 : p_ad ≠ p_psa  (ads change the conversion rate)
- Significance level α = 0.05

Rationale for a two-sided test: ads could also have a negative effect
(e.g., annoying users). A two-sided test is more conservative and is
standard practice.

## 6. Analysis Plan
1. Data quality checks (SQL/DuckDB): missing values, duplicate user IDs,
   users appearing in both groups, invalid values
2. Conversion rate per group (SQL)
3. Two-proportion z-test
4. 95% confidence interval for the difference in proportions
   (p_ad − p_psa)
5. Lift:
   - absolute lift = p_ad − p_psa (in percentage points)
   - relative lift = (p_ad − p_psa) / p_psa
6. Power analysis & MDE: given the available sample sizes, what is the
   smallest effect detectable with 80% power at α = 0.05?
7. Segment analysis (exploratory):
   - by day (`most ads day`, 7 segments)
   - by hour (`most ads hour`, 24 segments)
   - by ad exposure (`total ads`, split into 5 quantiles)
   - Bonferroni correction within each family of tests:
     α_adj = 0.05 / m, where m = number of segments in that family

## 7. Decision Rules
- The effect is statistically significant if p-value < 0.05 AND the 95%
  CI for the difference in proportions does not contain 0.
- The effect is practically significant if absolute lift ≥
  [fill in, e.g., 0.5 percentage points].
  Rationale: [fill in one sentence on why this threshold matters for
  the business]
- Recommendation:
  - Significant + practically meaningful     → continue / scale the campaign
  - Significant, not practically meaningful  → review cost vs. benefit
  - Not significant                          → check power; do not
                                               conclude "no effect"

## 8. Threats to Validity & Limitations
- Unbalanced allocation with an unknown planned ratio, so a formal Sample
  Ratio Mismatch (SRM) test cannot be run. The observed ratio will be
  reported.
- Randomization cannot be fully verified (no pre-experiment user
  characteristics are available).
- `total ads`, `most ads day`, and `most ads hour` were measured during
  the experiment (post-treatment variables). Segment results are
  exploratory and cannot be interpreted as causal effects.
- No information on experiment duration, revenue, or ad cost.

## 9. Out of Scope
- Campaign ROI estimation (cost data not available)
- Predictive modeling of conversion