import express, { Request, Response, NextFunction } from 'express';
import Ajv, { JSONSchemaType } from 'ajv';
import { Pool } from 'pg';

export interface CasePayload {
  species: string;
  description: string;
}

export interface TriageResult {
  recommendation: 'ER_NOW' | 'ER_SOON' | 'HOME_MONITOR';
  reasoning: string;
}

const triageResultSchema: JSONSchemaType<TriageResult> = {
  type: 'object',
  properties: {
    recommendation: { type: 'string', enum: ['ER_NOW', 'ER_SOON', 'HOME_MONITOR'] },
    reasoning: { type: 'string' }
  },
  required: ['recommendation', 'reasoning'],
  additionalProperties: false
};

const ajv = new Ajv();
const validateTriage = ajv.compile(triageResultSchema);

interface Deps {
  pool?: Pool;
  fetchImpl?: typeof fetch;
}

interface AuthedRequest extends Request {
  userId?: string;
}

export function createApp({ pool, fetchImpl }: Deps = {}) {
  const app = express();
  app.use(express.json());

  const db = pool ?? new Pool({ connectionString: process.env.DATABASE_URL });
  const doFetch = fetchImpl ?? fetch;

  async function initDb() {
    await db.query(`CREATE TABLE IF NOT EXISTS users (id TEXT PRIMARY KEY);`);
    await db.query(`CREATE TABLE IF NOT EXISTS pets (id SERIAL PRIMARY KEY, user_id TEXT REFERENCES users(id));`);
    await db.query(`CREATE TABLE IF NOT EXISTS cases (
      id SERIAL PRIMARY KEY,
      user_id TEXT NOT NULL,
      case_payload JSONB NOT NULL,
      triage_result JSONB NOT NULL,
      created_at TIMESTAMPTZ DEFAULT now()
    );`);
  }
  initDb();

  function auth(req: AuthedRequest, res: Response, next: NextFunction) {
    const authHeader = req.header('authorization');
    if (!authHeader) return res.status(401).send('Unauthorized');
    req.userId = authHeader.replace('Bearer ', '');
    next();
  }

  app.post('/triage', auth, async (req: AuthedRequest, res: Response) => {
    const payload: CasePayload = req.body;
    const messages = [
      { role: 'system', content: 'You are a veterinary triage model. Return JSON matching schema.' },
      { role: 'user', content: JSON.stringify(payload) }
    ];

    async function callModel(extra?: string) {
      const body = {
        model: 'gpt-4o-mini',
        messages: extra ? [...messages, { role: 'user', content: extra }] : messages,
        response_format: { type: 'json_object' }
      };
      const response = await doFetch('https://api.openai.com/v1/chat/completions', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
        },
        body: JSON.stringify(body)
      });
      const data = await response.json();
      const content = data.choices?.[0]?.message?.content;
      if (!content) return null;
      try {
        return JSON.parse(content);
      } catch {
        return null;
      }
    }

    let result = await callModel();
    if (!result || !validateTriage(result)) {
      result = await callModel('return valid JSON per schema only');
      if (!result || !validateTriage(result)) {
        return res.status(500).json({ error: 'Model returned invalid response' });
      }
    }

    await db.query('INSERT INTO cases (user_id, case_payload, triage_result) VALUES ($1, $2, $3)', [req.userId, payload, result]);
    res.json(result);
  });

  app.get('/cases', auth, async (req: AuthedRequest, res: Response) => {
    const limit = Number(req.query.limit ?? '20');
    const { rows } = await db.query('SELECT * FROM cases WHERE user_id = $1 ORDER BY created_at DESC LIMIT $2', [req.userId, limit]);
    res.json(rows);
  });

  return app;
}

if (require.main === module) {
  const app = createApp();
  const port = process.env.PORT || 3000;
  app.listen(port, () => {
    console.log(`Server running on ${port}`);
  });
}
