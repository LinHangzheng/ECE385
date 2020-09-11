# ECE385
ECE385 lab from UIUC
If you are from the same course, please don't copy our code, we will not be held responsible for your guys' cheating.

The final project has been completed.
# Avalon
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/start.png" width = "500" alt = "start"/>
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/home.jpg" width = "350" alt = "home"/>
Our final project is about 1st person 2.5-D game. You can control our hero(Saber) to fight with monsters.

- key control
  - WSAD: moving
  - J: normal attack
  - K: Excalibur
  - L: Block
  - ENTER: start the game
  - ESC: Restart the game
  - BACKSPACE: Restart the game and set the game to developer mode
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/attack.jpg" width = "350" alt = "attack"/>
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/Excalibur.jpg" width = "350" alt = "Excalibur"/>
We modified the key control part so that our game can deal with 4 key presses simultaneously.(even though you may just need 3)

- How to win
  - There are 5 rounds of fighting in Avalon. If saber kills all the monsters, you win the game.
  - If saber loses all health or let any monsters cross the bridge, you lose the game.
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/gameover.jpg" width = "350" alt = "gameover"/>

- Monsters
  - All the monsters will appear at the right most of the bridge and walk left. 
  - When they touch saber, they will give damage to saber and push saber back
  - As the number of rounds increases, the monster moves faster and has more health
  - Their attack actions are determined by a random number (attack probability), when they are attacking, they cannot be attacked 
    by saber
<img src ="https://github.com/LinHangzheng/ECE385/raw/master/FinalProject/image/images/win.jpg" width = "350" alt = "home"/>

# How to run
- Pip all the codes in your computer and compile them in the Quartus, connect your computer to DE2-115 developer board.
- Press "Programmer" - "Start" in Quartus to transfer hardware data to DE2-115.
- Connect your DE2-115 with keyboard and VGA
- Compile the C code in eclipse and run the code
- Then you will see the home of the game on the screen



