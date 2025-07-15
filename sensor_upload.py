import boto3, json, time, random 
from datetime import datetime 

s3 = boto3.client('s3')
bucket = "${s3_bucket_name}"

# Generate random sensor data 

def generate_sensor_data():
    return {
        "timestamp": datetime.utcnow().isoformat(), 
        "temperature": round(random.uniform(18.0, 26.0), 2), 
        "humidity": round(random.uniform(50.0, 80.0), 2), 
        "nutrients": round(random.uniform(0.5, 1.5), 2)
    }

# upload sensor data to s3 bucket 
# s3.put_object is the policy that we gave the ec2 instance 
def upload_to_s3():
    data = generate_sensor_data()
    filename = f"sensor-data/{int(time.time())}.json"
    s3.put_object(Bucket=bucket, Key=filename, Body=json.dumps(data))

upload_to_s3()