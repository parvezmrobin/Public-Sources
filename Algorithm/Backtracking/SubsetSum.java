/**
 * Subset Sum problem is to find a subset
 * from a given set of which sum is also given.
 */

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

public class SubsetSum {
	// Underlying set;
	ArrayList<Integer> set;
	ArrayList<Integer> subset;
	int sum;

	/**
	 * @category Constructor
	 * @param collection
	 *            Any collection like ArrayList, Set, Map etc
	 */
	public SubsetSum(Collection<Integer> collection) {
		set = new ArrayList<Integer>();
		set.addAll(collection);
	}

	public ArrayList<Integer> findSubset(int sum) {
		this.sum = sum;
		subset = new ArrayList<>();
		if (backtrack(0, 0)) {
			//Reverse the order 
			//Since we added last value first in recursion
			Collections.reverse(subset);
			return subset;
		}
		return null;
	}

	public void findAndPrintSubset(int sum) {
		ArrayList<Integer> res = findSubset(sum);
		if (res == null)
			System.out.println("No solve found");
		else
			for (int i : res)
				System.out.print(i + " ");
	}

	private boolean backtrack(int index, int currentSum) {
		if (sum == currentSum)
			return true;
		if (sum < currentSum)
			return false;

		for (int i = index; i < set.size(); i++) {
			if (backtrack(i + 1, currentSum + set.get(i))) {
				// If current combination returns true,
				// then add it to subset
				subset.add(set.get(i));
				return true;
			}
		}
		// If no combination in this call generates desired sum
		// the return false
		return false;
	}

	public static void main(String[] args) {
		ArrayList<Integer> list = new ArrayList<>(Arrays.asList(1, 3, 4, 5, 6, 7));
		new SubsetSum(list).findAndPrintSubset(22);
	}
}
