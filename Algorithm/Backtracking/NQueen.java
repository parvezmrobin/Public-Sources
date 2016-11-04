/*
 * N Queen problem is to place N Queens 
 * in N X N sized chess board that
 * no queen attacks each other
 */
public class NQueen {
	int n;
	boolean[][] isOccupied;

	public NQueen(int size) {
		n = size;
		isOccupied = new boolean[n][n];
	}

	private boolean isSafe(int row, int col) {
		/*
		 * Since we are going from left to right
		 * we don't need to check for any Queen in right
		 * but only in left side
		 */
		
		//Find a Queen in same row
		for (int i = 0; i < col; i++) {
			if (isOccupied[row][i])
				return false;
		}

		//Find a Queen in upper diagonal
		for (int i = row, j = col; i >= 0 && j >= 0; i--, j--) {
			if (isOccupied[i][j])
				return false;
		}

		//Find a Queen in lower diagonal
		for (int i = row, j = col; i < n && j >= 0; i++, j--) {
			if (isOccupied[i][j])
				return false;
		}
		
		//If nothing found, return true
		return true;
	}

	private void printSolve() {
		for (int i = 0; i < n; i++) {
			for(int j = 0; j<n; j++)
				System.out.print("+---");
			System.out.println("+");
			for (int j = 0; j < n; j++) {
				if (isOccupied[i][j])
					System.out.print("| Q ");
				else
					System.out.print("|   ");
			}
			System.out.println("|");
		}
		for(int j = 0; j<n; j++)
			System.out.print("+---");
		System.out.println("+");
	}

	public void generateSolve() {
		for (int i = 0; i < n; i++) {
			for (int j = 0; j < n; j++) {
				isOccupied[i][j] = false;
			}
		}
		if (backtrack(0)) {
			printSolve();
		} else {
			System.out.println("No solve exists.");
		}
	}

	public boolean backtrack(int col) {
		//If n Queens are placed, then return true
		if(col>=n)
			return true;
		
		for(int i = 0; i<n; i++){
			//Search for a safe place in current column 
			//where we can place our Queen
			if(isSafe(i, col)){
				//Place a queen here
				isOccupied[i][col] = true;
				
				//Try to place a queen in next column
				if(backtrack(col+1))
					return true;
				
				//If a Queen couldn't be placed in next column
				//then remove this Queen and try to 
				//place it elsewhere in current row and try again
				isOccupied[i][col] = false;
			}
		}
		
		//If Queen cannot be placed in current column
		//then backtrack and find another solution
		return false;
	}
	
	public static void main(String[] args) {
		new NQueen(8).generateSolve();
	}
}
