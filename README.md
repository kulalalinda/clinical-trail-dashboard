# KroniKare Wound Care Clinical Trial Dashboard

This Shiny dashboard simulates and visualizes clinical trial data related to AI-assisted wound care management. Inspired by real-world use cases from [KroniKare](https://kronikare.ai/), the dashboard demonstrates patient demographics, wound types, AI treatment recommendations, and healing progression over time.

## 📊 Features

- Interactive tables of patient and wound information
- Visualizations of wound distribution by type
- Demographic summary plots (age distribution, gender)
- Weekly wound healing progression across patient groups
- AI recommendation tracking and monitoring

## 🧪 Technologies Used

- **R** (data manipulation and simulation)
- **Shiny** (web framework for the dashboard)
- **ggplot2**, **dplyr**, **DT**, **plotly**, **shinydashboard** (visualization and UI)

## 🚀 How to Run Locally

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/kronikare-wound-dashboard.git
   cd kronikare-wound-dashboard
install.packages(c("shiny", "shinydashboard", "dplyr", "ggplot2", "plotly", "DT", "lubridate", "tidyr"))
-shiny::runApp()

## 🧬 Data Simulation

All data used in this dashboard is **synthetically generated** to simulate a clinical trial environment for AI-assisted wound care. The simulated dataset includes:

- **Patient Demographics**: Age, gender, and unique patient IDs
- **Wound Characteristics**: Wound type (e.g., diabetic ulcer, pressure injury), wound size (cm²), and severity levels
- **Treatment Plans**: Weekly treatment status and duration
