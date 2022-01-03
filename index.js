const express = require("express");
const app = express();

app.set("json spaces", 2);

app.get("/", (req, res, next) => {
  return res.status(200).json({
    message: "Hello from Zeet! Your function executed successfully!",
    request: {
      headers: req.headers,
      method: req.method,
      url: req.url,
      httpVersion: req.httpVersion,
      body: req.body,
      cookies: req.cookies,
      path: req.path,
      protocol: req.protocol,
      query: req.query,
      hostname: req.hostname,
      ip: req.ip,
      originalUrl: req.originalUrl,
      params: req.params,
    },
  });
});

app.use((req, res, next) => {
  return res.status(404).json({
    error: "Not Found",
  });
});

module.exports.handler = app;
