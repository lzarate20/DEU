import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import path from 'path';
import crypto from 'crypto';
import fetch from 'node-fetch';

const app = express();
const API_HOST = process.env.API_HOST || 'http://localhost:8080';


const buildPath = path.join(process.cwd(), 'build', 'web');
app.use(express.static(buildPath));
app.use(express.json());


const sessions = new Map();

function generateSessionId() {
    return crypto.randomBytes(32).toString('hex');
}

function authMiddleware(req, res, next) {
    const bearer = req.headers['authorization'];
    if (!bearer) return res.status(401).json({ error: 'No token' });

    const sessionId = bearer.split(' ')[1];
    const session = sessions.get(sessionId);

    if (session) {
        req.sessionId = sessionId;
        req.userId = session.userId;

        req.headers['authorization'] = `Bearer ${session.jwt}`;

        next();
    } else {
        return res.status(401).json({ error: 'Invalid session' });
    }
}

app.post('/auth', async (req, res) => {
    const { email, password } = req.body;

    try {
        const response = await fetch(`${API_HOST}/auth`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ email, password })
        });

        if (!response.ok) return res.status(401).json({ error: 'Invalid credentials' });

        const data = await response.json();
        const { token: jwt, user } = data;

        const sessionId = generateSessionId();
        sessions.set(sessionId, {
            userId: user.id,
            jwt:jwt,
            expiresAt: Date.now() + 3600000
        });

        res.json({ token: sessionId, user: { id: user.id, type: user.type } });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Server error' });
    }
});


app.post('/logout', authMiddleware, (req, res) => {
    const sessionId = req.headers['authorization']?.split(' ')[1];
    sessions.delete(sessionId);
    res.json({ success: true });
});


app.use('/api', authMiddleware, createProxyMiddleware({
    target: API_HOST,
    changeOrigin: true,
    pathRewrite: path => path
}));


app.get('/health', (req, res) => {
    res.status(200).send('OK');
});


app.get('*', (req, res) => {
    res.sendFile(path.join(buildPath, 'index.html'));
});


const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

