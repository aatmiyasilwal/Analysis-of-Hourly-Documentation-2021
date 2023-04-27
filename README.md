<h1> Hourly Documentation 2021 </h1>

This project makes use of my **personal tracker** that I used to track every single hour of my 2021 as the source dataset. In the dataset, numbers ranging from 1 through 1 to 25 represent the activities I did within that particular hour. For the index, please refer to the "CounterSheet" sheet of the Hourly Documentation 2021.xlsx spreadsheet.

Beyond the dataset, the project uses R's Random Forest Library to make predictions on how my activities would change based on differing control variables (like day, season, and month). It also highlights the variables that brought the biggest changes to my daily schedule by using Mean Decrease Gini as the metric. Finally, it checks to see how the OOB error value for different variables changes upon increasing the number of trees used.
