# ELASTICSEARCH V8

Terraform project of the Elastic Search v8

## Considerations

In the vars file you have these variables:

1. Check If the AMI exists

```bash
AMI_NAME_MASTER= <ami-name>
AMI_NAME_DATA= <ami-name>
```
2. You need to define the quantity of Nodes, roles and size_volume

In this case we have 3 Master, 1 Data and 1 Query

```bash
ES_NODES = {
  "master1" = {
    roles= ["master"]
    size_volume_root= 25
  },
  "master2" = {
    roles= ["master"]
    size_volume_root= 25
  },
  "master3" = {
    roles= ["master"]
    size_volume_root= 25
  },
  "data1" = {
    roles= ["data"]
    size_volume_root= 25
    size_volume_data= 40
  },
  "query1" = {
    roles= ["ingest"]
    size_volume_root= 25
  }
}
```



## Getting started

1. Run terraform init
```bash
terraform init --backend-config="backend/<backend-name>"
```

2. Run a tf plan command
```bash
terraform plan --var-file="vars/<vars-name>"
```
