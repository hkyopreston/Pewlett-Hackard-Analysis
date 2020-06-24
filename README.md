# Pewlett-Hackard-Analysis
### Module 7 Challenge



There are many employees at Pewlett Hackard that are ready or will soon be ready to retire. Instead of losing a large portion of its workforce at one time, Pewlett Hackard is also trying to implement a mentorship program for people who want to work part time before they retire completely. I am using data analysis to provide more insight as to which employees will be retiring and which will be eligible for the mentorship program. More specifically, I will answering the follwing questions: 
  1. How many employees are of retirement age?
  
  2. How many job titles have employees who are eligible for retirement?
  
  4. Which employees are eligible for the Mentorship Program?

First and foremost, Pewlett Hackard csv files had to be analyzed and cleaned. Part of the analysis was created an ERD diagram that plotted the relationship between each file. See below for the Employee DataBase ERD: 

<img src ="https://github.com/hkyopreston/Pewlett-Hackard-Analysis/blob/master/EmployeeDB.png?raw=true"></img>

This ERD formed the basis for a more in depth SQL analysis. Based on the relationships in this ERD, tables were created within Postgre SQL for each csv file. The raw csv data was then imported into each table. One challenge here was importing the csv files using a Mac computer. I was not able to import files using the export/import toggle button, but instead had to write code in order to upload each file to the proper table. Here is an example of the code used to import a csv file in PostgreSQL: 

#### COPY departments FROM '/Users/harrisonpreston/Public/departments.csv' DELIMITER ',' CSV HEADER;

Because Mac computer have permission locks, I had to give SQL a direct path to my csv files. 

After loading data, it was time to write queries in order to answer the 3 questions listed above. These consisted of the following attributes/commands:

  1. SELECT command to retrieve columns from previously created tables.
  
  2. INTO command to create a new table based on the tables/columns selected.
  
  3. WHERE function to find birth dates between Jan 1, 1952 and Dec 31, 1965.
  
  4. INNER JOIN to join multiple tables together into a new table.
  
  5. GROUP BY function to group data based on job titles. 
  
  6. PARTITION BY function in order to remove duplicate employees from the data. 
  
  6. COUNT function in order to count the number of titles that would be retiring and the number of employees retiring from each department. 

After Conduction my Analysis, here are my results. Each answer is in order of the analysis questions above. 

  1. 90,398 employees were born between Jan 1, 1952 and Dec 31, 1965. Hewlett Packard has deemed these employees as 'retirement age.'
  
  2. There are 7 job titles that have retiring employees. The titles and number of employees are as follows:  
      - Engineer: 14,221
      - Senior Engineer: 29,415
      - Manager: 2
      - Assistant Engineer: 1,761
      - Staff: 12,243
      - Senior Staff: 28,254
      - Technique Leader: 4,502
    
  3. There are only 6 job titles that have employees who are eligible for Mentorship. The titles and number of employees are as follow: 
      - Engineer: 286
      - Senior Engineer: 610
      - Assistant Engineer: 41
      - Staff: 271
      - Senior Staff: 633
      - Technique Leader: 99
  
A major limitation of this analysis is that not everyone who is of retirement age will actually retire. In order to get an accurate count, the data would need to include survey on whether or not eligible employees will retire. It appears that many high level and technical positions will be in contention for retirement. Of those employees, a small percentage are eligible to be mentors. It seems like Hewlett Packard may need to expand mentorship criteria in order to transition lower level employees into more senior roles. 
      

