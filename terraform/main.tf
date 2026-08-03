provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "javaapp" {
  metadata {
    name = "java-app"
  }
}