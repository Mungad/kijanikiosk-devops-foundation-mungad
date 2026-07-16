const request = require('supertest');
const app = require('../src/index');

describe('KijaniKiosk Payments', () => {
    test('GET / returns service status', async () => {
        const response = await request(app).get('/');

        expect(response.statusCode).toBe(200);
        expect(response.body.service).toBe('KijaniKiosk Payments');
        expect(response.body.status).toBe('running');
    });
});
