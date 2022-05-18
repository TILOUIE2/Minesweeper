import de.bezier.guido.*;
//Declare and initialize constants 
public final static int NUM_ROWS = 15;
public final static int NUM_COLS = 15;
public final static int NUM_MINES = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private String message = "";

void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
}
public void setMines()
{   
    while(mines.size() < NUM_MINES){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c])){
        mines.add(buttons[r][c]);
      }
    }
}

public void draw ()
{
    background(255);
    textSize(40);
    text(message, 200, 420);
    textSize(20);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for(int r = 0; r < NUM_ROWS; r++){
      for(int c = 0; c < NUM_COLS; c++){
        if(mines.contains(buttons[r][c]) && !buttons[r][c].flagged){
          return false;
        }
        if(!mines.contains(buttons[r][c]) && !buttons[r][c].clicked){
          return false;
        }
      }
    }
    return true;
}
public void displayLosingMessage()
{
    for(int i = 0; i < mines.size(); i++){
      if(mines.get(i).clicked == true){
        message = "Lose :(";
         for(int r = 0; r < NUM_ROWS; r++){
          for(int c = 0; c < NUM_COLS; c++){
           if(buttons[r][c].flagged == true){
            buttons[r][c].flagged = false; 
           }
           buttons[r][c].mousePressed();
          }
        }
      }
    }
}
public void displayWinningMessage()
{
    if(isWon() == true){
      message = "Win :)";
    }
}
public boolean isValid(int r, int c)
{
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS){
     return true; 
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for(int r = row - 1; r <= row +1; r++){
     for(int c = col - 1; c <= col +1; c++){
      if(isValid(r,c) == true && mines.contains(buttons[r][c])){
        numMines++;
      }
     }
    }
    //if(mines.contains(buttons[row][col])){
    //  numMines--;
    //}
    return numMines;
}

public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(clicked == true){
        return;
      }
       clicked = true;  
      //your code here
        if(flagged == true){
         clicked = false; 
        }
        if(mouseButton == RIGHT){
          if(flagged == false){
           flagged = true; 
           clicked = false;
          }
          else if(flagged == true){
           flagged = false;
           clicked = false;
          }
        }
        else if(mines.contains(this)){
          displayLosingMessage();
        }
        else if(countMines(myRow, myCol) > 0){
          myLabel = "" + countMines(myRow, myCol);
        }
        else{
          //top
          if(isValid(myRow - 1,myCol - 1) == true && !buttons[myRow-1][myCol-1].clicked){
            buttons[myRow -1][myCol - 1].mousePressed();
          }
          if(isValid(myRow - 1,myCol) == true && !buttons[myRow-1][myCol].clicked){
            buttons[myRow -1][myCol].mousePressed();
          }
          if(isValid(myRow - 1,myCol + 1) == true &&!buttons[myRow-1][myCol+1].clicked){
            buttons[myRow - 1][myCol + 1].mousePressed();
          }
          //middle
          if(isValid(myRow, myCol - 1) == true && !buttons[myRow][myCol-1].clicked){
            buttons[myRow][myCol - 1].mousePressed();
          }
          if(isValid(myRow ,myCol + 1) == true && !buttons[myRow][myCol+1].clicked){
            buttons[myRow][myCol + 1].mousePressed();
          }
          //bottom
          if(isValid(myRow + 1,myCol - 1) == true && !buttons[myRow+1][myCol-1].clicked){
            buttons[myRow +1][myCol - 1].mousePressed();
          }
          if(isValid(myRow + 1,myCol) == true && !buttons[myRow+1][myCol].clicked){
            buttons[myRow +1][myCol].mousePressed();
          }
          if(isValid(myRow + 1,myCol + 1) == true && !buttons[myRow+1][myCol+1].clicked){
            buttons[myRow + 1][myCol + 1].mousePressed();
          }
     
     }
 
    }

    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
        
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
