
resource "aws_iam_role" "lambda_source_s3_workflow_role" {
  name = "lambda_source_s3_workflow_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       {
           "Effect": "Allow",
           "Principal": {
               "Federated": "arn:aws:iam::${data.aws_caller_identity.default.account_id}:oidc-provider/token.actions.githubusercontent.com"
           },
           "Action": "sts:AssumeRoleWithWebIdentity",
           "Condition": {
               "StringEquals": {
                   "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
               }
           }
       }
    ]
}
EOF
}

resource "aws_iam_policy" "lambda_source_s3_workflow_policy" {
  name        = "lambda_source_s3-github-workflow-policy"
  description = "Policy for github actions for lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
       
        {
            "Sid": "AccessS3Policy",
            "Effect": "Allow",
            "Action": [
                "s3:*"

            ],
            "Resource": ["${aws_s3_bucket.lambda_source_bucket.arn}","${aws_s3_bucket.lambda_source_bucket.arn}/*"]
          
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_policy-attach" {
  role       = aws_iam_role.lambda_source_s3_workflow_role.name
  policy_arn = aws_iam_policy.lambda_source_s3_workflow_policy.arn
}

output "github_role_arn" {
  value = aws_iam_role.lambda_source_s3_workflow_role.arn

}