terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "name" {
  default = "k8s-deployment"
}

variable "replicas" {
  default = 3
}

locals {
  pod_labels = {
    app = var.name
  }
}

variable "container_port" {
  default = 8080
}

variable "environment_variables" {
  default = 3
}

# For k8s deployment..

resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
  }
  spec {
    replicas = var.replicas
    template {
      metadata {
        labels = local.pod_labels
      }
      spec {
        container {
          image = "nginx"
          name  = var.name
          port {
            container_port = var.container_port
          }
          dynamic "env" {
            for_each = var.environment_variables
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }
    selector {
      match_labels = local.pod_labels
    }
  }
}


# For kubernetes service ~ loadbalancer

resource "kubernetes_service" "app" {
  metadata {
    name = var.name
  }
  spec {
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = var.container_port
      protocol    = "TCP"
    }
    selector = local.pod_labels
  }

}

locals {
  status = kubernetes_service.app.status
}
output "service_endpoint" {
  value = try(
    "http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}",
    "(error parsing hostname from status)"
  )
  description = "The K8S Service endpoint"
}
