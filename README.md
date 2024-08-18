# Prueba DevOps Finaktiva - Clúster Fargate en AWS

## Descripción del Proyecto

Este proyecto implementa un clúster de Fargate en AWS utilizando ECS y ECR, siguiendo las mejores prácticas de Infraestructura como Código (IaC) y CI/CD. El objetivo es crear una infraestructura escalable y segura para alojar dos aplicaciones en contenedores, accesibles públicamente a través de HTTPS, con despliegues en tres ambientes diferentes: desarrollo, staging y producción.

## Características Principales

- Clúster Fargate en AWS ECS con ECR
- VPC y subredes personalizadas para cada ambiente
- Dos aplicaciones en contenedores con servicios ECS separados
- Acceso público a través de HTTPS mediante Application Load Balancer (ALB)
- Seguridad y control de acceso por IP
- Alta disponibilidad y autoescalado configurado
- Backend de Terraform en S3 con bloqueo en DynamoDB

## Estructura del Proyecto

```
.
├── .github/
│   └── workflows/
│       └── (archivos de workflows de GitHub Actions)
├── .terraform/
├── .gitignore
├── backend.tf
├── dev.auto.tfvars
├── main.tf
├── outputs.tf
├── prod.auto.tfvars
├── providers.tf
├── README.md
├── staging.auto.tfvars
├── variables.tf
└── versions.tf
```

## Requisitos Previos

- Cuenta de AWS con permisos adecuados
- AWS CLI configurado
- Terraform instalado (versión 1.0.0 o superior)
- Git

## Configuración y Despliegue

1. Clonar el repositorio:
   ```
   git clone https://github.com/Relight0/pruebadevopsfinaktiva.git
   cd pruebadevopsfinaktiva
   ```

2. Configurar el backend de Terraform:
   El proyecto utiliza un backend S3 con bloqueo en DynamoDB. Asegúrate de que el bucket S3 y la tabla DynamoDB existan antes de inicializar Terraform.

3. Inicializar Terraform:
   ```
   terraform init
   ```

4. Seleccionar el ambiente a desplegar modificando el archivo de variables correspondiente:
   - `dev.auto.tfvars` para desarrollo (región: us-east-1)
   - `staging.auto.tfvars` para staging (región: us-east-2)
   - `prod.auto.tfvars` para producción (región: us-west-2)

5. Planificar y aplicar los cambios:
   ```
   terraform plan -var-file=<environment>.auto.tfvars
   terraform apply -var-file=<environment>.auto.tfvars
   ```

## Arquitectura de la Solución

- **VPC y Subredes**: Cada ambiente tiene su propia VPC con subredes públicas y privadas en dos zonas de disponibilidad.
- **ECS Cluster**: Un clúster de Fargate para alojar los servicios.
- **Servicios ECS**: Dos servicios ECS separados, cada uno con su propia tarea y definición de tarea.
- **Load Balancer**: Un ALB para dirigir el tráfico HTTPS a los servicios.
- **Auto Scaling**: Configurado para ambos servicios basado en uso de CPU y memoria.
- **Seguridad**: Grupos de seguridad para el ALB y las tareas ECS, restringiendo el acceso según sea necesario.

## Estrategias de Despliegue

El proyecto implementa una estrategia de despliegue Rolling Update para los servicios ECS, que se puede observar en la configuración de los servicios en `main.tf`. Esta estrategia permite actualizaciones graduales con mínimo tiempo de inactividad.

Para implementar una estrategia Blue/Green, se necesitaría modificar la configuración de los servicios ECS y posiblemente utilizar CodeDeploy de AWS.

## Seguridad

- Acceso HTTPS (puerto 443) configurado en el ALB
- Certificados SSL/TLS gestionados a través de ACM
- Grupos de seguridad con acceso limitado
- Tareas ECS ejecutándose en subredes privadas sin IPs públicas

## Monitoreo y Logs

- CloudWatch Logs configurado para los contenedores ECS
- Métricas de CloudWatch utilizadas para el auto-scaling