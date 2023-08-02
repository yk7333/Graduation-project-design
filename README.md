# Research on Multi-UAV Collaborative Task Allocation Method Based on Artificial Immune Algorithm

Authored by: Kai Yang from Class 84 of Automation, Xi'an Jiaotong University

## Files Overview
- `UAV.xlsl`: Parameters of the Unmanned Aerial Vehicles (UAVs)
- `Target.xlsx`: Parameters of the task targets
- `result.xlsm`: Data utilized in the paper

## Single-Objective Scenario:

- `main`: Single-objective SIA (Substitute `&&` with `#&&` on lines 55, 69, 83, and 98 for single-objective IA)
- `InitialSolution`: Antibody decoding into initial solution
- `ModifiedSolution`: Initial solution transformation into a modified solution
- `Graph`: Returns adjacency matrix based on the task matrix
- `DFS`: Depth-First Search algorithm, returns deadlock cycle
- `Lock`: Returns deadlock count matrix in the form of an adjacency matrix
- `Unlock`: Function to remove deadlock
- `Get_mission`: Obtain task assignment matrix after antibody decoding and modification
- `CostRoad`: Calculate flight path cost
- `CostBias`: Calculate bias cost
- `Reward`: Calculate task reward
- `Cost`: Calculate antibody's target cost
- `similar`: Compute similarity between two antibodies
- `concentration`: Calculate antibody concentration
- `fitness`: Compute antibody fitness
- `bestselect`: Store excellent antibodies into memory
- `select`: Select antibodies for reproduction based on roulette wheel selection
- `mutate`: Mutation
- `cross`: Crossover
- `reverse`: Reverse
- `exchange`: Exchange
- `Test`: Check if antibody values are valid
- `Affinity_old`: Returns the average affinity of the first 50 iterations

## Multi-objective Scenario:

- `main_bias`: Minimum bias sub-problem solution
- `main_road`: Minimum flight path sub-problem solution
- `main_reward`: Maximum reward sub-problem solution (PS. Save antibody groups solved by the above three algorithms and import into `Pareto_main`, comment out the random initialization code)
- `Pareto_main`: Multi-objective SIA (Substitute `&&` with `#&&` on lines 74, 104, and 135 for multi-objective IA)
- `Cost_Road`: Multi-objective flight path cost
- `Cost_Bias`: Multi-objective time deviation
- `Cost_Reward`: Multi-objective task reward
- `Cost_new`: Multi-objective problem's cost function
- `FreshPareto`: Update Pareto optimal solution set
- `Affinity_new`: Calculate multi-objective task affinity

## Other Files (Unused in this project):

- `PSO`: Particle Swarm Optimization (PSO) for solving MTAP
- `Time_array`: Returns the time matrix of arriving at specific task locations
- `Active`: Local redistribution algorithm when new targets appear, based on Zhang's paper
- `New_target.xlsx`: Newly found temporary task targets
- `Draw`: Gantt chart drawing script (rudimentary)

**Note**: There might be occasional unknown errors during the execution of the code, simply re-run the code if encountered.
