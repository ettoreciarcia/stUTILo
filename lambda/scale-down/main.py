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

    # Get the minimum instances from the environment variable, if defined
    min_instances = int(os.environ.get('MIN_INSTANCES', 0))

    # Loop through the Auto Scaling Groups
    for group in autoscaling_groups:
        try:
            # Determine the desired capacity based on the presence of MIN_INSTANCES
            desired_capacity = min_instances if min_instances > 0 else 0

            # Scale the Auto Scaling Group to desired capacity
            response = autoscaling_client.update_auto_scaling_group(
                AutoScalingGroupName=group['name'],
                MinSize=min_instances,
                MaxSize=0,  # Setting MaxSize to 0 as in your original code
                DesiredCapacity=desired_capacity
            )
            print(f"Auto Scaling Group {group['name']} scaled to {desired_capacity} instances.")
        except Exception as e:
            print(f"Error while scaling Auto Scaling Group {group['name']}: {str(e)}")

    return {
        'statusCode': 200,
        'body': f"Auto Scaling Groups scaled to {desired_capacity} instances successfully."
    }
