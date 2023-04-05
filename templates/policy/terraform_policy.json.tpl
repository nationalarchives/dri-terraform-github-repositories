{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:GetPolicy",
        "iam:GetPolicyVersion",
        "iam:GetRole",
        "iam:ListAttachedRolePolicies",
        "iam:ListRolePolicies",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject"
      ],
      "Resource": [
        "arn:aws:s3:::${bucket_name}",
        "arn:aws:s3:::${bucket_name}/*",
        "arn:aws:iam::${account_id}:policy/DRITerraformRepositoriesPolicyMgmt",
        "arn:aws:iam::${account_id}:role/DRITerraformRepositoriesRoleMgmt"
      ]
    }
  ]
}

