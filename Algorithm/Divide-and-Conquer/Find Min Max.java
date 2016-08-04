public class MinMax {

	public static Pair<Integer> findMinMax(int[] a, int l, int h) {
	  
		if (h == l) {
			//If this division contains only one value 
	    	//this is both min and max value
			return new Pair<Integer>(a[l], a[l]);
		} else if (h - 1 == l) {
			//if this division contains two values
			//then make a pair of min and max value
			if (a[l] < a[h])
				return new Pair<Integer>(a[l], a[h]);
			else
				return new Pair<Integer>(a[h], a[l]);
		} else {
			//If the division contains more than two values
			//divide it into two division recursively
			//until the divisions contain one or two values
			int m = (l + h) / 2;
			Pair<Integer> pair1 = findMinMax(a, l, m);
			Pair<Integer> pair2 = findMinMax(a, m + 1, h);
			//When division is done combine result of two separate division
			//taking min and max from two returned pair
			return combine(pair1, pair2);
		}
	}
/*
 * Take two pair and make a new pair 
 * containing the min and max value from the given pairs
 */
	private static Pair<Integer> combine(Pair<Integer> pair1, Pair<Integer> pair2) {
	  int min = (pair1.getMin() < pair2.getMin()) ? pair1.getMin() : pair2.getMin();
		int max = (pair1.getMax() > pair2.getMax()) ? pair1.getMax() : pair2.getMax();
		return new Pair<Integer>(min, max);
	}

/*
 * A samble main method to run the code
 */
	public static void main(String[] args) {
		int[] a = { 34, 32, 5, 234, 5, 23, 1, 3243, 43, 67 };
		System.out.println(findMinMax(a, 0, 9));
	}

}

/*
 * A class for wrapping 
 * the minimum and 
 * maximum value together.
 */
class Pair<T> {
	private T min, max;

	public Pair(T min, T max) {
		this.max = max;
		this.min = min;
	}

	public T getMax() {
		return max;
	}

	public T getMin() {
		return min;
	}

	public void setMax(T max) {
		this.max = max;
	}

	public void setMin(T min) {
		this.min = min;
	}

	@Override
	public String toString() {
		return "Min : " + min + ", Max : " + max;
	}
}
