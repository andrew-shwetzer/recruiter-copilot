# Connectors

## How tool references work

Plugin files use `~~category` as a placeholder for whatever tool the user connects in that category. For example, `~~ATS` might mean Greenhouse, Lever, or any other ATS with an MCP server.

Plugins are **tool-agnostic** -- they describe workflows in terms of categories (ATS, email, calendar, etc.) rather than specific products. The `.mcp.json` pre-configures specific MCP servers, but any MCP server in that category works.

## Connectors for this plugin

| Category | Placeholder | Included servers | Other options |
|----------|-------------|-----------------|---------------|
| ATS | `~~ATS` | None (built-in skills) | Greenhouse, Lever, Ashby, Bullhorn |
| Pipeline tracker | `~~pipeline` | Airtable | Notion, Trello, Monday |
| Email | `~~email` | Gmail | Microsoft 365 |
| Calendar | `~~calendar` | Google Calendar | Microsoft 365 |
| Chat | `~~chat` | Slack | Microsoft Teams |
| Data enrichment | `~~data enrichment` | Clay | Apollo, ZoomInfo, Lusha |
| Meeting transcription | `~~conversation intelligence` | Fireflies | Gong, Otter.ai |
| CRM | `~~CRM` | HubSpot | Pipedrive, Salesforce, Close |

## Category details

### ~~ATS

Applicant Tracking System for candidate submissions and pipeline management.

**Supported via built-in skill commands:**
- Greenhouse -- `/recruiter:submit` and `/recruiter:connect`
- Lever -- `/recruiter:submit` and `/recruiter:connect`
- Ashby -- `/recruiter:submit` and `/recruiter:connect`
- Bullhorn -- `/recruiter:submit` and `/recruiter:connect`

No ATS vendor currently offers a remote HTTP MCP endpoint. Integration is
handled by the plugin's built-in commands using direct API calls. Credentials
are stored in `~/.recruiter-skills/config.yaml` via `/recruiter:connect`.

### ~~pipeline

Pipeline tracking for candidates and job openings. Auto-provisioned during
`/recruiter:connect` -- the recruiter doesn't configure anything.

- `airtable` -- Structured pipeline boards with candidate tracking, job openings, and submission history. Base and tables are created automatically on first connect.

### ~~email

Email integration for sending outreach and follow-ups.

- `gmail` -- Create drafts, search messages, read threads.

**Built-in alternative:** `/recruiter:send` provides copy-paste fallback when
no email integration is connected.

### ~~calendar

Calendar integration for scheduling interviews and follow-up reminders.

- `google-calendar` -- Create events, find free time, manage invites.

### ~~chat

Team communication for pipeline updates and candidate alerts.

- `slack` -- Send messages, search channels, read threads.

### ~~data enrichment

Contact and company data enrichment for sourcing and research.

- `clay` -- Find and enrich contacts, company data, run enrichment subroutines.

**Built-in alternative:** `/recruiter:enrich` uses Hunter.io or IcyPeas via
direct API calls configured in `~/.recruiter-skills/config.yaml`.

### ~~conversation intelligence

Meeting transcription and analysis for interview debriefs.

- `fireflies` -- Search transcripts, get summaries, access meeting recordings.

### ~~CRM

Customer Relationship Management for lead and client tracking.

- `hubspot` -- Search contacts, companies, deals. Log recruiting leads.

**Note:** Pipedrive is not yet available as a remote HTTP MCP server. If you
use Pipedrive, leads are tracked locally via `/recruiter:pipeline` until a
native MCP integration becomes available.
