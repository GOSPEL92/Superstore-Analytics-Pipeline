-- ============================================
-- Script: create_staging_tables.sql
-- Purpose: Define staging tables for Superstore project
-- Author: Eze
-- ============================================

-- Create staging schema if it doesn't exist
CREATE SCHEMA IF NOT EXISTS staging;

-- Drop table if it already exists (safe re-run)
DROP TABLE IF EXISTS staging.superstore_clean;

-- Create staging table for cleaned Superstore dataset
CREATE TABLE staging.superstore_clean (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE NOT NULL,
    ship_date DATE NOT NULL,
    shipping_delay INT,
    customer_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    product_id VARCHAR(50) NOT NULL,
    product_name VARCHAR(200),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    sales DECIMAL(10,2) NOT NULL,
    profit DECIMAL(10,2),
    profit_margin DECIMAL(5,2)
);

-- ============================================
-- Data Loading via SQLAlchemy from superstore_clean.csv
-- ============================================
-- COPY staging.superstore_clean
-- FROM '/path/to/superstore_clean.csv'
-- DELIMITER ','
-- CSV HEADER;

