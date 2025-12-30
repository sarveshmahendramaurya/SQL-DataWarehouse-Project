<h1>SQL Data Ware-house Project</h1>
<p> </p>
<br>

  <h1>SQL Server End-to-End Data Warehouse (Medallion Architecture)</h1>

   <h2><span class="section-icon"></span>Project Overview</h2>
    <p>
        This project demonstrates the design and implementation of a robust, <strong>SQL-only Data Warehouse</strong>. 
        It transforms raw data from disparate CRM and ERP source systems into a structured <strong>Star Schema</strong> optimized for high-performance data analysis and machine learning model training. 
        The entire ETL (Extract, Transform, Load) process is orchestrated within SQL Server using a multi-layered Medallion Architecture.
    </p>

   <h2><span class="section-icon"></span>Architecture & Data Flow</h2>
    <p>The warehouse is divided into three logical layers to ensure data quality, lineage, and scalability.</p>

  <div class="layer-box bronze">
        <h3>1. Bronze Layer (Raw Data)</h3>
        <ul>
            <li><strong>Source Systems:</strong> Ingests data from two main business units: CRM and ERP.</li>
            <li><strong>Object Type:</strong> Physical tables populated via batch processing.</li>
            <li><strong>Interface:</strong> Ingested from CSV files stored in a designated folder structure.</li>
            <li><strong>Loading Strategy:</strong> Full load using "Truncate & Insert" to capture the current state of source files.</li>
            <li><strong>Transformations:</strong> None. Data is stored in its raw format for auditability.</li>
        </ul>
    </div>

   <div class="layer-box silver">
        <h3>2. Silver Layer (Standardized Data)</h3>
        <ul>
            <li><strong>Purpose:</strong> Acts as the "Cleansing & Integration" zone.</li>
            <li><strong>Key Transformations:</strong> Data cleansing (handling nulls/duplicates), standardization of types, and data enrichment.</li>
            <li><strong>Lineage:</strong> Data flows from bronze tables (e.g., <code>crm_sales_details</code>, <code>erm_cust_az12</code>) into refined silver equivalents.</li>
        </ul>
    </div>

   <div class="layer-box gold">
        <h3>3. Gold Layer (Curated Analytics)</h3>
        <ul>
            <li><strong>Object Type:</strong> Primarily implemented as SQL Views to provide real-time, non-load transformations.</li>
            <li><strong>Data Modeling:</strong> Implements a Star Schema consisting of a centralized Fact table and descriptive Dimension tables.</li>
            <li><strong>Features:</strong> Includes data integrations, complex aggregations, and applied business logic.</li>
        </ul>
    </div>

  <h2><span class="section-icon"></span>Data Modeling (Star Schema)</h2>
    <p>The Gold Layer is designed specifically for analytical efficiency and ease of use in BI tools and ML pipelines.</p>

  <h3>Fact Table</h3>
    <ul>
        <li><strong><code>gold.fact_sales</code>:</strong> Contains core business metrics such as <code>sales_amount</code>, <code>quantity</code>, and <code>price</code>.</li>
        <li><strong>Keys:</strong> Linked via <code>product_key</code> and <code>customer_key</code>.</li>
        <li><strong>Dates:</strong> Tracks <code>order_date</code>, <code>shipping_date</code>, and <code>due_date</code>.</li>
    </ul>

  <h3>Dimension Tables</h3>
    <ul>
        <li><strong><code>gold.dim_customers</code>:</strong> Stores attributes including name, country, marital status, gender, and birthdate.</li>
        <li><strong><code>gold.dim_products</code>:</strong> Details product hierarchy including category, subcategory, cost, and product line.</li>
    </ul>

   <h2><span class="section-icon"></span>Technical Stack</h2>
    <ul class="stack-list">
        <li class="stack-item">Microsoft SQL Server</li>
        <li class="stack-item">T-SQL (Stored Procedures & Views)</li>
        <li class="stack-item">Star Schema Design</li>
        <li class="stack-item">Medallion Architecture</li>
    </ul>

  <h2><span class="section-icon"></span>Downstream Consumption</h2>
    <ul>
        <li><strong>BI Reporting:</strong> Power BI / Tableau dashboards for executive decision-making.</li>
        <li><strong>Machine Learning:</strong> Prepared "Flat Tables" and feature sets ready for model training in Python or R.</li>
    </ul>
<h2>my linkdin profile</h2>
<a href=https://www.linkedin.com/in/sarvesh-maurya-20b822391?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app target="_blank" rel="noopener noreferrer">visit my linkdin</a>
