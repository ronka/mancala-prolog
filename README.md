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

- [x] Handle errors (for ex' there are no stones in a chosen hole).
- [x] Implement rule: if last pebble is in an empty pit, firstN the oppsite pebbels
- [x] Make the game interactive
- [x] Change to display function to return variables instead of outputing the board
- [x] Refactor functions to be more clean
- - [x] `LastT` & `firstN` are doing the same but behieve very differntly
- [] Document everything

#### GUI

- [ ] Starter screen
- [ ] End screen
- [ ] Option to restart to game while playing(not a must)

#### Server

- [x] Connect node app to prolog code
- [ ] Setup gameplay
