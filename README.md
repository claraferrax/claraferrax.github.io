# Data Scientist in Training
   
## 📊 Technical Skills
- **Python:** Pandas, NumPy, scikit-learn, TensorFlow, PyTorch, Matplotlib, Seaborn, **Qiskit**
- **Data / BI:** SQL, Spark, Excel, Tableau, BigQuery
- **Cloud:** AWS (S3, Redshift, SageMaker, QuickSight)
- **Tools:** Git, Salesforce, Swift
- **Other:** HTML, CSS, Django, Jira, Confluence, Celonis, BPMN

## 🎓 Education

### M.S. in Big Data & Business Analytics | ESCP (Paris, France and Berlin, Germany)
<sub>**June 2024 – Feb 2026**</sub>
- **Relevant Coursework:** Advanced Machine Learning, Business Data Modelling, Research Methods, NLP
- **Thesis:** Quantum Machine Learning on **Quantum Feature Projection** to improve clustering in supply chain management
- Thesis supervisor: IBM Distinguished Engineer

### B.S. in Computer Science and Management | LUISS Guido Carli University in Rome, Italy
<sub>**Sep. 2020 - July 2023**</sub>
- **Relevant Coursework:** Quantitative models for data science, ML & AI, Databases and Big Data, Social Network Analysis, Data Analysis for Business, FinTech
- **Thesis:** “Evolving Language Models: Technical Aspects and Impact on Higher Education”

### High School Diploma | S.I.E.S. Spinelli in Torino, Italy 
<sub>**Sep. 2015 - July 2020**</sub>
- Scientific Lyceum with Italian and French Baccalaureate

## 💼 Work Experience


### **Business Intelligence Engineering Intern @ Amazon**
<sub>_Paris, France | July – Present_</sub>
- Optimized and productionised ETL pipelines on AWS using Spark SQL
- Ran statistical analysis on A/B tests for a **€30M savings** lab in network planning
- Modelled impact of exteriments to predict savings
- Automated analysis in Python and built dashboards for Search Algo insights
- Supported testing and fine-tuning MCP AI systems using prompt engineering

### **Data Science Intern @ Rolls-Royce Motor Cars**
<sub>_Munich, Germany | June - Dec. 2023_</sub>
- Cleansed and analyzed data on residual value of cars using Data Science techniques (Clustering, PCA, Regression) with Python.
- Conducted analysis on social media data to derive insights on engagement and presented findings to stakeholders.
- Conducted academic research on Large Language Models to explore potential implementations within the company.
- Supported the enhancement of data quality in Salesforce and engaged in Agile Ceremonies with Data Science and Engineering teams.

### **Contractor @ Zanichelli**
<sub>_Rome, Italy | Winter 2021_</sub>
- Editorial work on a high school computer science book “Imparare a Programmare” (ed.2022): mainly addressing explanation of algorithms and basics of programming languages.

## 🛠️ Projects

### Criteo Hackathon - Brand Unification with NLP and Web Scrapping APIs
[Project Folder](https://github.com/claraferrax/Criteo-Hackathon)

[![My Skills](https://skillicons.dev/icons?i=python,vscode)](https://skillicons.dev)
- In this project, we unify brand names using a custom weighted Jaccard similarity metric. We begin by tokenizing the brand names and assign higher weights to tokens that represent brand names and lower weights to common words (identified by NLTK's English vocabulary). This approach allows us to effectively cluster variants like Versace, Versace Kids, and Versace Jeans. To merge brands with distinct naming (e.g., EA vs. Electronic Arts), we enrich our dataset by scraping URLs from targeted Google searches (using queries like "brand name" and "brand name + logo") and fetching descriptive texts via the Gemini API. Finally, we apply our weighted similarity metric to product descriptions—tuning the influence of common words—to achieve highly accurate brand unification.

### Projected Quantum Features for Supply Chain Anomaly Detection (Master Thesis Research Component) ⚛️📦
[Project Folder](https://github.com/claraferrax/PQF/tree/main)

[![My Skills](https://skillicons.dev/icons?i=python,spyder)](https://skillicons.dev) 

**Summary:** Researched whether **Projected Quantum Features (PQF)** can improve anomaly detection compared to strong classical baselines in a realistic monitoring setting.
**Context:** In supply-chain monitoring, keeping false alarms low is key to maintaining trust and usability.

- Built a reproducible anomaly detection pipeline aligned with real deployment constraints: **chronological train/validation/test split** with a **guard band** to reduce temporal leakage.  
- Used **robust scaling** fitted on train only (median + MAD) to handle heavy tails and outliers.  
- Compared practical classical baselines used in operations: **Robust Z-score**, **PCA reconstruction error**, **K-means distance to centroid**.  
- Implemented **Projected Quantum Features (PQF)** as a hybrid model: **fidelity quantum kernel + One-Class SVM**, computed via **Qiskit statevector simulation** under a fixed qubit (feature) budget.    
- Calibrated thresholds on validation normals to target a strict **α = 1% false-positive rate**, then reported **PR-AUC** plus **precision/recall at the calibrated operating point**.    
- Result: PQF improved detection quality in the operating region that matters for monitoring (low-FPR), with a clear quality–cost tradeoff under simulation. 

**Keywords:** Quantum Kernel Methods, PQF, One-Class SVM, Anomaly Detection, Supply Chain, Qiskit  

### Fraudolent Links Detection 🥷🏻 
[Project Folder](https://github.com/claraferrax/fraudulentLinks-detection/blob/main/README.pdf)

[![My Skills](https://skillicons.dev/icons?i=r)](https://skillicons.dev)
- Developed a counter-fraud strategy by using Machine Learning models—Naive Bayes, Logistic Regression, and Decision Tree—to detect and classify fraudulent URLs, including phishing and defacement attacks. Through exploratory data analysis (EDA) and model training, the project aims to identify key characteristics of fraudulent links and improve future fraud detection and prevention systems.

### Customer Churn Prediction 💼
[Project Folder](https://github.com/claraferrax/customer-churn/blob/main/churn.ipynb) 

[![My Skills](https://skillicons.dev/icons?i=python,sklearn,vscode,r,matlab)](https://skillicons.dev)
- Implemented multiple ML algorithms using Jupyter Notebook and Python libraries (NumPy, Pandas, matplotlib, sklearn, seaborn).
- Achieved 99.22% accuracy on testing data and applied Clustering on new data post-PCA using R.

### Wine Quality Prediction 🍷 
[Project Folder](https://github.com/claraferrax/wine-quality-prediction/blob/main/README.pdf)

[![My Skills](https://skillicons.dev/icons?i=python,sklearn,vscode,r,matlab)](https://skillicons.dev)
- Developed predictive models using regression techniques (multiple regression,LASSO, ridge) and non-linear methods (natural splines, decision trees, random forests) to assess wine quality based on its biological components. Conducted clustering analysis with PCA and K-means to identify key predictors and data patterns. Used R libraries (tidyvers, ISLR, glmnet, ggplot2, dplyr, factoextra, pRoc, cluster) (_May 2022_).

### Job Seeking 👩🏻‍💻 
[![My Skills](https://skillicons.dev/icons?i=mysql)](https://skillicons.dev)
- Wrote SQL queries to identify the best-suited jobs in a dataset of 2,500 offers worldwide.

### Social Media Marketing Campaign 📈 
- Used NLP and Mining techniques on Twitter data and applied Explanatory Analytics using Knime.
- Predicted customer engagement with campaigns, including topic modeling with LDA.

### Virus Propagation 🦠
[![My Skills](https://skillicons.dev/icons?i=python,spyder)](https://skillicons.dev)
- Created a virus propagation model in a dolphin society and analyzed it using Python (_April 2022_).

### Travel Agency Site 🗺️ 
[![My Skills](https://skillicons.dev/icons?i=html,css,django)](https://skillicons.dev)
- Designed and implemented a Web App using HTML, CSS, and Django to showcase destinations and book trips (_May 2021_).

## 📜 Certifications and Training
- **Stanford Online** - Machine Learning: projects on ML algos, model regularisation and feature engineering (_Nov. 2022_)
- **KNIME** - Data Science with KNIME software: proficiency in the platform for data driven innovation (_Nov. 2022_)
- **Google** - Advanced Google Analytics: data analysis, tracking, optimization, and informed decision-making (_Oct. 2022_)
- **Cisco** - Cybersecurity Essentials (_Dec. 2021_)
- **Kaggle** - Data Visualization with Python's Libraries Matplotlib, Seaborn, and Plotly
- **Coursera** - "Successful Negotiation: Essential Strategies and Skills" (_Aug. 2021_)
- **Académie de Dijon** - Diplôme du Baccalauréat Général (_July 2020_)
- **Oxford Scholastica Academy** - Computer Science Summer Course (_Aug. 2019_)
- **ISSOS Yale University** - Business and Entrepreneurship course comppleted, Outdoor Leadership course competed with honors (_July 2018_)

## 🗣️ Additional Information

### Languages
- **Italian** (Mother Tongue)
- **English** (Fluent)
- **French** (Intermediate Proficiency)
- **Spanish** (Basic Proficiency)

### Activities
- Debate Course (2015-2018), Hostess Services, Volunteer Work, Golf, Pilates

### Contact Information
**LinkedIn:** [https://www.linkedin.com/in/clara-maria-ferracini-961290211]  
**Email:** [claramferracini@gmail.com]


