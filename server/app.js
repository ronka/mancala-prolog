const express = require("express");
const swipl = require("swipl-stdio");
const helpers = require("./helpers.js");

const app = express();
const port = 5000;

const engine = new swipl.Engine();

// #TODO: DELETE THIS AFTER DOING THE PLAY ENDPOINT
(async () => {
  await engine.call("working_directory(_,ai)");
  await engine.call('consult(main)');
})();

app.use(express.json());

app.get("/play", async (req, res) => {
  const query = `initialize(easy, Board, player)`;

  try {
    var { Board } = await engine.call(query);
  } catch (error) {
    res.status(400).json({ 'succuss': false, 'error': error, 'query': query })
    return;
  }

  res.json({
    'board': helpers.board_to_array(Board)
  })
});

app.post("/move", async (req, res) => {
  const { board, move } = req.body;
  const depth = req.body.depth || 'easy';

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
  } catch( error ) {
    res.status(400).json({ 'succuss': false, 'error': error, 'board': board })
    return;
  }

  try {
    var { AfterBoard, ExtraTurn, Winner } = await engine.call(query);
  } catch (error) {
    res.status(400).json({ 'succuss': false, 'error': error, 'query': query })
    return;
  }

  response.board.push(helpers.board_to_array(AfterBoard));

  if (Winner !== null) {
    response.winner = Winner;
    res.json(response);
    // engine.close();
    return;
  }

  if (ExtraTurn) {
    response.player.extraTurn = true;
    res.json(response);
    return;
  }
  
  try {
    var queryAI = `play(${helpers.board_to_string(AfterBoard)}, ai, ${depth}, FinalBoard, Moves, WinnerAI)`;
  } catch( error ) {
    res.status(400).json({ 'succuss': false, 'error': error, 'board': board })
    return;
  }

  try{
    var { FinalBoard, Moves, WinnerAI } = await engine.call(queryAI);
  } catch(error){
    res.status(400).json({ 'succuss': false, 'error': error, 'query': query })
    // engine.close();
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
