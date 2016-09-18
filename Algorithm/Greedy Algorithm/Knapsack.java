package term22;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Scanner;

class Element {
	private int weight, profit;

	public Element(int weight, int profit) {
		this.weight = weight;
		this.profit = profit;
	}

	public int getWeight() {
		return weight;
	}

	public void setWeight(int weight) {
		this.weight = weight;
	}

	public int getProfit() {
		return profit;
	}

	public void setProfit(int profit) {
		this.profit = profit;
	}

	public String toString() {
		return "Weight : " + weight + ", Profit : " + profit;
	}
}

public class Knapsack {

	private ArrayList<Element> elements;
	private int bagSize;

	public Knapsack(ArrayList<Element> elements, int bagSize) {
		this.bagSize = bagSize;
		this.elements = elements;
	}

	public Knapsack(int bagSize) {
		elements = new ArrayList<>();
		this.bagSize = bagSize;
	}

	public void addElement(Element element) {
		elements.add(element);
	}

	public ArrayList<Element> calculate() {
		elements.sort(new Comparator<Element>() {
			public int compare(Element arg0, Element arg1) {
				return arg0.getProfit() - arg1.getProfit();
			}
		});
		ArrayList<Element> bag = new ArrayList<>();
		int freeSpace = bagSize;
		for (Element e : elements) {
			if (e.getWeight() <= freeSpace) {
				bag.add(e);
				freeSpace -= e.getWeight();
			}
			if (freeSpace <= 0)
				break;
		}

		return bag;
	}

	public static void main(String[] args) {
		Scanner scanner = new Scanner(System.in);
		int weight = scanner.nextInt();
		int number = scanner.nextInt();
		ArrayList<Element> elements = new ArrayList<>(number);
		for (int i = 0; i < number; i++) {
			int w = scanner.nextInt();
			int p = scanner.nextInt();
			elements.add(new Element(w, p));
		}
		scanner.close();
		ArrayList<Element> res = new Knapsack(elements, weight).calculate();

		for (Element e : res) {
			System.out.println(e);
		}
	}
}
