/**
 * transform array to board string
 * 
 * @param {array} list 
 */
function array_to_string(list) {
    let board = "board("

    board += "[" + list.slice(0, 6).join(',') + "],";
    board += list[6] + ",";
    board += "[" + list.slice(7, 13).join(',') + "],";
    board += list[13]

    board += ")"

    return board;
}

/**
 * flatten board paradict to array
 * 
 * @param {prolog board} board 
 */
function board_to_array(board) {
    let arr = [];

    board = board.args;

    for (let i = 0; i < board.length; i++) {
        if (typeof board[i] === 'object') {
            arr = arr.concat(flatten_list(board[i]))
        } else {
            arr.push(board[i]);
        }
    }

    return arr;
}

/**
 * flatten prolog list with head and tail to array
 * 
 * @param {prolog list} list 
 */
function flatten_list(list) {
    let arr = [list.head];

    if (typeof list.tail === 'object') {
        arr = arr.concat(flatten_list(list.tail))
    }

    return arr;
}

function board_to_string(board) {
    return array_to_string(board_to_array(board));
}

module.exports = {
    flatten_list: flatten_list,
    board_to_array: board_to_array,
    array_to_string: array_to_string,
    board_to_string: board_to_string,
}