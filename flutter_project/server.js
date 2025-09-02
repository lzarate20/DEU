import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import path from 'path';
import crypto from 'crypto';
import fetch from 'node-fetch';

const app = express();
const API_HOST = process.env.API_HOST || 'http://localhost:8080';
const buildPath = path.join(process.cwd(), 'build', 'web');

app.use(express.json());


app.use(express.static(buildPath, {
    setHeaders: (res, path) => {
        if (path.endsWith('.html')) {
            res.setHeader('Content-Type', 'text/html; charset=UTF-8');
        }
    }
}));


const sessions = new Map();
function generateSessionId() {
    return crypto.randomBytes(32).toString('hex');
}


function authMiddleware(req, res, next) {
    const bearer = req.headers['authorization'];
    if (!bearer) return res.status(401).json({ error: 'No token' });

    const sessionId = bearer.split(' ')[1];
    const session = sessions.get(sessionId);

    if (!session) return res.status(401).json({ error: 'Invalid session' });

    if (session.expiresAt < Date.now()) {
        sessions.delete(sessionId);
        return res.status(401).json({ error: 'Session expired' });
    }

    req.sessionId = sessionId;
    req.userId = session.userId;
    req.headers['authorization'] = `Bearer ${session.jwt}`;
    next();
}


app.get('/api/session', (req, res) => {
    const bearer = req.headers['authorization'];
    if (!bearer) return res.status(401).json({ error: 'No token' });

    const sessionId = bearer.split(' ')[1];
    const session = sessions.get(sessionId);

    if (!session) return res.status(401).json({ error: 'Invalid session' });

    if (session.expiresAt < Date.now()) {
        sessions.delete(sessionId);
        return res.status(401).json({ error: 'Session expired' });
    }

    res.json({ active: true, userId: session.userId });
});


app.post('/api/auth', async (req, res) => {
    const { email, password } = req.body;
    try {
        const response = await fetch(`${API_HOST}/api/auth`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) return res.status(401).json({ error: 'Invalid credentials' });

        const { token: jwt, user } = await response.json();
        const sessionId = generateSessionId();
        sessions.set(sessionId, { userId: user.id, jwt, expiresAt: Date.now() + 3600000 });

        res.json({ token: sessionId, user: { id: user.id, type: user.type } });
    } catch {
        res.status(500).json({ error: 'Server error' });
    }
});


app.post('/api/auth/user', async (req, res) => {
    try {
        const response = await fetch(`${API_HOST}/api/auth/user`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(req.body)
        });
        res.sendStatus(response.status);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});


app.post('/api/logout', (req, res) => {
    if (req.sessionId != null) {
        sessions.delete(req.sessionId);
    }
    res.json({ success: true });
});


app.use('/api', authMiddleware, createProxyMiddleware({
    target: API_HOST,
    changeOrigin: true,
    selfHandleResponse: false,
    onProxyReq: (proxyReq, req, res) => {
        if (req.body) {
            const bodyData = JSON.stringify(req.body);
            proxyReq.setHeader('Content-Length', Buffer.byteLength(bodyData));
            proxyReq.write(bodyData);
            proxyReq.end();
        }
    },
}));


app.get('/health', (req, res) => res.send('OK'));


app.get('*', (req, res) => {
    res.setHeader('Content-Type', 'text/html; charset=UTF-8');
    res.sendFile(path.join(buildPath, 'index.html'));
});


const PORT = process.env.PORT || 80;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

