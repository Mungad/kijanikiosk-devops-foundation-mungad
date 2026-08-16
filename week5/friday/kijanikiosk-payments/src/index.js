const app = require("./app");

const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || "v1.3.0";

const server = app.listen(PORT, () => {
  console.log(`Payments service ${VERSION} running on port ${PORT}`);
});

process.on("SIGTERM", () => {
  console.log("Shutting down...");
  server.close(() => process.exit(0));
});

