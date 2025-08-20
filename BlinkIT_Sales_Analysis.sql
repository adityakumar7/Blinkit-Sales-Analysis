--Show entire data set :

Select * from BlinkIT_Data;

--check irregularities in the coloumn Item_Fat_Content :

Select distinct Item_Fat_Content from BlinkIT_Data;

--Clean the irregularities in the coloumn Item_Fat_Content by Replacing the values :

Update 
	BlinkIT_Data
Set 
	Item_Fat_Content =
Case
	When Item_Fat_Content in ('LF','low fat') Then 'Low Fat'
	When Item_Fat_Content = 'reg' Then 'Regular'
	Else Item_Fat_Content
END;

								--KPI's Requirements 

--Calculate the Total Sales and show the amount in millions :

Select 
	CAST(SUM(Total_Sales)/1000000 As decimal(10, 2))  AS Total_Sales_Millions 
from 
	BlinkIT_Data;

--Calculate the Average sales :

Select 
	CAST(AVG(Total_Sales) As INT) As Average_Sales 
from 
	BlinkIT_Data;

--Calculate the Average Rating :

Select 
	CAST(AVG(Rating) As INT) As Average_Raing 
from 
	BlinkIT_Data;

								--Granular Requirements

--Calculate Total Sales by Fat Content :

Select 
	Item_Fat_Content, CAST(SUM(Total_Sales) As Decimal(10,2)) As Sales_by_Fat 
from 
	BlinkIT_Data 
Group by 
	Item_Fat_Content;

--Calculate Total Sales by Item Type and sort by sales :

Select 
	Item_Type, CAST(SUM(Total_Sales) As Decimal(10,2)) As Sales_By_Type 
from 
	BlinkIT_Data 
Group by 
	Item_Type
Order by 
	Sales_By_Type desc ;

--Calculate total sales across different outlets segmented by fat content :

Select 
	Outlet_Location_Type, ISNULL([Low Fat], 0) As Low_Fat, ISNULL([Regular], 0) As Regular
from 
	(
		Select
			Outlet_Location_type, Item_Fat_Content, CAST(SUM(Total_Sales)As Decimal(10,2)) AS Total_Sales 
		from
			BlinkIT_Data
		Group by
			Outlet_Location_type, Item_Fat_Content
	) As Source_Table
PIVOT
	(
		SUM(Total_Sales) For Item_Fat_Content IN ([Low Fat], [Regular])
	) As Pivot_Table
Order by
	Outlet_Location_type;

--Calculate total sales by Outlet_Establishment_Year :

Select 
	Outlet_Establishment_Year, CAST(SUM(Total_Sales) As Decimal(10,2)) As Sales_By_Establishment
from 
	BlinkIT_Data 
Group by 
	Outlet_Establishment_Year
Order by 
	Outlet_Establishment_Year;

									--Visualization Requirements

--Calculate Percentage of Sales by Outlet_Size :

Select 
	Outlet_Size, CAST(SUM(Total_Sales) As Decimal(10,2)) As Total_Sales,
	CAST((SUM(Total_Sales) * 100 / SUM(SUM(Total_Sales)) OVER()) As Decimal(10,2)) As Sales_Percentage
from 
	BlinkIT_Data
Group by
	Outlet_Size
Order By
	Total_Sales;

--Calculate Sales by Outlet_Location_Type :

Select 
	Outlet_Location_Type, CAST(SUM(Total_Sales) As Decimal(10,2)) As Sales_By_Location
from 
	BlinkIT_Data
Group by
	Outlet_Location_Type
Order by 
	Sales_By_Location Desc;

--Calculate All metrices by Outlet_Type :

Select 
	Outlet_Type, CAST(SUM(Total_Sales) As Decimal(10,2)) As Total_Sales,
	CAST(AVG(Total_Sales) As Decimal(10,2)) As Average_Sales,
	CAST(AVG(Rating) As Decimal(10,2)) As Average_Rating,
	CAST(AVG(Item_Visibility) As Decimal(10,2)) As Average_ItemVisibility,
	Count(*) As Total_Items
from 
	BlinkIT_Data
Group by
	Outlet_Type
Order by
	Total_Sales Desc;