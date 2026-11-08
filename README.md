# Soldier Management System (SMS) Database Project

A comprehensive PostgreSQL database project designed for managing military personnel, ranks, unit assignments, and mission deployments.

📌 Project Overview

The Soldier Management System (SMS) is a relational database system created to track soldiers, their rank structures, unit assignments, and mission deployments. The database strictly adheres to Third Normal Form (3NF) principles and includes comprehensive constraints, indexes for query optimization, and dynamic views for operational reporting.

📁 Repository Structure

├── sms_202512480.sql    # Complete SQL script (Schema, Seed Data, Queries, Index, Views)
├── README.md            # Technical documentation and setup guide
└── ERD_Diagram.png      # Entity-Relationship Diagram of the system


🗄️ Database Schema & Entities

The relational structure consists of 5 interconnected tables:

ranks: Stores rank names and hierarchy levels (rank_level check constraint 1–6).

units: Stores military unit names and locations.

missions: Tracks operational missions, start dates, and end dates.

soldiers: Core entity containing soldier attributes, linked via Foreign Keys to ranks and units.

soldier_missions: Junction table establishing a Many-to-Many (M:N) relationship between soldiers and missions with specific roles.

📊 Summary of SQL Tasks Completed

Part A & B (Schema & Seed Data): Tables created with primary keys, foreign keys, CHECK constraints, UNIQUE constraints, and safe multi-row insertions utilizing ON CONFLICT DO NOTHING.

Part C (Data Retrieval): Implemented queries C1–C10 using pagination (LIMIT), set filtering (IN), ranges (BETWEEN), multi-table JOINs, anti-joins (LEFT JOIN ... WHERE IS NULL), and aggregate grouping (COUNT, GROUP BY).

Part D (Optimization & Views):

Analyzed query execution plans using EXPLAIN.

Created index idx_soldiers_last_name to optimize search performance.

Built view v_soldier_profile to standardize personnel reporting.

Change Order: Successfully modified schema via ALTER TABLE soldiers ADD COLUMN email VARCHAR(100) UNIQUE;.

📝 Submission Checklist

[x] Initial execution query SELECT CURRENT_USER, NOW(); included.

[x] Every query commented with -- Does: and -- Rows returned:.

[x] Handled all potential constraint conflicts gracefully.

[x] Validated against database schema and ERD.

👤 Author

Name: ALI AMIN

Student ID: 202512480

Course: SQL

Date: November 2026
