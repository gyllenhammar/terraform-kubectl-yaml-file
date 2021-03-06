terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14.0"
    }
  }
}

provider "kubectl" {
  apply_retry_count = 3
  config_path       = var.kubeconfig_path
  load_config_file  = false
}

data "kubectl_file_documents" "docs" {
  content = (var.manifest_file_path != "" ? file(var.manifest_file_path) : var.manifest_content)
}

resource "kubectl_manifest" "sentence-resource" {
  for_each  = data.kubectl_file_documents.docs.manifests
  yaml_body = each.value
}
