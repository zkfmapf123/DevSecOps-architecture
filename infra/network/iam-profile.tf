####################### EC2 IAM #######################
resource "aws_iam_role" "ec2-ssm-role" {
  name = "ec2-ssm-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ec2-ssm-role"
  }
}

data "aws_iam_policy" "ssm-policy" {
  name = "AmazonEC2RoleforSSM"
}


resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.ec2-ssm-role.name
  policy_arn = data.aws_iam_policy.ssm-policy.arn
}

########################## EC2 Instance Profile ##########################
resource "aws_iam_instance_profile" "ec2-ssm-role-profile" {
  name = aws_iam_role.ec2-ssm-role.name
  role = aws_iam_role.ec2-ssm-role.name

  depends_on = [aws_iam_role.ec2-ssm-role]
}
