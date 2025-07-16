import json

def lambda_handler(event, context):
    print("Received S3 event:")
    print(json.dumps(event, indent=2))
    return {
        "statusCode": 200,
        "body": json.dumps("S3 event received and logged.")
    }