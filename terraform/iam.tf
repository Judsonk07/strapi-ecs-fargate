# 1. Create the IAM Role (Added suffix)
resource "aws_iam_role" "ec2_ecr_role" {
  name = "strapi_role_${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# 2. Attach the policy
resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 3. Create the Instance Profile (Added suffix)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "strapi_profile_${random_id.suffix.hex}"
  role = aws_iam_role.ec2_ecr_role.name
}