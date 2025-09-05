import request from 'supertest';
import { createApp, CasePayload, TriageResult } from '../index';
import { newDb } from 'pg-mem';

test('triage inserts case and returns ER_NOW', async () => {
  const db = newDb();
  const pg = db.adapters.createPg();
  const pool = new pg.Pool();

  const mockFetch = jest.fn().mockResolvedValue({
    json: async () => ({
      choices: [
        {
          message: { content: JSON.stringify({ recommendation: 'ER_NOW', reasoning: 'Chocolate is toxic' }) }
        }
      ]
    })
  });

  const app = createApp({ pool, fetchImpl: mockFetch as any });
  const payload: CasePayload = { species: 'dog', description: 'ate chocolate' };
  const res = await request(app)
    .post('/triage')
    .set('Authorization', 'user1')
    .send(payload);
  expect(res.status).toBe(200);
  const body: TriageResult = res.body;
  expect(body.recommendation).toBe('ER_NOW');

  const cases = await request(app).get('/cases').set('Authorization', 'user1');
  expect(cases.body.length).toBe(1);
  expect(cases.body[0].triage_result.recommendation).toBe('ER_NOW');
});
