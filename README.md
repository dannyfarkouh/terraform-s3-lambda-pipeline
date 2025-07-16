# Serverless S3 to Lambda Pipeline (Terraform + AWS)

This project provisions a serverless, event-driven data ingestion pipeline using **Terraform**, **AWS S3**, and **AWS Lambda**.  
It simulates a real-time scenario where JSON files are uploaded to S3 every minute using a cron job, automatically triggering a Lambda function to process and log metadata.

---

## What It Does

- Creates a **versioned, encrypted S3 bucket**
- Deploys a **Python-based AWS Lambda function**
- Sets up **S3 → Lambda event notifications**
- Logs events to **CloudWatch**
- Includes a **cron-based simulation** that uploads a JSON file to S3 every minute

---

## Real-Time Simulation

A Python script (`sensor_upload.py`) runs every minute via cron, uploading a new JSON file to the S3 bucket.  
Each upload triggers the Lambda function, which logs metadata (file name, size, bucket) to **CloudWatch Logs**.

---

## Project Structure

| File                | Purpose                            |
|---------------------|------------------------------------|
| `lambda_handler.py` | Lambda function to log S3 events   |
| `sensor_upload.py`  | Simulates JSON uploads via cron    |
| `*.tf` files        | Terraform configuration for AWS    |

---

## Deploy

```bash
terraform init
terraform apply

## Destroy

```bash
terraform destroy
