# Recruiter Copilot for Claude Code

18 AI-powered recruiting skills that install directly into Claude Code / Cowork. No server, no SaaS, no separate app. Signal scanning, company research, candidate sourcing, outreach drafting, pipeline tracking, all from your terminal. Everything stays on your machine.

---

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/andrew-shwetzer/recruiter-copilot/main/remote-install.sh | bash
```

Or clone and run locally:

```bash
git clone https://github.com/andrew-shwetzer/recruiter-copilot.git
cd recruiter-copilot
./install.sh
```

---

## Quick Start

**1. Configure your preferences (do this first):**

```
/setup
```

This walks you through entering your recruiter profile, the types of roles you work, and optionally your API keys. Takes about 2 minutes. 11 skills work immediately with zero API keys.

**2. Find your first target company:**

```
/signals Stripe, Databricks, Figma
```

Scans each company for hiring signals and scores them 1–10. Automatically saves leads for any company scoring 5+.

**3. Research before you reach out:**

```
/research Stripe
```

Builds a full intelligence brief: funding history, hiring patterns, key people, tech stack, and a recommended outreach angle.

**4. Draft the outreach:**

```
/outreach Stripe
```

Writes a 3-email cold sequence to the right hiring manager, grounded in what `/research` found.

**5. Check your pipeline anytime:**

```
/pipeline
```

---

## All Skills

| Skill | What it does | API Required |
|-------|-------------|--------------|
| `/signals <company>` | Detect hiring signals, score 1–10, save as lead | Free |
| `/research <company>` | Deep company intelligence brief | Free |
| `/outreach <company>` | Draft 3-email cold sequence to hiring manager | Free |
| `/candidate-msg <name>` | Draft personalized candidate outreach | Free |
| `/resume-screen` | Screen resume against job description | Free |
| `/market-map <role>` | Map competitive landscape for a role | Free |
| `/score <candidate>` | Score candidate fit across 9 dimensions | Free |
| `/source <role>` | Find matching candidates on LinkedIn | RapidAPI |
| `/find-dm <company>` | Find the hiring manager to contact | RapidAPI |
| `/verify <candidate>` | Verify candidate claims and flag red flags | RapidAPI |
| `/interview-prep <name>` | Generate identity verification questions | RapidAPI |
| `/find-jobs <role>` | Search live job boards for open roles | RapidAPI |
| `/enrich <name> at <co>` | Find verified email for a contact | Hunter/Icypeas |
| `/reverse <candidate>` | Find best jobs for a candidate, draft outreach | RapidAPI |
| `/pipeline` | View and update your active pipeline | Free |
| `/briefing` | Daily market intelligence briefing | Free |
| `/setup` | First-run configuration wizard | Free |
| `/help` | Full skill guide with examples | Free |
| **Workflow Commands** | | |
| `/connect` | Integration wizard (Gmail, Calendar, ATS, Airtable, HubSpot) | Free |
| `/send <name or company>` | Send a drafted outreach email via Gmail | Free |
| `/submit <candidate> to <role>` | Submit candidate to ATS (Greenhouse, Lever, Ashby, Bullhorn) | Free |
| `/workflow <company> for <role>` | End-to-end pipeline: signals → research → DM → email → outreach → send | Free |

> Both `/signals` and `/recruiter:signals` work — use whichever you prefer.

---

## API Costs

| Tier | Monthly Cost | What You Need | Skills Unlocked |
|------|-------------|---------------|-----------------|
| **Tier 1 — Free** | $0 | Nothing | 11 skills: signals, research, outreach, candidate-msg, resume-screen, market-map, score, pipeline, briefing, setup, help |
| **Tier 2 — Basic** | ~$50/mo | RapidAPI key (Fresh LinkedIn Profile Data + JSearch) | +6 skills: source, find-dm, verify, interview-prep, find-jobs, reverse |
| **Tier 3 — Pro** | ~$94–109/mo | RapidAPI + Hunter.io ($44/mo) or Icypeas ($59/mo) | +1 skill: email enrichment via `/enrich` |

All API keys are stored locally in `~/.recruiter-skills/config.yaml`. They are never sent anywhere except the API endpoints you configure.

---

## Data Storage

All data is stored in `~/.recruiter-skills/` on your machine:

```
~/.recruiter-skills/
  config.yaml          Your preferences and API keys
  data/
    leads/             Companies identified as opportunities
    candidates/        Candidate profiles and fit scores
    outreach/          Drafted email sequences
    research/          Company intelligence briefs
    briefings/         Daily briefing history
    pipeline.yaml      Active pipeline tracker
```

---

## FAQ

**Do I need all the API keys?**

No. 11 skills work free with no API keys at all. Run `/setup` and skip the API key steps — you can add them later from the same wizard.

**Which API should I add first?**

RapidAPI. It unlocks the most skills (candidate sourcing, finding hiring managers, live job search) for a single subscription at around $50/month.

**Is my data sent anywhere?**

Your data files stay on your machine. The only external calls are: web searches (via Claude's built-in WebSearch), and API calls to services you explicitly configure (RapidAPI, Hunter.io, or Icypeas). Claude Code itself communicates with Anthropic's API per their standard privacy policy.

**Can I use this across multiple machines?**

The skills install into `~/.claude/skills/` and data lives in `~/.recruiter-skills/`. You can sync these with Dropbox, iCloud, or a private git repo — but that's a manual step. The pack itself doesn't sync automatically.

**Something broke. Where do I start?**

Run `/setup` again — it checks your config and API key connectivity. Then run `/help` to confirm which skills are active for your tier.

**Can I customize the skills?**

Yes. Skills are plain markdown files in `~/.claude/skills/`. Open any `SKILL.md` and edit it. Re-run `install.sh` will overwrite customizations, so keep a backup if you modify them.

---

## Connectors

Run `/recruiter:connect` to auto-provision an Airtable pipeline board (Jobs, Candidates, Submissions, Leads) in 30 seconds. See [CONNECTORS.md](CONNECTORS.md) for the full list of supported integrations including Gmail, Google Calendar, Slack, HubSpot, and more.

---

## Want the Full Automated System?

These skills run one at a time in your terminal. The full Talent Signals platform runs 24/7: monitoring 25,000+ candidates, scanning 15+ job boards, stacking signals across every data source in your niche, and delivering scored opportunities to your dashboard every morning.

[Learn more at talentsignals.ai](https://talentsignals.ai)

---

## License

MIT. Free to use, modify, and distribute.

---

Built by [Talent Signals](https://talentsignals.ai). Questions? andrew@talentsignals.ai
