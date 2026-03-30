---
name: connect
description: "Integration setup wizard. Connects Gmail, Google Calendar, ATS (Greenhouse/Lever/Ashby/Bullhorn), Airtable pipeline, and HubSpot CRM. Run after /recruiter:setup."
argument-hint: "[--reset]"
model: sonnet
user_invocable: true
allowed-tools: [Read, Write, Bash, AskUserQuestion, Glob]
---

# /recruiter:connect — Integration Setup Wizard

You are running the integration configuration wizard for the Recruiter Skills Pack. This runs AFTER `/recruiter:setup` (which handles the recruiter profile and API keys). This wizard connects external tools: email, calendar, ATS, pipeline tracker, and CRM.

Be conversational and recruiter-friendly. No jargon. No JSON in the output. No raw API responses shown to the user.

---

## Step 0: Check Existing Config

Run:

```bash
cat ~/.recruiter-skills/config.yaml 2>/dev/null || echo "NO_CONFIG"
```

If config does NOT exist, say:

> "Looks like you haven't run setup yet. Run `/recruiter:setup` first to create your profile, then come back here to connect your tools."

Then stop.

If `--reset` was passed OR config exists but has no `integrations:` block, proceed to Step 1.

If config exists AND has an `integrations:` block and `--reset` was NOT passed, show the current integration status and say:

> "Your integrations are already configured. Run `/recruiter:connect --reset` to change them."

Show the current status table (see Step 7 format) and stop.

---

## Step 1: Welcome

Say:

> "Let's connect your tools. I'll walk you through email, calendar, your ATS, pipeline tracker, and CRM — takes about 3 minutes.
>
> You can skip any of these. Everything works without integrations, just with extra manual steps."

---

## Step 2: Email — Gmail or Outlook

Say:

> "Would you like Claude to send emails on your behalf?
>
> If you use Gmail or Outlook, you can connect it right in Claude.ai. Go to:
> **Settings > Integrations > Gmail** (or Outlook) and click Connect.
>
> Type **'gmail'**, **'outlook'**, or **'skip'**."

Wait for their response.

- If they say 'gmail' or 'google': set `email_provider = "gmail"`
- If they say 'outlook' or 'microsoft': set `email_provider = "outlook"`
- If they say 'skip' or blank: set `email_provider = "none"`
- If they ask how to find it: say "In Claude.ai, click your profile icon in the top right, then Settings, then Integrations. Gmail and Outlook are listed there. Click Connect and follow the prompts."

After they confirm: "Got it." and move on. Don't make them type 'done'.

---

## Step 3: Calendar — Google Calendar

Say:

> "Do you want me to be able to schedule interview reminders and follow-up tasks on your calendar?
>
> If you use Google Calendar, connect it at **Settings > Integrations > Google Calendar**.
>
> Type **'yes'**, **'google'**, or **'skip'**."

- If they say 'yes', 'google', or 'calendar': set `calendar_provider = "google"`
- If they say 'skip', 'no', or blank: set `calendar_provider = "none"`

Move on.

---

## Step 4: ATS System

Say:

> "Which ATS does your team use to track candidates and job openings?"

Show this list:

```
1. Greenhouse
2. Lever
3. Ashby
4. Bullhorn
5. Other (I'll note it, but direct integration isn't supported yet)
6. None / We don't use one
```

Wait for their selection. Accept the number or the name.

### If they pick Greenhouse (1):

Say:

> "To connect Greenhouse, I'll need your Harvest API key.
>
> Here's how to get it:
> - Go to **Configure > Dev Center > API Credential Management**
> - Click **Create New Credential**
> - Select **Harvest API** as the type
> - Give it a name like 'Recruiter Skills Pack'
> - Under permissions, enable **Candidates** (read + write) and **Jobs** (read)
> - Copy the key — you can only see it once
>
> Also grab your Greenhouse User ID: it's in your profile URL when logged in (e.g., app.greenhouse.io/people/YOUR_ID).
>
> Paste your API key:"

Wait for key. Then ask:

> "And your Greenhouse User ID (the number in your profile URL):"

Store: `ats_provider = "greenhouse"`, `ats_api_key`, `ats_user_id`, `ats_base_url = "https://harvest.greenhouse.io/v1"`

Run a silent key test:

```bash
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -u "ATS_API_KEY_HERE:" \
  "https://harvest.greenhouse.io/v1/jobs?status=open&per_page=1")
echo $HTTP_CODE
```

- `200`: Say "Greenhouse connected."
- `401` or `403`: Say "That key didn't authenticate. Double-check you copied it correctly from Configure > Dev Center. Want to try again or skip for now?"
- `429`: Say "Key looks valid but rate-limited right now — that's fine, we'll use it when it's ready."
- Other: Say "Couldn't reach Greenhouse right now. We'll save the key — test it later by running `/recruiter:connect --reset`."

### If they pick Lever (2):

Say:

> "To connect Lever, I'll need your API key.
>
> Here's how to get it (Super Admin access required):
> - Go to **Settings > Integrations and API > API Credentials**
> - Click **Generate New Key**
> - Name it 'Recruiter Skills Pack'
> - Copy the key
>
> Also grab your Lever User ID: visible in your profile settings or in the URL when viewing your user record.
>
> Paste your API key:"

Wait for key. Then ask:

> "And your Lever User ID:"

Store: `ats_provider = "lever"`, `ats_api_key`, `ats_user_id`, `ats_base_url = "https://api.lever.co/v1"`

Run silent key test:

```bash
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -u "ATS_API_KEY_HERE:" \
  "https://api.lever.co/v1/postings?state=published&limit=1")
echo $HTTP_CODE
```

Interpret results same as Greenhouse (200 = connected, 401/403 = bad key, etc.).

### If they pick Ashby (3):

Say:

> "To connect Ashby, I'll need your API key.
>
> Here's how to get it (Admin access required):
> - Go to **Admin > Integrations > API Keys**
> - Click **Create API Key**
> - Give it a name like 'Recruiter Skills Pack'
> - Enable **Jobs — Read** and **Candidates — Read + Write**
> - Copy the key immediately — Ashby won't show it again
>
> Paste your API key:"

Wait for key. No user ID needed for Ashby.

Store: `ats_provider = "ashby"`, `ats_api_key`, `ats_base_url = "https://api.ashbyhq.com"`

Run silent key test:

```bash
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  -u "ATS_API_KEY_HERE:" \
  -H "Accept: application/json; version=1" \
  -H "Content-Type: application/json" \
  -X POST "https://api.ashbyhq.com/job.list" \
  -d '{}')
echo $HTTP_CODE
```

200 = connected. Interpret other codes as above.

### If they pick Bullhorn (4):

Say:

> "Bullhorn uses OAuth2 authentication — it's a bit more involved than the others.
>
> To get credentials, you'll need to submit a support ticket to Bullhorn to request OAuth API access (client_id + client_secret). This is standard for Bullhorn integrations.
>
> Once you have those, you'll also need:
> - Your Bullhorn username
> - Your Bullhorn password
> - Your data center / swimlane (Bullhorn support will tell you this)
>
> Do you have these credentials ready? Type **'yes'** to enter them or **'skip'** to come back later."

If 'yes': Collect `client_id`, `client_secret`, `username`, `password` one at a time.

Store: `ats_provider = "bullhorn"`, plus all four credentials. Note that `ats_base_url` will be determined dynamically.

Say: "Bullhorn credentials saved. The connection will be tested when you first run `/recruiter:submit`."

If 'skip': set `ats_provider = "none"` and continue.

### If they pick Other (5):

Ask: "Which ATS do you use?" Accept their answer.

Say: "Noted — [ATS name] isn't directly integrated yet, but I'll log it. You can still use `/recruiter:submit` to track submissions locally. I'll let you know when more ATS integrations are added."

Store: `ats_provider = "other"`, `ats_name = [what they typed]`

### If they pick None (6):

Say: "No problem. Submissions will be tracked locally in your pipeline."

Set `ats_provider = "none"`.

---

## Step 5: Pipeline Tracker — Airtable (Auto-Provisioned)

This step auto-creates a complete recruiting pipeline in Airtable. The recruiter does NOT manually configure tables, fields, or views. The plugin handles everything.

### 5a: Check Airtable Connection

First, check if Airtable is connected by calling `mcp__claude_ai_Airtable__ping`. If it fails or returns an error, say:

> "To track your pipeline visually, let's connect Airtable. Go to **Settings > Integrations > Airtable** in Claude.ai and click Connect.
>
> Once connected, run `/recruiter:connect --reset` and I'll set up your pipeline automatically.
>
> Or type **'skip'** to track everything locally."

If they say 'skip': set `pipeline_provider = "local"` and move to Step 6.

If Airtable is connected, proceed to 5b.

### 5b: Search for Existing Pipeline Base

Call `mcp__claude_ai_Airtable__search_bases` with the query "Recruiting Pipeline".

- If a base named "Recruiting Pipeline" (or close match) is found, use its `baseId`. Call `mcp__claude_ai_Airtable__list_tables_for_base` to check what tables exist.
  - If the 4 expected tables already exist (Candidates, Jobs, Submissions, Leads), say "Found your existing pipeline base. You're all set." and store the `baseId`. Skip to 5d.
  - If the base exists but is missing tables, create only the missing ones (proceed to 5c).
- If NO matching base is found, say:

> "I need a blank Airtable base to build your pipeline in. This is a one-time step:
>
> 1. Open [airtable.com](https://airtable.com)
> 2. Click **+ Add a base** (or the + icon)
> 3. Name it **Recruiting Pipeline**
> 4. That's it. Come back here and type **'done'**.
>
> I'll build all the tables and fields automatically."

Wait for 'done', then search again. If still not found, ask them to double-check the name.

### 5c: Auto-Create Pipeline Tables

Once you have the `baseId`, create these 4 tables using `mcp__claude_ai_Airtable__create_table`. Create them in this order (Jobs first so Submissions can reference it).

**Table 1: Jobs**

```
name: "Jobs"
fields:
  - name: "Title", type: "singleLineText"  (primary field)
  - name: "Company", type: "singleLineText"
  - name: "Location", type: "singleLineText"
  - name: "Status", type: "singleSelect", choices: ["Open", "Filled", "On Hold", "Closed"]
  - name: "Signal Score", type: "number", precision: 0
  - name: "Contact Name", type: "singleLineText"
  - name: "Contact Email", type: "email"
  - name: "Notes", type: "multilineText"
  - name: "Added", type: "date", dateFormat: { name: "friendly" }
```

**Table 2: Candidates**

```
name: "Candidates"
fields:
  - name: "Name", type: "singleLineText"  (primary field)
  - name: "LinkedIn", type: "url"
  - name: "Current Title", type: "singleLineText"
  - name: "Current Company", type: "singleLineText"
  - name: "Location", type: "singleLineText"
  - name: "Email", type: "email"
  - name: "Phone", type: "phoneNumber"
  - name: "Fit Score", type: "rating", max: 10, icon: "star", color: "yellowBright"
  - name: "Status", type: "singleSelect", choices: ["New", "Screened", "Outreach Sent", "Replied", "Submitted", "Placed"]
  - name: "Source", type: "singleSelect", choices: ["Sourced", "Inbound", "Referral"]
  - name: "Notes", type: "multilineText"
  - name: "Added", type: "date", dateFormat: { name: "friendly" }
```

**Table 3: Submissions**

```
name: "Submissions"
fields:
  - name: "Candidate", type: "singleLineText"  (primary field)
  - name: "Job Title", type: "singleLineText"
  - name: "Company", type: "singleLineText"
  - name: "Status", type: "singleSelect", choices: ["Drafted", "Submitted", "Interview", "Offer", "Placed", "Rejected"]
  - name: "Submitted", type: "date", dateFormat: { name: "friendly" }
  - name: "Notes", type: "multilineText"
```

**Table 4: Leads**

```
name: "Leads"
fields:
  - name: "Company", type: "singleLineText"  (primary field)
  - name: "Domain", type: "url"
  - name: "Signal Type", type: "singleSelect", choices: ["Hiring", "Growth", "Leadership Change", "Funding"]
  - name: "Signal Detail", type: "singleLineText"
  - name: "Score", type: "number", precision: 0
  - name: "Status", type: "singleSelect", choices: ["New", "Researched", "Contacted", "Replied", "Converted"]
  - name: "Contact Name", type: "singleLineText"
  - name: "Contact Email", type: "email"
  - name: "Added", type: "date", dateFormat: { name: "friendly" }
```

After each table is created, note the `tableId` returned. If any table creation fails, tell the user which table failed and suggest running `/recruiter:connect --reset` to retry.

Do NOT show the user any API responses, table IDs, or field IDs. Just say:

> "Pipeline set up! Created 4 tables in your Airtable base:
> - **Jobs** — open roles you're tracking
> - **Candidates** — people in your pipeline
> - **Submissions** — who you've submitted where
> - **Leads** — companies showing hiring signals
>
> Your pipeline is ready. Skills like `/recruiter:signals` and `/recruiter:submit` will automatically sync here."

### 5d: Store Pipeline Config

Store in config.yaml:

```yaml
integrations:
  pipeline:
    provider: "airtable"
    base_id: "appXXXXXXXXXXXXXX"  # the actual base ID
```

---

## Step 6: CRM — HubSpot

Say:

> "Do you use HubSpot for your CRM? I can log leads there automatically.
>
> Connect it at **Settings > Integrations > HubSpot** in Claude.ai.
>
> Type **'yes'**, **'hubspot'**, or **'skip'**."

- If yes/hubspot: set `crm_provider = "hubspot"`
- If skip/no: set `crm_provider = "none"`

---

## Step 7: Write Config

Read the existing config:

```bash
cat ~/.recruiter-skills/config.yaml
```

Add or replace the `integrations:` block. Preserve all existing keys. Use the Write tool to save the updated file.

The integrations block should look like this (fill in actual values):

```yaml
integrations:
  email: "gmail"          # gmail | outlook | none
  calendar: "google"      # google | none
  ats:
    provider: "greenhouse"   # greenhouse | lever | ashby | bullhorn | other | none
    api_key: "sk-..."
    user_id: "112233"        # greenhouse and lever only; leave blank for ashby
    base_url: "https://harvest.greenhouse.io/v1"
    name: ""                 # only used when provider is "other"
    bullhorn_client_id: ""
    bullhorn_client_secret: ""
    bullhorn_username: ""
    bullhorn_password: ""
  pipeline:
    provider: "airtable"   # airtable | local
    base_id: ""            # Airtable base ID (auto-populated by Step 5)
  crm: "hubspot"          # hubspot | none
```

For providers not configured, use `"none"` as the value and leave credential fields as empty strings `""`.

---

## Step 8: Show Integration Status

After saving, display:

```
YOUR INTEGRATIONS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Email:     [Gmail / Outlook] ✓  (can send outreach directly)
  -- or --
  Email:     Not connected  (run /recruiter:connect --reset to add)

  Calendar:  Google Calendar ✓  (can schedule follow-up reminders)
  -- or --
  Calendar:  Not connected

  ATS:       [Greenhouse / Lever / Ashby / Bullhorn] ✓  (can submit candidates, track pipeline)
  -- or --
  ATS:       Not connected  (submissions tracked locally)

  Pipeline:  Airtable ✓  (4 tables: Jobs, Candidates, Submissions, Leads)
  -- or --
  Pipeline:  Local only  (tracked in ~/.recruiter-skills/data/)

  CRM:       HubSpot ✓  (leads logged automatically)
  -- or --
  CRM:       Not connected  (optional — connect HubSpot via Settings > Integrations)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

Show each integration on its own line. Use ✓ for connected, nothing for not connected. Show the actual provider name (e.g., "Gmail", "Greenhouse"), not the slug.

---

## Step 9: Suggest Next Steps

After the status display, say:

---

**What's next?**

- Run `/recruiter:workflow Acme Corp for Senior DevOps Engineer` to run the full pipeline end-to-end.
- Run `/recruiter:submit Jane Smith to Senior DevOps Engineer at Acme Corp` to push a candidate to your ATS.
- Run `/recruiter:send Acme Corp` to send a drafted outreach email.
- Run `/recruiter:setup --reset` if you need to update your recruiter profile or API keys.

---

## Error Handling

- If the config write fails, print the full YAML block in chat so they can copy-paste it into `~/.recruiter-skills/config.yaml` manually.
- If a key test returns a network error (curl: 6, curl: 7), save the key and tell them to test it later with `/recruiter:connect --reset`. Don't block.
- Never show raw API responses, curl output, or HTTP codes to the user. Translate everything into plain English.
- If the user gives an unexpected response to a question (e.g., types "idk"), ask one clarifying question, then move on with a sensible default.
