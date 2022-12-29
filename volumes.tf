# locals {
#   nodes_data = [for key,node in var.ES_NODES : key if contains(node.roles, "data")]
# }

# resource "aws_ebs_volume" "volume_encrypted" {
#   for_each = toset(local.nodes_data)

#   availability_zone = aws_instance.node[each.value].availability_zone 
#   size              = var.ES_NODES[each.value].size_volume_data
#   encrypted         = true
#   kms_key_id        = var.KMS_ARN

#   tags = {
#     Name = "${var.ES_CLUSTER_NAME}-${each.value}-encrypted-volume"
#   }
# }

# resource "aws_volume_attachment" "volume_attachment" {
#   for_each = toset(local.nodes_data)

#   device_name  = "/dev/xvdh"
#   volume_id    = aws_ebs_volume.volume_encrypted[each.value].id
#   instance_id  = aws_instance.node[each.value].id
#   force_detach = true

#   depends_on = [
#     aws_instance.node
#   ]
# }
