create database Hosp_Proj;
Use Hosp_Proj;

## TOTAL REVENUE
SELECT 
    SUM(revenue_realized)
FROM
    fact_bookings; -- '1708771229'

## TOTAL CAPACITY
SELECT 
    SUM(capacity)
FROM
    fact_aggregated_bookings;-- '232576'


## TOTAL BOOKINGS 
SELECT 
    COUNT(booking_id)
FROM
    fact_bookings;-- '134590'


## OCCUPANCY RATE
SELECT 
    IFNULL(SUM(successful_bookings) / NULLIF(SUM(capacity), 0),
            0) * 100 AS OccRate
FROM
    fact_aggregated_bookings;-- 57.86 %


## TOTAL CANCELLED
SELECT 
    COUNT(*)
FROM
    fact_bookings
WHERE
    booking_status = 'cancelled';-- '33420'


## CANCELLED %
SELECT 
    IFNULL(COUNT(CASE
                WHEN booking_status = 'Cancelled' THEN 1
            END) / NULLIF(COUNT(*), 0),
            0) * 100 CanRate
FROM
    fact_bookings;-- 24.83 %


## TOTAL CHECKOUT
SELECT 
    COUNT(*)
FROM fact_bookings WHERE
    booking_status = 'Checked Out';-- '94411'


## CHECK OUT %
SELECT 
    IFNULL(COUNT(CASE
                WHEN booking_status = 'Checked Out' THEN 1
            END) / NULLIF(COUNT(*), 0),
            0) * 100 CanRate
FROM
    fact_bookings;-- 70.14 %


## TOTAL NO SHOW
SELECT 
    COUNT(*)
FROM
    fact_bookings
WHERE
    booking_status = 'No Show';-- 6759


## NO SHOW %
SELECT 
    IFNULL(COUNT(CASE
                WHEN booking_status = 'No Show' THEN 1
            END) / NULLIF(COUNT(*), 0),
            0) * 100 CanRate
FROM
    fact_bookings; -- 5.02 %



## Trend Analysis 
SELECT 
    dim_hotels.city,
    SUM(fact_bookings.revenue_generated) AS RevenueGenerated,
    SUM(fact_bookings.revenue_realized) AS RevenueRealized
FROM
    dim_hotels
        JOIN
    fact_bookings ON dim_hotels.property_id = fact_bookings.property_id
GROUP BY dim_hotels.city;

## Weekday  & Weekend  Revenue and Booking   
SELECT 
    dim_date.day_type,
    SUM(fact_bookings.revenue_realized) AS TotalRevenue,
    COUNT(fact_bookings.booking_id) AS TotalBookings
FROM
    dim_date
        JOIN
    fact_bookings ON fact_bookings.check_in_date
GROUP BY dim_date.day_type;

## Revenue by State & hotel
SELECT 
    dim_hotels.city,
    dim_hotels.property_name AS PropertyNames,
    SUM(fact_bookings.revenue_realized) AS TotalRevenue
FROM
    fact_bookings
        JOIN
    dim_hotels ON fact_bookings.property_id = dim_hotels.property_id
GROUP BY dim_hotels.city , dim_hotels.property_name
ORDER BY TotalRevenue DESC;


## Class Wise Revenue
SELECT 
    dim_rooms.room_class AS RoomClass,
    SUM(fact_bookings.revenue_realized) AS TotalRevenue
FROM
    dim_rooms
        JOIN
    fact_bookings ON dim_rooms.room_id = fact_bookings.room_category
GROUP BY dim_rooms.room_class;

## Checked out cancel No show
SELECT 
    booking_status, COUNT(*) AS BookingStatusCount
FROM
    fact_bookings
WHERE
    booking_status IN ('Checked Out' , 'Cancelled', 'No Show')
GROUP BY booking_status;

## Weekly trend Key trend (Revenue, Total booking, Occupancy) 
SELECT 
    DIM_DATE.`WEEK NO`,
    SUM(FACT_BOOKINGS.REVENUE_REALIZED) AS `Total Revenue`,
    COUNT(FACT_BOOKINGS.BOOKING_ID) AS `Total Bookings`
FROM
    DIM_DATE
        JOIN
    FACT_BOOKINGS ON DIM_DATE.DATE = FACT_BOOKINGS.CHECK_IN_DATE
GROUP BY DIM_DATE.`WEEK NO`;