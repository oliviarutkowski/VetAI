# VetAI Backend

## Setup

1. Copy `.env.example` to `.env` and fill in values for `OPENAI_API_KEY` and `DATABASE_URL`.
2. Install dependencies: `npm install`.
3. Run tests: `npm test`.
4. Start server: `npm start`.

The server exposes:

- `POST /triage` accepting a `CasePayload` and returning a validated `TriageResult`.
- `GET /cases?limit=20` returning recent cases for the authenticated user.

Both endpoints require an `Authorization` header containing the user token.
