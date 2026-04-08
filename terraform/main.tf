terraform {
 required_providers {
   yandex = {
     source  = "yandex-cloud/yandex"
     version = ">= 0.100"
   }
 }
}

provider "yandex" {
 token     = var.yc_token
 cloud_id  = var.cloud_id
 folder_id = var.folder_id
 zone      = "ru-central1-a"
}

##########################

# VPC

##########################

resource "yandex_vpc_network" "network" {
 name = "diplom-vpc"
}

##########################

# SUBNETS

##########################

resource "yandex_vpc_subnet" "public" {
 name           = "public-subnet"
 zone           = "ru-central1-a"
 network_id     = yandex_vpc_network.network.id
 v4_cidr_blocks = ["10.10.1.0/24"]
}

resource "yandex_vpc_subnet" "private" {
 name           = "private-subnet"
 zone           = "ru-central1-a"
 network_id     = yandex_vpc_network.network.id
 v4_cidr_blocks = ["10.10.3.0/24"]
}

##########################

# SECURITY GROUPS

##########################

resource "yandex_vpc_security_group" "bastion_sg" {
 name       = "bastion-sg"
 network_id = yandex_vpc_network.network.id

 ingress {
   protocol       = "TCP"
   port           = 22
   v4_cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   protocol       = "ANY"
   v4_cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "yandex_vpc_security_group" "web_sg" {
 name       = "web-sg"
 network_id = yandex_vpc_network.network.id

 ingress {
   protocol       = "TCP"
   port           = 80
   v4_cidr_blocks = ["10.10.0.0/16"]
 }

 ingress {
   protocol       = "TCP"
   port           = 22
   v4_cidr_blocks = ["10.10.1.0/24"]
 }

 egress {
   protocol       = "ANY"
   v4_cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "yandex_vpc_security_group" "elasticsearch_sg" {
 name       = "elasticsearch-sg"
 network_id = yandex_vpc_network.network.id

 ingress {
   protocol       = "TCP"
   port           = 9200
   v4_cidr_blocks = ["10.10.0.0/16"]
 }

 ingress {
   protocol       = "TCP"
   port           = 22
   v4_cidr_blocks = ["10.10.1.0/24"]
 }

 egress {
   protocol       = "ANY"
   v4_cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "yandex_vpc_security_group" "monitoring_sg" {
 name       = "monitoring-sg"
 network_id = yandex_vpc_network.network.id

 ingress {
   protocol       = "TCP"
   port           = 80
   v4_cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   protocol       = "TCP"
   port           = 5601
   v4_cidr_blocks = ["0.0.0.0/0"]
 }

 ingress {
   protocol       = "TCP"
   port           = 22
   v4_cidr_blocks = ["0.0.0.0/0"]
 }

 egress {
   protocol       = "ANY"
   v4_cidr_blocks = ["0.0.0.0/0"]
 }
}

##########################

# INSTANCES

##########################

resource "yandex_compute_instance" "bastion" {
 name = "bastion"
 resources {
   cores  = 2
   memory = 2
 }

 boot_disk {
   initialize_params {
     image_id = "fd8u0c8c7q1v2c5s0abc"
     size     = 20
   }
 }

 network_interface {
   subnet_id          = yandex_vpc_subnet.public.id
   nat                = true
   security_group_ids = [yandex_vpc_security_group.bastion_sg.id]
 }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
 }
}

resource "yandex_compute_instance" "web" {
 name = "web-1"
 resources {
   cores  = 2
   memory = 2
 }

 boot_disk {
   initialize_params {
     image_id = "fd8u0c8c7q1v2c5s0abc"
     size     = 20
   }
 }

 network_interface {
   subnet_id          = yandex_vpc_subnet.private.id
   nat                = false
   security_group_ids = [yandex_vpc_security_group.web_sg.id]
 }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
 }
}

resource "yandex_compute_instance" "elasticsearch" {
 name = "elasticsearch"
 resources {
   cores  = 2
   memory = 4
 }

 boot_disk {
   initialize_params {
     image_id = "fd8u0c8c7q1v2c5s0abc"
     size     = 30
   }
 }

 network_interface {
   subnet_id          = yandex_vpc_subnet.private.id
   nat                = false
   security_group_ids = [yandex_vpc_security_group.elasticsearch_sg.id]
 }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
 }
}

resource "yandex_compute_instance" "monitoring" {
 name = "monitoring"
 resources {
   cores  = 2
   memory = 4
 }

 boot_disk {
   initialize_params {
     image_id = "fd8u0c8c7q1v2c5s0abc"
     size     = 30
   }
 }

 network_interface {
   subnet_id          = yandex_vpc_subnet.public.id
   nat                = true
   security_group_ids = [yandex_vpc_security_group.monitoring_sg.id]
 }

 metadata = {
   ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
 }
}

##########################

# TARGET GROUP

##########################

resource "yandex_alb_target_group" "web_group" {
 name = "web-target-group"
 target {
   subnet_id = yandex_vpc_subnet.private.id
   ip_address = yandex_compute_instance.web.network_interface.0.ip_address
 }
}

##########################

# BACKEND GROUP

##########################

resource "yandex_alb_backend_group" "web_backend" {
 name = "web-backend-group"
 http_backend {
   name             = "backend-1"
   port             = 80
   target_group_ids = [yandex_alb_target_group.web_group.id]
   healthcheck {
     timeout  = "2s"
     interval = "5s"
     http_healthcheck {
       path = "/"
     }
   }
 }
}

##########################

# HTTP ROUTER

##########################


resource "yandex_alb_http_router" "router" {
 name = "web-router"
}

resource "yandex_alb_virtual_host" "virtual_host" {
 name           = "web-host"
 http_router_id = yandex_alb_http_router.router.id
 route {
   name = "route-to-web"
   http_route {
     http_route_action {
       backend_group_id = yandex_alb_backend_group.web_backend.id
     }
   }
 }
}

##########################

# LOAD BALANCER

##########################

resource "yandex_alb_load_balancer" "alb" {
 name       = "web-alb"
 network_id = yandex_vpc_network.network.id

 allocation_policy {
   location {
     zone_id   = "ru-central1-a"
     subnet_id = yandex_vpc_subnet.public.id
   }
 }

 listener {
   name = "http-listener"
   endpoint {
     address {
       external_ipv4_address {}
     }
     ports = [80]
   }
   http {
     handler {
       http_router_id = yandex_alb_http_router.router.id
     }
   }
 }
}
