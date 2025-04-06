# Arquitetura de Containers na AWS

Este projeto implementa uma infraestrutura na AWS para suportar uma arquitetura de containers, utilizando Terraform para provisionamento.

## Estrutura do Projeto

```
.
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ecs/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── app/
│   ├── Dockerfile
│   └── index.html
├── infra.tf
├── variables.tf
└── terraform.tfvars
```

## Módulos

### VPC
O módulo VPC cria uma infraestrutura de rede completa com:
- VPC com suporte a DNS
- Subnets públicas e privadas distribuídas em múltiplas AZs
- Internet Gateway para acesso à internet
- NAT Gateway para subnets privadas
- Route tables configuradas para roteamento adequado

### ECS (Elastic Container Service)
O módulo ECS implementa um ambiente completo para execução de containers com:
- Cluster ECS configurado
- Auto Scaling Groups para os nós do cluster
- Security Groups para controle de acesso
- IAM roles e policies necessárias
- Integração com o módulo VPC para networking
- ECR (Elastic Container Registry) para armazenamento das imagens Docker

## Aplicação de Teste

A pasta `app/` contém uma aplicação simples de teste que foi containerizada e subida para o ECR:

### Estrutura da Aplicação
- `Dockerfile`: Define a imagem base (nginx) e copia o arquivo index.html
- `index.html`: Página HTML simples para teste

### Build e Push da Imagem
Para construir e enviar a imagem para o ECR:

1. Autentique-se no ECR:
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789012.dkr.ecr.us-east-1.amazonaws.com
```

2. Construa a imagem:
```bash
docker build -t minha-app:latest ./app
```

3. Tag da imagem para o ECR:
```bash
docker tag minha-app:latest 123456789012.dkr.ecr.us-east-1.amazonaws.com/minha-app:latest
```

4. Push para o ECR:
```bash
docker push 123456789012.dkr.ecr.us-east-1.amazonaws.com/minha-app:latest
```

## Configuração

### Variáveis

| Nome | Tipo | Descrição | Padrão |
|------|------|-----------|--------|
| project_name | string | Nome do projeto | - |
| subnets_count | number | Número de subnets públicas/privadas a serem criadas | - |
| ecs_cluster_name | string | Nome do cluster ECS | - |

### Exemplo de Uso

1. Configure as variáveis no arquivo `terraform.tfvars`:
```hcl
project_name = "meu-projeto"
subnets_count = 3
ecs_cluster_name = "meu-cluster"
```

2. Utilizando o modulo vpc

```
module "vpc" {
  source        = "./modules/vpc"
  project_name  = var.project_name
  subnets_count = var.subnets_count
}
```

3. Utilizando o modulo ecs
```
locals {
  services = {
    ################################################ Service Configuration ################################################
    "service1" = {
      service_name          = "service1"
      service_cpu           = 256
      service_memory        = 512
      service_desired_count = 2
      service_max_count     = 5
      service_min_count     = 1
      service_port          = 80
      vpc_id                = module.vpc.vpc_id
      private_subnets       = module.vpc.private_subnet_ids
      alb_listener_arn      = module.vpc.listiner_arn
      host_name             = "service1.dev.selectsolucoes.com"

      ############# HEALTH CHECK
      path_health_check = {
        healthy_threshold   = 2
        interval            = 30
        timeout             = 15
        unhealthy_threshold = 2
        path                = "/"
        port                = 80
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      ############ SECURITY GROUPS 
      security_group_rules = {
        HTTPS = {
          type        = "ingress"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        HTTP = {
          type        = "ingress"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    ################################################ Service Configuration ################################################
  }
}

module "service" {
  source   = "./modules/ecs"
  for_each = local.services

  service_name          = each.value.service_name
  service_cpu           = each.value.service_cpu
  service_memory        = each.value.service_memory
  service_desired_count = each.value.service_desired_count
  service_max_count     = each.value.service_max_count
  service_min_count     = each.value.service_min_count
  service_port          = each.value.service_port
  project_name          = var.project_name
  vpc_id                = each.value.vpc_id
  private_subnets       = each.value.private_subnets
  alb_listener_arn      = each.value.alb_listener_arn
  security_group_rules = {
    for k, v in each.value.security_group_rules : k => {
      type        = v.type
      from_port   = v.from_port
      to_port     = v.to_port
      protocol    = v.protocol
      cidr_blocks = v.cidr_blocks
    }
  }
  host_name = each.value.host_name

}

```