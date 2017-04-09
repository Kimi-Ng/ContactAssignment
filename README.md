# Contact Assignment
## Introduction
This project solves a contact relation problem. It tries to group all related contacts togeter.<br/>
Two contacts are defined related if the name or telephone are directly equal or indirectly equal to another contacts.

E.g.. <br/>
For (A, 123), (B, 456), (C, 123), (D, 789), (E, 789) <br/>
we would generate two groups,<br/>
group1: (A, 123), (B, 456), (C, 123) and group2:(D, 789), (E, 789)

The solution logic in implemented in ViewController.m.<br/>
First taken name and telephone number as vertex and build a Graph data structure.<br/>
Then traverse the graph we could get several trees which represent the contact groups, and which are the result we wanted.<br>
The final things are represent the data to the required output display format.

## Input file
Input file should be named "input.txt" and put in the path "Supporting Files/input.txt"<br/>
Input file format: each line contains non-empty string pairs separated by space or comma

E.g..<br/>
Jack 123<br/>
Jack 456<br/>
Bill, 678<br/>

## Output
Output would display in two ways simultaneously:<br/>
1) directly output in the console<br/>
2) display in iphone device or simulator<br/>
