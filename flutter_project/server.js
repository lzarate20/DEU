import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';
import path from 'path';

const app = express();


const API_HOST = process.env.API_HOST || 'http://localhost:8080';


const buildPath = path.join(process.cwd(), 'build', 'web');
app.use(express.static(buildPath));


app.use('/api', createProxyMiddleware({
    target: API_HOST,
    changeOrigin: true,
    pathRewrite: {
        '^/api': '',
    },
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
