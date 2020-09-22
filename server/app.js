const express = require("express");
const swipl = require("swipl-stdio");

const engine = new swipl.Engine();

const app = express();
const port = 5000;

app.get("/test", async (req, res) => {
  const result = await engine.call("member(X, [1,2,3,4])");

  if (result) {
    res.send(`Variable X value is: ${result.X}`);
  } else {
    res.send("Call failed.");
  }
  // Either run more queries or stop the engine.
  engine.close();
});

app.get("/difficulty/:level", async (req, res) => {
  await engine.call("working_directory(_,ai)");
  await engine.call('consult(test)');

  const result = await engine.call("test(X, react)");

  if (result) {
    res.send(`Variable X value is: ${result.X}`);
  } else {
    res.send("Call failed.");
  }
  
  engine.close();
});

app.post("/play", async (req, res) => {

});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});