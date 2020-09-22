## Mancala Game Powered By Prolog Engine

Mancala game powered by react for gui, express for server side and prolog for the engine.

The project requires you to have swi-prolog installed and have `swipl` in PATH.

### How to setup

```shell
npm run project:setup
```

### Run project

The GUI and the server are two different server, inorder to get them up and running you will need to run the following commands in different terminals.

```shell
npm run project:start:gui
npm run project:start:server
```

### TODO:


#### Prolog engine

- [ ] Implement rule: if last pebble is in an empty pit, take the oppsite pebbels
- [ ] Make the game interactive
- [ ] Change to display function to return variables instead of outputing the board
- [ ] Refactor functions to be more clean
- - [ ] `LastT` & `take` are doing the same but behieve very differntly
- [ ] Document everything

- [ ] ** STICH EVERYTHING TOGETHER **

#### GUI

- [ ] Starter screen
- [ ] End screen
- [ ] Option to restart to game while playing(not a must)

#### Server

- [ ] Connect node app to prolog code
- [ ] Endpoint to change difficulty
- [ ] Endpoint to make the user move
- [ ] Endpoint to get the AI move
