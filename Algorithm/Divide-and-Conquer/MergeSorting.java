package term22;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;

class MergeSort {
	
	public static ArrayList<Integer> divide(ArrayList<Integer> a) {
		if (a.size() == 1)
			return inFile;
		int mid = a.size() / 2;
		ArrayList<Integer> a1 = new ArrayList<>();
		ArrayList<Integer> a2 = new ArrayList<>();
		for (int i = 0; i < mid; i++)
			a1.add(a.get(i));
		for (int i = mid; i < a.size(); i++)
			a2.add(a.get(i));

		return merge(divide(a1), divide(a2));
	}

	private static ArrayList<Integer> merge(ArrayList<Integer> a1, ArrayList<Integer> a2){
		ArrayList<Integer> a = new ArrayList<>(a1.size() + a2.size());
		int i = 0, j = 0;
		while (i < a1.size() && j < a2.size()) {
			if (a1.get(i) < a2.get(j))
				a.add(a1.get(i++));
			else
				a.add(a2.get(j++));
		}

		if (i == a1.size()) {
			while (j < a2.size())
				a.add(a2.get(j++));
		} else {
			while (i < a1.size())
				a.add(a1.get(i++));
		}
		
		return a;
	}
}
public class MergeSorting{
	//Sample Test Case
	public static void main(String[] args) {
		ArrayList<Integer> a = new ArrayList<>();
		a.add(9);
		a.add(7);
		a.add(5);
		a.add(3);
		a.add(1);
		a.add(0);
		a.add(2);
		a.add(4);
		a.add(6);
		a.add(8);
		
		a = MergeSort.divide(a);
		
		System.out.println(a);
	}
}
