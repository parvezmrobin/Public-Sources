/**
 * Graph Coloring problem checks 
 * if a graph can be colored with 
 * given number of colors.
 * If so, prints the color combination
 */

public class GraphColoring {
	int n, nColor;
	boolean[][] graph;
	int[] colors;
	
	public GraphColoring(boolean[][] graph) {
		this.graph = graph;
		n = graph.length;
	}
	
	private boolean isSafe(int node, int color) {
		for(int i = 0; i<n; i++)
			//If there is a node between node and i
			//and i is colored with color
			//then node cannot be colored with color
			if(graph[node][i] && colors[i] == color)
				return false;
		return true;
	}
	
	public int[] generateColoredGraph(int noOfColores) {
		this.nColor = noOfColores;
		colors = new int[n];
		for(int i = 0; i<n; i++)
			colors[i] = -1;
		
		//If backtrack returns true, then return colors
		if(backtrack(0))
			return colors;
		else
			return null;
	}

	private boolean backtrack(int node) {
		if(node==n)
			return true;
		for(int i = 0; i<nColor; i++){
			if(isSafe(node, i)){
				//Color node with i
				colors[node] = i;
				
				//Check if this config can make a result
				if(backtrack(node+1))
					return true;
				
				//If cannot then uncolor and try next config
				colors[node] = -1;
			}
		}
		return false;
	}
	
	public static void main(String[] args) {
		boolean graph[][] = {
				{false, true, true, true},
	            {true, false, true, false},
	            {true, true, false, true},
	            {true, false, true, false},
	        };
		int[] res = new GraphColoring(graph).generateColoredGraph(3);
		
		if(res != null)
			for(int i : res)
				System.out.print(i + " ");
	}
}
