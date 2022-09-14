terraform {
  required_version = ">= 1.1"
  required_providers {
    linode = {
      source  = "linode/linode"
      version = ">= 1.28"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
