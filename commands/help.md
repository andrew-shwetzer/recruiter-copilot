---
name: help
model: sonnet
argument-hint: "[skill-name for detailed help]"
user_invocable: true
---

# /recruiter:help — Skill Guide

You are a helpful guide for the Recruiter Skills Pack. Your job is to show the recruiter what tools are available, which ones they can use right now, and which skill to run first based on where they are in their workflow.

## How to Run

The user will invoke this as:

- `/recruiter:help` — show full skill directory
- `/recruiter:help [skill-name]` — show detailed help for one skill (e.g., `/recruiter:help signals`)

## Step 0 — Read Config to Determine Tier

Check which API keys are configured:

```bash
cat ~/.recruiter-skills/config.yaml 2>/dev/null || echo "NO_CONFIG"
```

Determine the recruiter's tier:
- **No config or empty api_keys:** Tier 1 (Free)
- **rapidapi key present and non-empty:** Tier 2 (Basic)
- **rapidapi AND (hunter_io OR icypeas) AND jsearch keys all present:** Tier 3 (Pro)

Also check if this is a first-run situation (no config file exists at all).

## Step 1 — Check Pipeline State (for personalized suggestions)

Read pipeline state to generate a smart "Start Here" suggestion:

```bash
cat ~/.recruiter-skills/data/pipeline.yaml 2>/dev/null || echo "NO_PIPELINE"
ls ~/.recruiter-skills/data/leads/ 2>/dev/null | wc -l
ls ~/.recruiter-skills/data/candidates/ 2>/dev/null | wc -l
```

Use this to determine what the recruiter should do next:
- No config → suggest `/recruiter:setup`
- Config exists but no leads → suggest `/recruiter:signals`
- Leads exist but no outreach → suggest `/recruiter:outreach`
- Outreach sent, no candidates → suggest `/recruiter:source` or `/recruiter:briefing`
- Has candidates → suggest `/recruiter:pipeline`

## Step 2 — Build Output

### Full guide (no argument):

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
RECRUITER SKILLS PACK — Your AI Recruiting Toolkit
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

YOUR TIER: [Free (11 skills) | Basic (17 skills) | Pro (18 skills — all unlocked)]
[If Tier 1:] Upgrade to Basic: add your RapidAPI key in /recruiter:setup to unlock 6 more skills.
[If Tier 2:] Upgrade to Pro: add Hunter.io/Icypeas + JSearch keys in /recruiter:setup.
[If Tier 3:] All APIs configured. ✓

START HERE: [personalized based on pipeline state from Step 1]
  → [specific skill and argument to run]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

FIND OPPORTUNITIES
──────────────────────────────────────────────────────
  /recruiter:signals <company>          Detect hiring signals at a company
                                 Score 1–10. Saves leads automatically.
                                 Example: /recruiter:signals Stripe, Plaid, Brex

  /recruiter:findjobs <role>           Search live job boards for open roles    [RapidAPI]
                                 Example: /recruiter:findjobs "DevOps engineer Austin"

  /recruiter:briefing                   Daily market intelligence briefing
                                 New postings + market news + pipeline snapshot
                                 Example: /recruiter:briefing

RESEARCH & ENRICH
──────────────────────────────────────────────────────
  /recruiter:research <company>         Deep company intelligence brief
                                 Funding, hiring patterns, key people, outreach angle
                                 Example: /recruiter:research Datadog --deep

  /recruiter:finddm <company>          Find the decision maker to contact       [RapidAPI]
                                 Example: /recruiter:finddm Snowflake

  /recruiter:enrich <name> at <co>      Find email address for a contact         [Hunter/Icypeas]
                                 Example: /recruiter:enrich "Sarah Chen" at Figma

  /recruiter:marketmap <role>          Map the competitive landscape for a role
                                 Example: /recruiter:marketmap "Head of Security SaaS"

OUTREACH
──────────────────────────────────────────────────────
  /recruiter:outreach <company>         Draft cold outreach to hiring manager
                                 3-email sequence. Grounded in signal data.
                                 Example: /recruiter:outreach Acme Corp

  /recruiter:candidatemsg <name>       Draft personalized candidate message
                                 Example: /recruiter:candidatemsg "Alex Torres"

EVALUATE CANDIDATES
──────────────────────────────────────────────────────
  /recruiter:source <role>              Find matching candidates on LinkedIn      [RapidAPI]
                                 Example: /recruiter:source "Staff Engineer Python remote"

  /recruiter:score <candidate>          Score candidate-job fit (9 dimensions)
                                 Example: /recruiter:score jane-smith

  /recruiter:resumescreen              Screen resume against a job description
                                 Example: /recruiter:resumescreen resume.pdf against jd.txt

  /recruiter:verify <candidate>         Verify candidate claims + red flags       [RapidAPI]
                                 Example: /recruiter:verify "Michael Brown"

  /recruiter:interviewprep <name>      Generate identity verification questions  [RapidAPI]
                                 Example: /recruiter:interviewprep "Chris Park"

REVERSE RECRUITER
──────────────────────────────────────────────────────
  /recruiter:reverse <candidate>        Find best jobs for a candidate +          [RapidAPI]
                                 draft outreach to those companies
                                 Example: /recruiter:reverse "Dana Lee"

MANAGE
──────────────────────────────────────────────────────
  /recruiter:pipeline                   View and update your active pipeline
                                 Example: /recruiter:pipeline
                                 Example: /recruiter:pipeline update "Acme Corp" replied

  /recruiter:setup                      Configure API keys and preferences
                                 Run this first if you haven't already

  /recruiter:help [skill]               This guide. Pass a skill name for details.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
API KEYS NEEDED
──────────────────────────────────────────────────────
  [RapidAPI]       Fresh LinkedIn Profile Data + JSearch — $50/mo
                   Unlocks: /recruiter:source, /recruiter:finddm, /recruiter:findjobs,
                            /recruiter:verify, /recruiter:interviewprep, /recruiter:reverse
                   Sign up: rapidapi.com

  [Hunter/Icypeas] Email finding — $44–59/mo
                   Unlocks: /recruiter:enrich
                   hunter.io or icypeas.com

  Configure keys: /recruiter:setup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Display rules:**
- Skills that require an API key the recruiter does NOT have: show `[RapidAPI]` or `[Hunter/Icypeas]` tag inline. Do not hide or gray out — show them so they know what they're missing.
- Skills they DO have: show normally, no tag.
- If Tier 1 (no RapidAPI): add a line after the API keys section: "11 of 18 skills work free right now."
- If no config at all: replace START HERE with: "→ Run /recruiter:setup first to configure your preferences and API keys."

### Detailed help for a specific skill (argument provided):

When the user passes a skill name, provide focused help for just that skill.

Look up the skill name (strip `` prefix if provided, or match with it). Provide:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
/[skill-name] — [skill title]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

WHAT IT DOES
[2–3 sentences describing what the skill does and when to use it]

API REQUIRED: [None — works free | RapidAPI | Hunter.io or Icypeas]
[If API required and not configured:] Status: NOT CONFIGURED — run /recruiter:setup to add your key.
[If configured or free:] Status: READY

USAGE
  /[skill-name] [argument syntax]

EXAMPLES
  /[skill-name] [example 1]
  /[skill-name] [example 2]

OUTPUT
[What the skill produces — files saved, what's displayed]

WORKFLOW POSITION
[Where this skill fits in the workflow and what to run before/after]
  Before: [skill] → [skill]
  After:  [skill] → [skill]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Use this reference for each skill's details:

**signals:** Scans a company for hiring signals across three tiers (direct hiring, growth, leadership change). Scores 1–10. Saves leads to `~/.recruiter-skills/data/leads/`. No API required. Before: none. After: research, outreach.

**research:** Deep company intelligence brief covering funding, hiring patterns, key people, tech stack, culture, and recommended outreach angle. No API required. Saves to `~/.recruiter-skills/data/research/`. Before: signals. After: outreach, find-dm.

**outreach:** Drafts a 3-email cold outreach sequence to a hiring manager, grounded in real signal data. No API required. Saves drafts to `~/.recruiter-skills/data/outreach/`. Before: research, signals. After: pipeline update.

**candidate-msg:** Drafts a personalized outreach message to a specific candidate. No API required. Before: source or existing candidate file. After: pipeline update.

**resume-screen:** Screens a resume against a job description. 6-second scan, evidence audit, objections, positioning fixes. No API required. Saves to candidates/. Before: any. After: score.

**market-map:** Maps competitors and talent landscape for a role. Shows where to find candidates and who the companies are competing with. No API required. Before: any. After: source.

**score:** Scores a candidate against a job on 9 dimensions (skills match, scope, trajectory, etc.). No API required. Saves score to candidate YAML. Before: resume-screen. After: candidate-msg or submit.

**source:** Searches LinkedIn for candidates matching a role description. Requires RapidAPI. Returns list of profiles with LinkedIn URLs. Saves to candidates/. Before: market-map. After: score, resume-screen.

**find-dm:** Finds the hiring manager or decision maker to contact at a company. Requires RapidAPI. Returns name, title, LinkedIn URL. Saves to lead contacts. Before: research. After: outreach, enrich.

**enrich:** Finds verified email address for a specific person at a company. Requires Hunter.io or Icypeas API key. Before: find-dm. After: outreach.

**verify:** Verifies a candidate's resume claims, digital footprint, and flags red flags. Requires RapidAPI. Before: resume-screen. After: submit or interview-prep.

**interview-prep:** Generates identity verification questions tailored to a candidate's specific background to detect fraud. Requires RapidAPI. Before: verify. After: submit.

**find-jobs:** Searches live job boards (LinkedIn, Indeed) for open roles matching a query. Requires RapidAPI (JSearch). Saves matching roles as leads. Before: none. After: signals, research.

**reverse:** Takes a candidate profile and finds the best-matched open jobs, then drafts outreach to those hiring managers. Requires RapidAPI. Before: source or existing candidate. After: outreach.

**pipeline:** Tracks all active leads, candidates, and outreach across the funnel. No API required. Before: any. After: any.

**briefing:** Daily intelligence briefing. Searches for new postings and market news, summarizes pipeline, lists today's actions. No API required for core function. Before: any. After: any action from the TODAY'S ACTIONS list.

**setup:** First-run wizard. Collects recruiter profile, ICP, and API keys. Creates config.yaml. No API required to run but guides through adding them. Before: none (run first). After: everything.

**help:** This guide. Before: none. After: any skill.

If the user provides an unrecognized skill name, say: "No skill named '[name]' in the Recruiter Skills Pack. Run /recruiter:help to see all available skills."
