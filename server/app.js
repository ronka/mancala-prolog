const { findAllByAltText } = require("@testing-library/react");
const express = require("express");
const swipl = require("swipl-stdio");
const { board_to_array } = require("./helpers.js");
const helpers = require("./helpers.js");

const app = express();
const port = 5000;

const engine = new swipl.Engine();

(async () => {
  await engine.call("working_directory(_,ai)");
  await engine.call('consult(main)');
})();

app.use(express.json());

app.get("/play", async (req, res) => {
  // init game
});

app.post("/move", async (req, res) => {
  const { board, move } = req.body;
  const depth = req.body.depth || 1;

  const response = {
    'succuss': true,
    'board': [],
    'winner': null,
    'player': {
      'extraTurn': false
    },
    'ai': {
      'moves': []
    }
  }

  try {
    var query = `play(${helpers.array_to_string(board)}, player, ${move}, AfterBoard, ExtraTurn, Winner)`;
    var { AfterBoard, ExtraTurn, Winner } = await engine.call(query);
  } catch (error) {
    res.status(400).json({ 'succuss': false, 'error': error })
    engine.close();
    return;
  }

  response.board.push(helpers.board_to_array(AfterBoard));

  if (Winner !== null) {
    response.winner = Winner;
    res.json(response);
    engine.close();
    return;
  }

  if (ExtraTurn) {
    resoinse.player.extraTurn = true;
    res.json(response);
    return;
  }

  try{
    var queryAI = `play(${helpers.board_to_string(AfterBoard)}, ai, ${depth}, FinalBoard, Moves, WinnerAI)`;
    var { FinalBoard, Moves, WinnerAI } = await engine.call(queryAI);
  } catch(error){
    res.status(400).json({ 'succuss': false, 'error': error })
    engine.close();
    return;
  }

  response.winner = WinnerAI;
  response.board.push(helpers.board_to_array(FinalBoard));
  response.ai.moves = helpers.flatten_list(Moves);
  res.json(response);
});

app.listen(port, () => {
  console.log(`Example app listening at http://localhost:${port}`);
});
