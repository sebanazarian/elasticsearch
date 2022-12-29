data "aws_ami" "ami_master" {
  owners = var.AMI_OWNER
  most_recent = true
 
  filter {
    name   = "name"
    values = [var.AMI_NAME_MASTER]
  }
}

data "aws_ami" "ami_data" {
  owners = var.AMI_OWNER
  most_recent = true
 
  filter {
    name   = "name"
    values = [var.AMI_NAME_DATA]
  }
}