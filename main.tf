

# resource "aws_instance" "runner" {
#   ami           = local.ami_id
#   instance_type = "t3.small"
#   vpc_security_group_ids = [aws_security_group.main.id]
#   subnet_id = "subnet-0bf3d53e59ef42889" #replace your Subnet

#   # need more for terraform
#   root_block_device {
#     volume_size = 50
#     volume_type = "gp3" # or "gp2", depending on your preference
#   }
#   user_data = file("runner.sh")
#   tags = merge(
#     local.common_tags,
#     {
#         Name = "${var.project}-${var.environment}-runner"
#     }
#   )
# }

# resource "aws_security_group" "main" {
#   name        =  "${var.project}-${var.environment}-runner"
#   description = "Created to attatch runner"

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = merge(
#     local.common_tags,
#     {
#         Name = "${var.project}-${var.environment}-jenkins"
#     }
#   )
# }

# Security Group for Runner
resource "aws_security_group" "runner" {
  name        = "${var.project}-${var.environment}-runner-sg"
  description = "SG for GitHub Actions runner to access private EKS API"
  vpc_id      = aws_vpc.main.id

  # Outbound: allow HTTPS to EKS control plane
  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_control_plane.id] # reference EKS SG
  }

  # Inbound: allow all internal VPC traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  tags = merge(
    local.common_tags,
    { Name = "${var.project}-${var.environment}-runner-sg" }
  )
}

# EC2 Runner Instance
resource "aws_instance" "runner" {
  ami           = local.ami_id             # From locals.tf
  instance_type = "t3.small"

  # Choose first private subnet automatically
  subnet_id = element(var.private_subnet_ids, 0)

  vpc_security_group_ids = [aws_security_group.runner.id]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("runner.sh")

  tags = merge(
    local.common_tags,
    { Name = "${var.project}-${var.environment}-runner" }
  )
}
