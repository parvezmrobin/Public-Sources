package term22;

import java.util.ArrayList;

public class JobSequencing {
	
	public static String[] JobSequence(
			ArrayList<String> jobs, 		//Name of jobs to be done
			ArrayList<Integer> deadLines,	//Deadline of jobs 
			ArrayList<Integer> weights,		//Weight/Priority of jobs
			int totalSlot) {				//Number of jobs can be done
		
		String[] slot = new String[totalSlot];
		int jobIncluded = 0;				//Initially no jobs are scheduled
		while (jobIncluded < totalSlot) {	//While there are slots for more job
			int maxWeightIndex = 0;			//Find the job with highest weight
			for (int i = 0; i < weights.size(); i++) {
				if (weights.get(i) > weights.get(maxWeightIndex))
					maxWeightIndex = i;
			}
			
			boolean isIncluded = false;
			for (int i = deadLines.get(maxWeightIndex); i > 0; i--) {
				if (slot[i - 1] == null) {	//If a slot is free within its deadline
					isIncluded = true;
					slot[i - 1] = jobs.get(maxWeightIndex);
					break;
				}
			}
			jobs.remove(maxWeightIndex);	//Remove the job from the lists
			deadLines.remove(maxWeightIndex);
			weights.remove(maxWeightIndex);

			if (jobs.size() == 0)			//If there are no more job
				break;
			
			if (isIncluded)
				jobIncluded++;
		}
		return slot;
	}
	/**
	 * @category Sample Test case
	 */
	public static void main(String[] args) {
		ArrayList<String> jobs = new ArrayList<>();
		jobs.add("1");
		jobs.add("2");
		jobs.add("3");
		jobs.add("4");
		jobs.add("5");
		jobs.add("6");
		jobs.add("7");

		// 4 2 4 3 1 4 6
		ArrayList<Integer> deadLines = new ArrayList<>();
		deadLines.add(4);
		deadLines.add(2);
		deadLines.add(4);
		deadLines.add(3);
		deadLines.add(1);
		deadLines.add(4);
		deadLines.add(6);

		// 70 60 50 40 30 20 10
		ArrayList<Integer> weights = new ArrayList<>();
		weights.add(70);
		weights.add(60);
		weights.add(50);
		weights.add(40);
		weights.add(30);
		weights.add(20);
		weights.add(20);
		weights.add(10);

		String[] res = JobSequence(jobs, deadLines, weights, 7);
		for (String str : res)
			if (str != null)
				System.out.print(str + ' ');
	}
}
