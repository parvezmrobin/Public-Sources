package term22;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;

public class Sorting {
	@SuppressWarnings("unchecked")
	public static File divide(File inFile) throws FileNotFoundException, IOException, ClassNotFoundException {
		FileInputStream inputStream = new FileInputStream(inFile);
		ObjectInputStream objectInputStream = new ObjectInputStream(inputStream);
		ArrayList<Integer> a = (ArrayList<Integer>) objectInputStream.readObject();
		objectInputStream.close();

		if (a.size() == 1)
			return inFile;
		int mid = a.size() / 2;
		ArrayList<Integer> a1 = new ArrayList<>();
		ArrayList<Integer> a2 = new ArrayList<>();
		for (int i = 0; i < mid; i++)
			a1.add(a.get(i));
		for (int i = mid; i < a.size(); i++)
			a2.add(a.get(i));

		File outFile1 = new File(1 + inFile.getName());
		File outFile2 = new File(2 + inFile.getName());
		ObjectOutputStream outputStream = new ObjectOutputStream(new FileOutputStream(outFile1));
		outputStream.writeObject(a1);
		outputStream.close();
		outputStream = new ObjectOutputStream(new FileOutputStream(outFile2));
		outputStream.writeObject(a2);
		outputStream.close();

		return merge(divide(outFile1), divide(outFile2));
	}

	@SuppressWarnings("unchecked")
	private static File merge(File inFile1, File inFile2)
			throws FileNotFoundException, IOException, ClassNotFoundException {
		ArrayList<Integer> a1, a2;
		ObjectInputStream stream = new ObjectInputStream(new FileInputStream(inFile1));
		a1 = (ArrayList<Integer>) stream.readObject();
		stream.close();
		stream = new ObjectInputStream(new FileInputStream(inFile2));
		a2 = (ArrayList<Integer>) stream.readObject();
		stream.close();

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

		File outFile = new File(0 + inFile1.getName().substring(1));
		ObjectOutputStream stream2 = new ObjectOutputStream(new FileOutputStream(outFile));
		stream2.writeObject(a);
		stream2.close();
		return outFile;
	}

	@SuppressWarnings("unchecked")
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
		File file = new File("file.obj");
		try {
			ObjectOutputStream stream = new ObjectOutputStream(new FileOutputStream(file.getName()));
			stream.writeObject(a);
			stream.close();
			ObjectInputStream stream2 = new ObjectInputStream(new FileInputStream(divide(file)));
			a = (ArrayList<Integer>) stream2.readObject();
			stream2.close();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(a);
	}
}
