/* 
	Hello!
	Below are queries to 8 exercises.
	I created the tables first to use IntelliSense in SSMS.

	============================
	 Author: Cory McKee
	 Date Created: 7/25/2021
	============================
*/

-- Reference Database
use practice

-- Create Tables
CREATE TABLE Member 
   (MemberID int PRIMARY KEY,
    FirstName varchar(255),
    LastName varchar(255),
	EmployeeID varchar(255),
    DateOfBirth datetime,
    DateOfHire datetime);

CREATE TABLE MemberAddress 
   (Address1 varchar(255),
    Address2 varchar(255),
    City varchar(255),
	State varchar(255),
    Zipcode int,
    Zip4 int,
	MemberID int);

CREATE TABLE MemberPlan 
   (GroupNumber varchar(255),
    StartDate datetime,
    MemberID int,
	WhoIsCovered varchar(255),
    EndDate datetime);

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 1
-- Create a file of members based on last names between “N” and “Z” who have plans that begin as of 1/1/2017. Include full addresses.
select
	  M.MemberID
	, M.FirstName + ' ' + M.LastName as [Member Name]
	, MA.Address1 + ' ' + MA.Address2 + ' ' + MA.City + ', ' + MA.[State] + ' ' + cast(MA.Zipcode as varchar) + '-' + cast(MA.Zip4 as varchar) as [Member Full Address]
from Practice.dbo.Member M (nolock)
join Practice.dbo.MemberAddress MA (nolock) on M.MemberID = MA.MemberID
join Practice.dbo.MemberPlan MP (nolock) on M.MemberID = MP.MemberID
where M.LastName like '[N-Z]%'
and cast(MP.StartDate as date) >= '1-1-2017'

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 2
-- Create a file of members in group number ABC123 who are between 25 and 35 years as of the start date of their plan.
select
	  M.MemberID
	, M.FirstName + ' ' + M.LastName as [Member Name]
	, MP.GroupNumber
from Practice.dbo.Member M (nolock)
join Practice.dbo.MemberPlan MP (nolock) on M.MemberID = MP.MemberID
where MP.GroupNumber in ('ABC123')
and cast(MP.StartDate as date) between cast(dateadd(year, -35, getdate()) as date) and cast(dateadd(year, -25, getdate()) as date)

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 3
-- Create a full address file of everyone in MD and DE.
select
	  MA.MemberID
	, MA.Address1 + ' ' + MA.Address2 + ' ' + MA.City + ', ' + MA.[State] + ' ' + MA.Zipcode + '-' + MA.Zip4 as [Member Full Address]
from Practice.dbo.MemberAddress MA (nolock)
where MA.[State] in ('MD','DE')

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 4
-- Create a file of members who started plans between 1/1/2016 and 1/1/2017 regardless of plan.
select
	  M.MemberID
	, M.FirstName + ' ' + M.LastName as [Member Name]
	, MP.GroupNumber
	, MP.StartDate
from Practice.dbo.Member M (nolock)
join Practice.dbo.MemberPlan MP (nolock) on M.MemberID = MP.MemberID
where cast(MP.StartDate as date) between '1-1-2016' and '1-1-2017'

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 5
-- Create a file of members who were hired after 12/1/2015 who have never had a plan.
select
	  M.*
from Practice.dbo.Member M (nolock)
left join Practice.dbo.MemberPlan MP (nolock) on M.MemberID = MP.MemberID -- Conditons on the Join Filter the Search
where cast(M.DateOfHire as date) > '12/1/2015'
and MP.MemberID is null -- Conditions in the where filter the results; This can also be completed with an Outer Apply or a Left Outer Join

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 6
-- Create a file of employee ID’s who enrolled in a plan for the first time in 2017.
select
	  M.EmployeeID
from Practice.dbo.Member M (nolock)
join (select row_number() over(partition by T.MemberID order by T.StartDate) nn, * from Practice.dbo.MemberPlan T (nolock)) MP on M.MemberID = MP.MemberID and MP.nn=1
where year(MP.StartDate) = '2017'

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 7
-- Create a file of employees who had the plan in 2015, dropped it in 2016, but picked it back up for 2017.
-- I am making the assumption that GroupNumber is the what would be considered as 'The Plan'
select
	  M.MemberID
	, M.FirstName + ' ' + M.LastName as [Member Name]
from Practice.dbo.Member M (nolock)
left join Practice.dbo.MemberPlan MP1 (nolock) on M.MemberID = MP1.MemberID and year(MP1.StartDate) = '2015' and year(MP1.EndDate) = '2016'
left join Practice.dbo.MemberPlan MP2 (nolock) on M.MemberID = MP2.MemberID and year(MP2.StartDate) = '2017'
where MP1.GroupNumber = MP2.GroupNumber

--/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-- Exercise 8
-- Create a full file containing all information in all 3 tables.
select
	  M.*
	, MA.*
	, MP.*
from Practice.dbo.Member M (nolock)
full outer join Practice.dbo.MemberAddress MA (nolock) on M.MemberID = MA.MemberID
full outer join Practice.dbo.MemberPlan MP (nolock) on M.MemberID = MP.MemberID



