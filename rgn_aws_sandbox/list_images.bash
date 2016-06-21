aws ec2 describe-images --owners self --region us-west-2 | jq '.Images[].Name'
