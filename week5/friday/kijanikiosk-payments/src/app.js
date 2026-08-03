const express = require("express");

const app = express();
const VERSION = process.env.APP_VERSION || "v1.3.0";

app.get("/", (req, res) => {
  res.json({
    service: "KijaniKiosk Payments",
    status: "running",
    version: VERSION
  });
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    version: VERSION
  });
});

module.exports = app;
