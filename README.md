# Chess-iOS-app

This project is a chess app made for the iPad and iPhone.
In a nut shell it allows two individuals to play chess in person on an iPad or iPhone.


## Functionality

* Players are prevented from making ilegal moves
* Notifications displayed when check occurs or the game has ended
* Players can take back moves i.e. rewind the game
* A chess clock can be enabled to play timed games
* Players can save games to come back to later
* PLayers can pause the game if it is timed


### Game Play DEMO

Here's a quick demo illustrating a timed game with a maximum of 3 take backs for each player.

![Game Play](https://github.com/jbeenie/Gifs/blob/master/ChessApp/game_play.gif)


### Promotion of Pieces DEMO

![Promotions](https://github.com/jbeenie/Gifs/blob/master/ChessApp/Promotion.gif)



## Controls
Move pieces: tap on piece then tap on destination position
Pause/Unpause Game: Double 2-finger-tap board (only applicable when chess clock is enabled)
Takeback move: Single 2-finger-tap board (only applicable if takebacks are enabled and player has 1 or more takebacks remaining)


## Configurable settings

### User can:

* disable/enable notifications related to game play
* disable animation of the movement of chess pieces
* chose color scheme of the chessboard
* disable or enable chess clock
* chose time on clock
* disable or enable takebacks
* chose the maximum number of takebacks within game

### Game Settings DEMO

![Settings](https://github.com/jbeenie/Gifs/blob/master/ChessApp/Settings.gif)

 

## Implementation

Game settings persisted using NSUserDefaults
Actual Games saved using Core data (SQLLite), serialized using NSCoding

### Saving Games DEMO

![Saving Games](https://github.com/jbeenie/Gifs/blob/master/ChessApp/Saving_Games.gif)


## Graphic Design

App Logo designed with the help of Stas Pakhomov(stas@miarez.com)
