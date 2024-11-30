const server = require('express');
const path = require('path');
const cors = require('cors');

const app = server();

// Configura CORS si es necesario (opcional, para permitir solicitudes desde diferentes orígenes)
app.use(cors());

// Sirve archivos estáticos desde el directorio 'public'
app.use(server.static(path.join(__dirname, 'dist')));

// Redirige las solicitudes a la API al servidor de API
app.use('/api', (req, res) => {
    // Aquí puedes redirigir las solicitudes a otro servidor o manejar la lógica de la API.
    // Suponiendo que rediriges a http://api:4000:
    const apiUrl = 'http://api:4000';
    const url = `${apiUrl}${req.url}`;

    // Redirige la solicitud al backend de la API
    // Puedes usar una librería como `http-proxy-middleware` para esto:
    const { createProxyMiddleware } = require('http-proxy-middleware');
    app.use('/api', createProxyMiddleware({ target: apiUrl, changeOrigin: true }));
});

// Para manejar cualquier otra ruta y servir el archivo 'index.html'
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

// Configura el puerto y comienza a escuchar
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});