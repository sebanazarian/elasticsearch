data "aws_vpc" "vpc" {
  id = var.VPC_ID
}

resource "aws_security_group" "firewall" {
  name        = "${var.ES_CLUSTER_NAME}-firewall"
  description = "Firewall"

  vpc_id = data.aws_vpc.vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ES_CIDR_BLOCKS
    security_groups = []
  }

  ingress {
    description = "Elasticsearch"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = var.ES_CIDR_BLOCKS
  }

  ingress {
    description = "Elasticsearch"
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = var.ES_CIDR_BLOCKS
    security_groups = []
  }

  ingress {
    description = "Elasticsearch"
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = var.ES_CIDR_BLOCKS
    security_groups = []
  }

  egress {
    description = "Outbound Allowed"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.ES_CLUSTER_NAME}-firewall"
  }
}

resource "aws_security_group" "discovery" {
  name        = "${var.ES_CLUSTER_NAME}-discovery"
  description = "Auto-Discovery ELK"
  
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.ES_CLUSTER_NAME}-discovery"
  }
}