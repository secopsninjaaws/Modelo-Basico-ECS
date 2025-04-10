# 🐳 Módulo ECS

Este módulo implementa um cluster ECS (Elastic Container Service) completo na AWS, incluindo recursos necessários para execução de containers de forma escalável e segura.

## 📋 Visão Geral

O módulo ECS cria um ambiente completo para execução de containers, incluindo:
- Cluster ECS com Fargate
- Application Load Balancer (ALB)
- ECR (Elastic Container Registry)
- Security Groups
- CloudWatch Log Group

## 🏗️ Recursos Criados

### ECS Cluster
- Cluster Fargate
- Capacity Provider configurado
- Tags personalizadas por projeto
- Integração com CloudWatch

### Application Load Balancer (ALB)
- Balanceamento de carga HTTP/HTTPS
- Listener na porta 80
- Target Group configurado
- Health checks habilitados
- Tags personalizadas por projeto

### ECR (Elastic Container Registry)
- Repositório privado
- Lifecycle policy configurada
- Tags personalizadas por projeto
- Integração com IAM

### Security Groups
- Regras de entrada para HTTP/HTTPS
- Regras de saída para internet
- Tags personalizadas por projeto
- Integração com VPC

### CloudWatch Log Group
- Retenção de logs configurada
- Tags personalizadas por projeto
- Integração com ECS

## ⚙️ Variáveis

| Nome | Tipo | Descrição | Padrão | Obrigatório |
|------|------|-----------|--------|------------|
| `project_name` | string | Nome do projeto | - | Sim |
| `ecs_cluster_name` | string | Nome do cluster ECS | - | Sim |
| `ecs_min_size` | number | Número mínimo de instâncias | 1 | Não |
| `ecs_max_size` | number | Número máximo de instâncias | 3 | Não |
| `ecs_desired_capacity` | number | Capacidade desejada | 2 | Não |

## 🔒 Segurança

### Isolamento de Recursos
- Security Groups específicos para cada componente
- Controle de acesso baseado em IAM
- ECR privado com autenticação

### Monitoramento
- Logs centralizados no CloudWatch
- Health checks no ALB
- Métricas de performance

## 🔄 Dependências

```mermaid
graph TD
    A[ECS Cluster] --> B[ALB]
    A --> C[ECR]
    A --> D[Security Groups]
    A --> E[CloudWatch Logs]
    B --> F[Target Group]
    B --> G[Listener]
    D --> H[VPC]
```

## 🚀 Uso

```hcl
module "ecs" {
  source = "./modules/ecs"
  
  project_name = "meu-projeto"
  ecs_cluster_name = "meu-cluster"
  ecs_min_size = 1
  ecs_max_size = 3
  ecs_desired_capacity = 2
}
```

## 📝 Outputs

| Nome | Descrição |
|------|-----------|
| `cluster_name` | Nome do cluster ECS |
| `listiner_arn` | ARN do listener do ALB |
| `private_subnet_ids` | IDs das subnets privadas |
| `public_subnet_ids` | IDs das subnets públicas |
| `vpc_id` | ID da VPC |

## 🛠️ Manutenção

### Atualização
```bash
terraform plan
terraform apply
```

### Destruição
```bash
terraform destroy
```

## 📌 Notas Importantes

- O módulo é projetado para alta disponibilidade
- Todos os recursos são provisionados de forma idempotente
- As configurações seguem as melhores práticas da AWS
- O ALB é criado em subnets públicas
- O ECR é configurado com lifecycle policy para limpeza automática
- Os logs são retidos por 30 dias por padrão