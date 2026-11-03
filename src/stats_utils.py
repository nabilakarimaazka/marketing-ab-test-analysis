import numpy as np
from scipy.stats import norm
import pandas as pd

def two_proportion_ztest(x1, n1, x2, n2):
    """Two-sided two-proportion z-test (pooled SE)
    
    Returns z statistic and p-Value.
    """
    p1, p2 = x1 / n1, x2 / n2
    p_pool = (x1 + x2) / (n1 + n2)
    se_pool = np.sqrt(p_pool * (1 - p_pool) * (1 / n1 + 1 / n2))
    z = (p1 - p2) / se_pool
    p_value = 2 * (1 - norm.cdf(abs(z)))
    return z, p_value


def diff_confidence_interval(x1, n1, x2, n2, confidence=0.95):
    """Wald confidence interval for p1 - p2 (unpooled SE)."""
    p1, p2 = x1 / n1, x2 / n2
    se = np.sqrt(p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2)
    z_crit = norm.ppf(1 - (1 - confidence) / 2)  # 1.96 untuk 95%
    diff = p1- p2
    return diff - z_crit * se, diff + z_crit * se

def lift(x1, n1, x2, n2):
    """Absolute lift (p1 - p2) and relative lift ((p1 - p2) / p2)."""
    p1, p2 = x1 / n1, x2 / n2
    return p1 - p2, (p1 - p2) / p2

def mde_two_proportions(p_baseline, n1, n2, alpha=0.05, power=0.80):
    """Approximate minimum detectable effect (absolute difference)
    for a two-sided two-proportion test, using the baseline variance."""
    z_alpha = norm.ppf(1 - alpha / 2)
    z_beta = norm.ppf(power)
    se = np.sqrt(p_baseline * (1 - p_baseline) * (1 / n1 + 1 / n2))
    return (z_alpha + z_beta) * se

def power_two_proportions(p1, p2, n1, n2, alpha=0.05):
    """Approximate power of a two-sided two-proportion z-test
    for true proportions p1 and p2."""
    z_alpha = norm.ppf(1 - alpha / 2)
    se = np.sqrt(p1 * (1 - p1) / n1 + p2 * (1 - p2) / n2)
    return norm.cdf(abs(p1 - p2) / se - z_alpha)

def analyze_segment(df, segment_col, p_baseline, alpha=0.05):
    """Run an ad-vs-psa test for every segment, with Bonferroni correction.
    
    df must contain: segment_col, n_ad, x_ad, n_psa, x_psa.
    p_baseline is the overall control conversion rate, used for the
    per-segment MDE (segment-level control rates are too noisy).
    """
    m = len(df)
    alpha_adj = alpha / m       # Bonferroni
    
    rows = []
    for _, r in df.iterrows():
        z, p = two_proportion_ztest(r["x_ad"], r["n_ad"], r["x_psa"], r["n_psa"])
        ci_low, ci_high = diff_confidence_interval(
            r["x_ad"], r["n_ad"], r["x_psa"], r["n_psa"],
            confidence=1 - alpha_adj,
        )
        abs_lift, _ = lift(r["x_ad"], r["n_ad"], r["x_psa"], r["n_psa"])
        mde = mde_two_proportions(p_baseline, r["n_ad"], r["n_psa"], alpha=alpha_adj)
        
        
        rows.append({
            segment_col: r[segment_col],
            "n_ad": r["n_ad"],
            "n_psa": r["n_psa"],
            "x_psa": r["x_psa"],
            "cr_ad_pct": r["x_ad"] / r["n_ad"] * 100,
            "cr_psa_pct": r["x_psa"] / r["n_psa"] * 100,
            "abs_lift_pp": abs_lift * 100,
            "ci_low_pp": ci_low * 100,
            "ci_high_pp": ci_high * 100,
            "p_value": p,
            "p_bonferroni": min(p * m, 1.0),
            "significant": p < alpha_adj,
            "mde_pp": mde * 100,
        })
    return pd.DataFrame(rows)