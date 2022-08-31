
terraform {
  required_version = ">= 1.1"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 1.28"
    }
    random = ">= 3.4"
  }
}
