const express = require('express');

const app = express();

app.get('/', (req, res) => {
    res.json({
        service: 'KijaniKiosk Payments',
        status: 'running'
    });
});

module.exports = app;

if (require.main === module) {
    const PORT = process.env.PORT || 3000;

    app.listen(PORT, () => {
        console.log(`Payments service running on port ${PORT}`);
    });
}
