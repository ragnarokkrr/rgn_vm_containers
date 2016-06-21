aws ec2 describe-images --owners self --region us-west-2 | jq '.Images[] | select(.Name=="ansible_full_img")'
