import random, json, time, boto3
from datetime import datetime 

s3 = boto3.client('s3')
bucket = "${s3_bucket_name}"

# Generate random data 
def generate_data(): 
    return {
        "timestamp" : datetime.utcnow().isoformat(), 
        "temperature" : round(random.uniform(20.0, 30.0) , 2), 
        "humidity" : round(random.uniform(40.0, 100.0), 2), 
        "nutrition" : round(random.uniform(0.0, 10.0) , 2)
    }

def upload_data():
    filename = f"sensor-data/{int(time.time())}.json"
    data = generate_data()

    s3.put_object(Bucket=bucket, Key=filename, Body=json.dumps(data))

upload_data()