import os
import boto3

def lambda_handler(event, context):
    # Initialize the client for AWS Auto Scaling
    autoscaling_client = boto3.client('autoscaling')

    # autoscaling_groups = os.environ.get('ASG_GROUP_INFO', '')
    autoscaling_groups = [{"desired_capacity":3,"max_size":3,"min_size":3,"name":"eksctl-eksctl-cluster-nodegroup-infra-NodeGroup-xqnYmFpEvyqm"},{"desired_capacity":2,"max_size":2,"min_size":2,"name":"eksctl-eksctl-cluster-nodegroup-app-NodeGroup-1YvlpRgjGOEn"}]


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


# inizializza il main che richiama la funzione lambda_handler
if __name__ == "__main__":
    lambda_handler(None, None)
