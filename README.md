# Julia Installation and dependencies

This repository contains Julia and Python scripts for processing RPC RTT log files and plotting them.
It imports a file containing the Round-trip times, parses them and removes the noisy data. They can be modified to create different plots.  

## Python Script:
1. Install Python3 with the following packages:
	- matplotlib
	- statsmodels
	- numpy
2. Usage:  
`python3 script.py <file1> <file2> start_from_line  num_of_lines_to_read`
**It can be used to compare two different log files**

## Julia Script

1. install Julia:  
`sudo apt install julia`

2. install python2-dev

3. install python-gi-cairo

4. install pip and matplotlib

5. install zlib1g-dev

6. Install the following julia packages:
    - DataFrames
    - GZip
    - PyPlot
    - PyCall
7. Usage:  
`julia percentile.jl <file_name>`
**Modify the parameters that are hard-coded in the file as neccessary**  
