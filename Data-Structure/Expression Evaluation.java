import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.Stack;

public class ExpressionEvaluator {
	public static void main(String[] args) {
		System.out.println(new ExpressionEvaluator("5+24/4*(5-3)").EvaluatePostFix());
	}

	private String expression;

	public ExpressionEvaluator(String expression) {
		this.expression = expression;
	}

	private ArrayList<Object> GeneratePostFix() throws IllegalArgumentException {
		int a = -1;
		Stack<Character> stack = new Stack<>();
		ArrayList<Object> postfix = new ArrayList<>();
		for (int i = 0; i < expression.length(); i++) {
			char ch = expression.charAt(i);
			if (Character.isDigit(ch) || ch == '.') {
				if (a == -1) {
					a = i;
				}

			} else {
				if (a != -1) {
					postfix.add(Double.parseDouble(expression.substring(a, i)));
					a = -1;
				}

				if (ch == '(')
					stack.push(ch);
				else if (ch == '/')
					stack.push(ch);
				else if (ch == '*') {
					while ((stack.peek() == '/') && !stack.isEmpty())
						postfix.add(stack.pop());
					stack.push(ch);
				} else if (ch == '+' || ch == '-') {
					while (!stack.empty() && (stack.peek() == '*' || stack.peek() == '/')) {
						postfix.add(stack.pop());
					}
					stack.push(ch);
				} else if (ch == ')') {
					try {
						while (stack.peek() != '(') {
							postfix.add(stack.pop());
						}
					} catch (EmptyStackException e) {
						throw new IllegalArgumentException("No opening parenthesis found.");
					}
					stack.pop();
				} else if (ch != ' ') {
					throw new IllegalArgumentException(ch + " is not a valid argument.");
				}
			}

		}

		while (!stack.empty()) {
			postfix.add(stack.pop());
		}

		return postfix;
	}

	public double EvaluatePostFix() throws IllegalArgumentException {
		ArrayList<Object> postfix = GeneratePostFix();
		Stack<Double> stack = new Stack<>();

		for (Object obj : postfix) {
			if (obj instanceof Double)
				stack.push((double) obj);
			else if (obj instanceof Character) {
				double b;
				double a;
				try {
					b = stack.pop();
					a = stack.pop();
				} catch (EmptyStackException e) {
					throw new IllegalArgumentException("Invalid operand for operator '" + obj + "'.");
				}

				switch ((char) obj) {
				case '+':
					stack.push(a + b);
					break;
				case '-':
					stack.push(a - b);
					break;
				case '*':
					stack.push(a * b);
					break;
				case '/':
					stack.push(a / b);
					break;
				default:
					break;
				}
			}
		}
		if (stack.size() > 1)
			throw new IllegalArgumentException("Too many operand found.");
		return stack.pop();
	}

}
