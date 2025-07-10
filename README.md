# Uber Demand-Supply Gap Analysis

This project performs an Exploratory Data Analysis (EDA) on Uber request data to identify the root causes of the demand-supply gap, specifically for trips between the city and the airport. The goal is to pinpoint key problem areas and provide data-driven recommendations to improve service reliability and customer satisfaction.

## Problem Statement

Uber is experiencing a high number of unfulfilled ride requests, resulting in poor customer experience and potential revenue loss. The core business problem is to identify:
1.  When are the demand-supply gaps most significant?
2.  Which locations (City or Airport) are most affected?
3.  What is the nature of the gap (i.e., are drivers cancelling trips, or are there simply no cars available)?
4.  Provide actionable recommendations to help Uber bridge these gaps.

## Dataset

The analysis is based on the `Uber Request Data.csv` file, which contains details for over 6,000 requests. Key columns include:
*   `Request id`
*   `Pickup point` (Airport or City)
*   `Driver id`
*   `Status` (Trip Completed, Cancelled, No Cars Available)
*   `Request timestamp`

## Key Findings & Analysis

The analysis revealed that **approximately 60% of all ride requests are not completed**, indicating a significant service issue. The problems are concentrated during two specific peak periods.

### Gap 1: The Morning Cancellation Problem
*   **What:** A high volume of **"Cancelled"** trips.
*   **When:** During the morning rush hour, between **5 AM and 9 AM**.
*   **Where:** Primarily for trips originating from the **City** to the airport.
*   **Analysis:** This represents a **supply-side issue**. Drivers are available but are unwilling to accept airport trips, likely due to the low probability of securing a return fare from the airport during those hours. They prefer to cancel and take more profitable local rides within the city.

*(You can add your chart image here!)*
`![Morning Cancellations Chart](path/to/your/image.png)`

### Gap 2: The Evening Supply Shortage
*   **What:** A severe shortage of cars, reflected by the **"No Cars Available"** status.
*   **When:** During the evening peak, from **5 PM to 10 PM**.
*   **Where:** Almost exclusively for trips originating from the **Airport** to the city.
*   **Analysis:** This is a classic **demand-side issue**. The evening sees a surge in demand from arriving flights, but there aren't enough drivers at the airport to meet it. This creates a supply deficit.

*(You can add your chart image here!)*
`![Evening Shortage Chart](path/to/your/image.png)`

### Summary of Gaps

| Time of Day           | Pickup Point | Dominant Problem         | Root Cause                                     |
| --------------------- | ------------ | ------------------------ | ---------------------------------------------  |
| **Morning (5-9 AM)**  | City         | **High Cancellations**   | Drivers are available but unwilling to travel. |
| **Evening (5-10 PM)** | Airport      | **No Cars Available**    | Insufficient cars to meet passenger demand.    |

## Data-Driven Recommendations

Based on the findings, the following recommendations are proposed:

#### To solve the Morning Cancellation Problem (City → Airport):
1.  **Incentivize Airport Trips:** Offer a "Morning Airport Bonus" for drivers completing trips to the airport during peak morning hours.
2.  **Ensure Return Fares:** Show drivers potential follow-up fares from the airport to reduce their financial uncertainty.
3.  **Stricter Cancellation Penalties:** Implement higher penalties for drivers who frequently cancel airport-bound trips in the morning.

#### To solve the Evening "No Cars Available" Problem (Airport → City):
1.  **Implement Surge Pricing:** Increase surge pricing at the airport during the evening peak to attract more drivers.
2.  **Schedule Airport Fleet:** Notify drivers ahead of the evening rush to position themselves near the airport.
3.  **Offer Paid Wait Times:** Provide a nominal fee for drivers waiting in the airport queue to ensure a ready supply of cars.

## Technical Stack
*   **Language:** Python
*   **Libraries:** Pandas, Matplotlib, Seaborn
*   **Environment:** Jupyter Notebook

## How to Run This Project
1.  Clone the repository:
    ```bash
    git clone https://github.com/ompatilonmail/Uber-Demand-Supply-Gap-EDA.git
    ```
2.  Navigate to the project directory:
    ```bash
    cd Uber-Demand-Supply-Gap-EDA
    ```
3.  Open the `Uber_Supply_Demand_Gap.ipynb` file in Jupyter Notebook to view the code and analysis.
