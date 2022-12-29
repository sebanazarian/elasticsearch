### AWS

variable "profile" {
  description = "The Amazon profile to run in"
  type = string
}

variable "region" {
  description = "The Amazon region to run in"
  type = string
}

variable "tags" {
  type = map
}

### AMI

variable "AMI_OWNER"{
  type = list(string)
}
### ELASTIC SEARCH 

variable "ES_CLUSTER_NAME" {
  type= string
  default = "cluster-name"
}

variable "ES_INSTANCE_TYPE" {
  type= string
  default = "m5a.xlarge"
}

variable "ES_NODES" {
  type        = any
  # map(object({
  #   roles: list(string)
  #   size_volume_root: number
  #   size_volume_data: number 
  # }))
  default = {}
}

### EBS

variable "KMS_ARN" {
  type = string
}

### VPC

variable "VPC_ID" {
  type = string
}

variable "SUBNET_ID" {
  type = string
}

variable "ES_CIDR_BLOCKS" {
  type = list(string)
}

variable "key_name" {
  default = "key"
}

## S3
variable "region_s3" {
  default = "us-east-1"
}

variable "AMI_NAME_MASTER" {
  default = ""
}
variable "AMI_NAME_DATA" {
  default = ""
}

