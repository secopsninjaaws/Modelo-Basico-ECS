# 🚀 Arquitetura de Containers na AWS

Este projeto implementa uma infraestrutura moderna na AWS para suportar uma arquitetura de containers, utilizando Terraform para provisionamento. A arquitetura é projetada para ser altamente disponível, segura e escalável.

## 📁 Estrutura do Projeto

```
.
├── modules/
│   ├── vpc/          # Módulo de rede
│   └── ecs/          # Módulo de orquestração de containers
├── app/              # Aplicação de teste containerizada
├── infra.tf          # Configuração principal
├── variables.tf      # Variáveis globais
└── terraform.tfvars  # Valores das variáveis
```

## 🏗️ Módulos

### 🌐 VPC (Virtual Private Cloud)
O módulo VPC implementa uma rede isolada e segura com:

#### Recursos Principais
- **VPC** com suporte a DNS
- **Subnets** distribuídas em múltiplas AZs
  - Subnets públicas para recursos com acesso à internet
  - Subnets privadas para recursos internos
- **Internet Gateway** para acesso à internet
- **NAT Gateway** para subnets privadas
- **Route Tables** configuradas para roteamento adequado

#### Segurança
- Isolamento de rede
- Controle de tráfego entre subnets
- Proteção contra acesso não autorizado

### 🐳 ECS (Elastic Container Service)
O módulo ECS implementa um ambiente completo para execução de containers:

#### Recursos Principais
- **Cluster ECS** configurado
- **Auto Scaling Groups** para os nós do cluster
- **Security Groups** para controle de acesso
- **IAM roles e policies** necessárias
- **ECR** para armazenamento das imagens Docker

#### Características
- Alta disponibilidade
- Escalabilidade automática
- Integração com o módulo VPC
- Logs centralizados no CloudWatch

## ⚙️ Configuração

### 📋 Variáveis

| Variável | Tipo | Descrição | Padrão |
|----------|------|-----------|--------|
| `project_name` | string | Nome do projeto | - |
| `subnets_count` | number | Número de subnets | - |
| `ecs_cluster_name` | string | Nome do cluster ECS | - |

### 🚀 Exemplo de Uso

1. **Configure as variáveis** no arquivo `terraform.tfvars`:
```hcl
project_name = "meu-projeto"
subnets_count = 3
ecs_cluster_name = "meu-cluster"
```

2. **Inicialize o Terraform**:
```bash
terraform init
```

3. **Aplique a configuração**:
```bash
terraform apply
```

## 🔒 Segurança

### 🔐 VPC
- Subnets privadas sem acesso direto à internet
- Acesso à internet via NAT Gateway
- Controle de tráfego entre subnets

### 🛡️ ECS
- Instâncias em subnets privadas
- Security Groups restritivos
- IAM com princípio de menor privilégio
- Logs centralizados

## 🛠️ Manutenção

### 🔄 Atualização
```bash
terraform plan
terraform apply
```

### 🗑️ Destruição
```bash
terraform destroy
```

## 📋 Requisitos

- Terraform >= 1.0.0
- AWS CLI configurado
- Credenciais AWS válidas
- Docker (para build/push de imagens)

## 📝 Notas

- A arquitetura é projetada para alta disponibilidade
- Todos os recursos são provisionados de forma idempotente
- As configurações seguem as melhores práticas da AWS