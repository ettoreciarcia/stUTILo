import os
import boto3
import json

def lambda_handler(event, context):
    # Initialize the client for AWS Auto Scaling
    autoscaling_client = boto3.client('autoscaling')

    # Get the environment variable containing the JSON string
    autoscaling_groups_str = os.environ.get('ASG_GROUP_INFO')

    # Convert the JSON string to a list of dictionaries
    autoscaling_groups = json.loads(autoscaling_groups_str)

    # Loop through the Auto Scaling Groups
    for group in autoscaling_groups:
        try:
            # Scale the Auto Scaling Group to 0 instances
            response = autoscaling_client.update_auto_scaling_group(
                AutoScalingGroupName=group['name'],
                MinSize=0,
                MaxSize=0,
                DesiredCapacity=0
            )
            print(f"Auto Scaling Group {group['name']} scaled to 0 instances.")
        except Exception as e:
            print(f"Error while scaling Auto Scaling Group {group['name']}: {str(e)}")

    return {
        'statusCode': 200,
        'body': 'Auto Scaling Groups scaled to 0 instances successfully.'
    }
