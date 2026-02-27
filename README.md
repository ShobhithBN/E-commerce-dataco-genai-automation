# 🚀 DataCo GenAI Automation
## AI-Powered Business Summary & Supply Chain Risk Alert System

---

## 📌 Project Overview

This project builds an intelligent automation system using:

- **PostgreSQL** (SQL-based ETL & KPI queries)
- **n8n** (workflow automation)
- **GenAI (OpenRouter Chat Model)** for reasoning & summarization
- **Gmail / Slack APIs** for automated communication

The system converts structured business data into:

- 📊 Daily executive summaries  
- ⚠️ Automated supply chain risk alerts  
- 📈 Actionable business recommendations  

This project demonstrates the integration of **data engineering, automation, and AI-driven decision support**.

---

# 🧩 Business Problem

## Problem 1 – Leadership Does Not Open Dashboards Daily

Executives require:
- Automated daily insights  
- Plain-English explanations  
- Early risk detection  
- Recommended actions  

## Problem 2 – Supply Chain Risk Needs Immediate Alerts

Operations teams must be notified when:
- Late deliveries increase  
- Shipping delays exceed scheduled timelines  
- Same-Day shipments fail  

---

# 🏗️ System Architecture

## 1️⃣ Daily AI Business Summary Workflow

**Workflow Name:** `Daily_AI_Business_Summary_Static`

### Workflow Steps

1. Schedule Trigger (Daily 9:00 AM)
2. KPI SQL Query
3. Top 5 Products Query
4. Website Traffic Query
5. Code Node (Merge JSON)
6. AI Agent (Generate Business Summary)
7. Gmail Notification


## 2️⃣ Supply Chain Risk Alert Workflow

**Workflow Name:** `Supply_Chain_Risk_Alert_Static`

### Workflow Steps

1. Schedule Trigger (Every 2 Hours)
2. Risk SQL Query
3. IF Condition (Check Risk Thresholds)
4. AI Agent (Generate Alert Explanation)
5. Slack / Email Notification

### Workflow Diagram
Schedule Trigger
↓
Risk SQL Query
↓
IF (Risk Detected?)
↓
AI Agent
↓
Slack / Email Alert

---

# 📊 Data Handling Logic

The dataset used is historical (static).  

To simulate real-time reporting:

- The system calculates `MAX(order_date)`
- Treats `(max_date - 1 day)` as “Yesterday”
- Compares with `(max_date - 2 days)` for trend analysis

This allows the automation to behave like a live production system.

---

# 📈 KPIs Used

## Supply Chain KPIs

- Total Sales
- Total Profit
- Profit Margin %
- Late Delivery %
- High Risk Orders
- Shipping Delay
- Top 5 Products

## Digital Engagement KPIs

- Total Website Views
- Unique Visitors

---

# 🤖 GenAI Integration

GenAI is used for:

- Business reasoning
- Risk interpretation
- Executive summarization
- Action recommendation

### AI Input

Structured JSON generated from SQL queries.

### AI Output

- Daily summary (≤140 words)
- Risk highlights
- 3 recommended actions
- Operational alert explanations

---

# 📄 Example AI Output

## Daily Summary

> Yesterday’s total sales reached ₹12.4M with an 18% profit margin.  
> Late deliveries increased to 21%, indicating operational pressure in shipping.

## Risks

- Rising late deliveries  
- Increasing Same-Day shipment delays  

## Recommended Actions

1. Review courier capacity  
2. Prioritize high-margin dispatch  
3. Audit Same-Day logistics workflow  

---

# 🛠️ Tech Stack

- PostgreSQL
- n8n
- OpenRouter Chat Model (GenAI)
- JavaScript (n8n Code Node)
- Gmail API
- Slack API

---

# 📈 Business Impact

## For Leadership
- No manual dashboard dependency
- Automated executive insights
- Clear, concise business communication

## For Operations
- Early detection of shipping issues
- Proactive intervention capability
- Reduced operational risk exposure

---

# 🎯 Skills Demonstrated

- SQL-based ETL & aggregation
- Business KPI modeling
- Workflow automation (n8n)
- AI prompt engineering
- Risk detection systems
- Executive-level insight generation

---

# 🚀 Future Enhancements

- Add anomaly detection thresholds
- Integrate predictive delay modeling
- Add region-wise performance monitoring
- Deploy with live streaming data
- Integrate with BI tools

---

# 🏁 Conclusion

This project demonstrates how structured business data combined with GenAI can:

- Automate executive reporting  
- Detect operational risks  
- Translate raw KPIs into strategic insights  

It integrates **data engineering, automation, and AI-driven decision intelligence** into a real-world business solution.
