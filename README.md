# COVID-19 Data Exploration Project

## 📋 Project Overview
A comprehensive SQL-based data analysis project exploring global COVID-19 statistics, vaccination progress, and pandemic impact across countries and continents. This analysis transforms raw pandemic data into meaningful insights using advanced SQL techniques.

## 🎯 Objectives
- Analyze COVID-19 infection rates, mortality statistics, and vaccination progress worldwide
- Identify countries with highest infection and death rates
- Track vaccination rollout effectiveness using rolling calculations
- Provide clean, analysis-ready datasets for visualization

## 📊 Key Analyses Performed

### 🔍 Infection & Mortality Analysis
- **Case Fatality Rates**: Likelihood of dying after contracting COVID-19 by country
- **Population Infection Percentage**: What percentage of each country's population was infected
- **Global Death Trends**: Daily death percentages and mortality patterns

### 🌍 Geographical Insights
- **Country Performance**: Top 10 countries by infection rates relative to population
- **Continental Breakdown**: Death counts aggregated by continent
- **Regional Comparisons**: Side-by-side analysis of different geographical responses

### 💉 Vaccination Progress
- **Rolling Vaccination Counts**: Daily cumulative vaccination numbers per country
- **Vaccination Coverage**: Percentage of population vaccinated over time
- **Vaccination Efficiency**: Pace of vaccination rollout across different nations

## 🛠 Technical Implementation

### Data Processing
- **Data Type Conversion**: Fixed date formats from text to proper DATE types
- **Data Quality**: Handled missing values and inconsistent data entries
- **Data Validation**: Ensured data integrity through careful filtering

### SQL Techniques Used
- **Advanced Joins**: Combined death and vaccination datasets
- **Window Functions**: Rolling sums and partitioned calculations
- **CTEs (Common Table Expressions)**: Complex query simplification
- **Temporary Tables**: Intermediate data processing
- **Views**: Reusable datasets for visualization
- **Aggregate Functions**: Statistical analysis and summarization

## 📈 Key Features
- **Real-time Calculations**: Dynamic percentage and rate computations
- **Scalable Analysis**: Handles large-scale pandemic data efficiently
- **Multi-level Aggregation**: Country, continent, and global-level insights
- **Time-series Analysis**: Trend identification across the pandemic timeline

## 🗂 Dataset Structure
The project utilizes two primary datasets:
- **CovidDeaths**: Case and mortality statistics
- **CovidVaccinations**: Vaccination rollout data

## 🚀 Skills Demonstrated
- SQL Query Optimization
- Data Cleaning and Transformation
- Statistical Analysis using SQL
- Database View Creation
- Complex Join Operations
- Window Functions Implementation
- Temporary Table Management

This project serves as a robust foundation for COVID-19 data visualization dashboards and epidemiological research, providing clean, analysis-ready datasets and comprehensive pandemic insights.
