locals {
  nodes_master = [for key,node in var.ES_NODES : "'${key}'" if contains(node.roles, "master")]
}

data "aws_key_pair" "public_key" {
  key_name = var.key_name
}

data "aws_subnet" "subnet" {
  id = var.SUBNET_ID
}

resource "aws_instance" "node" {
  for_each      = var.ES_NODES
  ami           = contains(each.value.roles, "data") ? data.aws_ami.ami_data.id : data.aws_ami.ami_master.id
  instance_type = var.ES_INSTANCE_TYPE
  key_name      = data.aws_key_pair.public_key.key_name

  subnet_id = data.aws_subnet.subnet.id

  # root_block_device {
  #   encrypted  = true
  #   kms_key_id = var.KMS_ARN
  #   volume_size = each.value.size_volume_root
  # }

  vpc_security_group_ids = [
    aws_security_group.firewall.id,
    aws_security_group.discovery.id
  ]

  iam_instance_profile = "${var.ES_CLUSTER_NAME}-profile-discovery"
#[${join(",", local.nodes_master)}]
#${contains(each.value.roles, "master") ? "" : "discovery.zen.ping.unicast.hosts:   [\"m-01\"]"}
#${contains(each.value.roles, "master") ? "cluster.initial_master_nodes: [\"m-01\"]" : ""}
# cluster.initial_master_nodes: ["m-01","m-02","m-03"] #[${join(",", local.nodes_master)}]
  user_data = <<EOF
#!/bin/bash
sudo systemctl stop elasticsearch
sudo tee /etc/elasticsearch/elasticsearch.yml <<YAML
cluster.name: ${var.ES_CLUSTER_NAME}
cluster.initial_master_nodes: ["m-01","m-02","m-03"]
node.name: ${each.key}
node.roles: [ ${join(",", each.value.roles)} ]
path.data: ${contains(each.value.roles, "data") ? "/data/elasticsearch" : "/var/lib/elasticsearch"}
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
transport.port: 9300
discovery.zen.minimum_master_nodes: 2
discovery.seed_providers: ec2
discovery.ec2.endpoint: https://ec2.${var.region}.amazonaws.com
discovery.ec2.tag.discovery: ${var.ES_CLUSTER_NAME}
discovery.ec2.host_type: private_ip
discovery.ec2.groups: ${var.ES_CLUSTER_NAME}-discovery
discovery.ec2.any_group: false
cloud.node.auto_attributes: true
cluster.routing.allocation.awareness.attributes: aws_availability_zone
cluster.routing.allocation.node_concurrent_recoveries: 2
bootstrap.memory_lock: true
action.destructive_requires_name: true
indices.recovery.max_bytes_per_sec: 100mb
xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
xpack.security.http.ssl.enabled: false
YAML
sudo systemctl start elasticsearch
systemctl status elasticsearch.service
 sudo cat /var/log/elasticsearch/cluster.log
EOF

  tags = {
    Name      = "${var.ES_CLUSTER_NAME}-${each.key}"
    alias     = "${each.key}"
    type      = "${join(",", each.value.roles)}"
    discovery = var.ES_CLUSTER_NAME
  }

  depends_on = [
    aws_security_group.firewall,
    aws_security_group.discovery
  ]
}
