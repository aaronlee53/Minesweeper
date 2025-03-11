import de.bezier.guido.*;


public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
private MSButton[][] buttons; 
private ArrayList<MSButton> mines = new ArrayList<MSButton>(); 
public void setup() {
    size(400, 400);
    textAlign(CENTER, CENTER);

    
    Interactive.make(this);

    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c] = new MSButton(r, c);
        }
    }
    setMines();
}

public void setMines() {
    while (mines.size() < 55) { // mines
        int randomRow = (int) (Math.random() * NUM_ROWS);
        int randomCol = (int) (Math.random() * NUM_COLS);
        if (!mines.contains(buttons[randomRow][randomCol])) {
            mines.add(buttons[randomRow][randomCol]);
        }
    }
}

public void draw() {
    background(0);
    if (isWon()) {
        displayWinningMessage();
    }
}

public boolean isWon() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            if (!mines.contains(buttons[r][c]) && !buttons[r][c].clicked) {
                return false;
            }
        }
    }
    return true;
}

public void displayLosingMessage() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel("L");
        }
    }
    for (MSButton mine : mines) {
        mine.setLabel("💥");
    }
}

public void displayWinningMessage() {
    for (int r = 0; r < NUM_ROWS; r++) {
        for (int c = 0; c < NUM_COLS; c++) {
            buttons[r][c].setLabel("W");
        }
    }
    for (MSButton mine : mines) {
        mine.setLabel("💥");
    }
}

public boolean isValid(int r, int c) {
    return r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS;
}

public int countMines(int row, int col) {
    int numMines = 0;
    for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
            if (isValid(r, c) && mines.contains(buttons[r][c])) {
                numMines++;
            }
        }
    }
    return numMines;
}

public class MSButton {
    private int myRow, myCol;
    private float x, y, width, height;
    private boolean clicked, flagged;
    private String myLabel;

    public MSButton(int row, int col) {
        width = 400 / NUM_COLS;
        height = 400 / NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol * width;
        y = myRow * height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add(this);
    }

    public void mousePressed() {
        clicked = true;

        if (mouseButton == RIGHT) {
            flagged = !flagged;
            if (!flagged) clicked = false;
        } else if (mines.contains(this)) {
            displayLosingMessage();
        } else {
            int mineCount = countMines(myRow, myCol);
            if (mineCount > 0) {
                setLabel(mineCount);
            } else {
                for (int r = myRow - 1; r <= myRow + 1; r++) {
                    for (int c = myCol - 1; c <= myCol + 1; c++) {
                        if (isValid(r, c) && buttons[r][c] != this && !buttons[r][c].clicked) {
                            buttons[r][c].mousePressed();
                        }
                    }
                }
            }
        }
    }

    public void draw() {
        if (flagged) fill(0);
        else if (clicked && mines.contains(this)) fill(255, 0, 0);
        else if (clicked) fill(200);
        else fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel, x + width / 2, y + height / 2);
    }

    public void setLabel(String newLabel) {
        myLabel = newLabel;
    }

    public void setLabel(int newLabel) {
        myLabel = "" + newLabel;
    }
}
