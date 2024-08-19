# Desafío DevOps Finaktiva - Clúster Fargate en AWS

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
- Pipelines de CI/CD para tres ambientes en diferentes regiones de AWS

## Estructura del Proyecto

```
.
├── .github/
│   └── workflows/
│       ├── dev-deploy.yml
│       ├── staging-deploy.yml
│       ├── prod-deploy.yml
│       ├── dev-destroy.yml
│       ├── staging-destroy.yml
│       └── prod-destroy.yml
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

## Justificación de Herramientas

### Terraform vs AWS CDK

Elegimos Terraform sobre AWS CDK por las siguientes razones:

- **Ventajas de Terraform:**
  - Soporte multi-cloud, permitiendo mayor flexibilidad a futuro
  - Sintaxis declarativa más intuitiva para definir infraestructura
  - Gran comunidad y amplia documentación
  - Estado de infraestructura gestionado, facilitando el trabajo en equipo

- **Desventajas:**
  - Menor integración nativa con servicios AWS comparado con CDK
  - Curva de aprendizaje inicial para quienes están más familiarizados con lenguajes de programación tradicionales

### GitHub Actions para CI/CD

Elegimos GitHub Actions por:

- Integración nativa con el repositorio de código
- Configuración sencilla en YAML
- Amplia variedad de acciones predefinidas
- Ejecución en la nube sin necesidad de mantenimiento de servidores

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

### Justificación de la Arquitectura

Se eligió utilizar dos servicios ECS separados, cada uno con su propia tarea, por las siguientes razones:

- **Ventajas:**
  - Mayor aislamiento entre aplicaciones
  - Capacidad de escalar y gestionar cada aplicación de forma independiente
  - Facilita la implementación de diferentes estrategias de despliegue por aplicación

- **Desventajas:**
  - Puede resultar en un mayor uso de recursos si las aplicaciones son pequeñas

## Estrategias de Despliegue

1. **Rolling Update (Implementada):**
   - Ventajas: Mínimo tiempo de inactividad, despliegue gradual
   - Desventajas: Puede ser lento para aplicaciones grandes
   - Uso: Ideal para aplicaciones stateless con alta disponibilidad
   - Implementación: Configurada en los servicios ECS en `main.tf`

2. **Blue/Green Deployment (Propuesta):**
   - Ventajas: Fácil rollback, pruebas en producción
   - Desventajas: Requiere más recursos durante el despliegue
   - Uso: Recomendado para aplicaciones críticas que requieren pruebas exhaustivas
   - Implementación: Requeriría modificar la configuración de ECS y posiblemente usar AWS CodeDeploy

Para implementar Blue/Green, se necesitaría:
1. Crear un nuevo Target Group en el ALB
2. Desplegar la nueva versión de la aplicación en un nuevo set de tareas
3. Redirigir el tráfico al nuevo Target Group
4. Mantener la versión antigua por un tiempo antes de eliminarla

## Seguridad

- Acceso HTTPS (puerto 443) configurado en el ALB
- Certificados SSL/TLS gestionados a través de ACM
- Grupos de seguridad con acceso limitado a IPs específicas (configurable en `*.auto.tfvars`)
- Tareas ECS ejecutándose en subredes privadas sin IPs públicas
- IAM roles con mínimos permisos necesarios para las tareas ECS

## Alta Disponibilidad y Escalado

- Aplicaciones desplegadas en múltiples zonas de disponibilidad
- Auto-escalado configurado basado en uso de CPU y memoria
- Healthchecks implementados en el ALB y las tareas ECS
- Circuit breaker configurado en los servicios ECS para manejar fallos

## Monitoreo y Logs

- CloudWatch Logs configurado para los contenedores ECS
- Métricas de CloudWatch utilizadas para el auto-scaling
- Container Insights habilitado en el clúster ECS para monitoreo avanzado

## Pruebas

Para garantizar el correcto funcionamiento de la infraestructura, sigue estos pasos:

1. Verifica la creación de recursos:
   ```
   terraform show
   ```

2. Comprueba la accesibilidad de las aplicaciones:
   ```
   curl -k https://<ALB_DNS_NAME>
   curl -k https://<ALB_DNS_NAME>/app2
   ```

3. Prueba el escalado automático:
   - Aumenta la carga en las aplicaciones
   - Verifica en la consola de ECS que se crean nuevas tareas

4. Verifica la seguridad:
   ```
   nmap -p 443 <ALB_DNS_NAME>
   ```

5. Comprueba los logs:
   - Revisa los grupos de logs en CloudWatch

6. Prueba de failover:
   - Detén una tarea manualmente y verifica que se crea una nueva automáticamente

Estos pasos proporcionan una forma repetible de verificar que la infraestructura funciona según lo esperado.

## CI/CD

Los pipelines de CI/CD están implementados usando GitHub Actions. Hay workflows separados para cada ambiente:

- `dev-deploy.yml`: Despliega en el ambiente de desarrollo (us-east-1)
- `staging-deploy.yml`: Despliega en el ambiente de staging (us-east-2)
- `prod-deploy.yml`: Despliega en el ambiente de producción (us-west-2)

Cada pipeline incluye los siguientes pasos:
1. Checkout del código
2. Configuración de credenciales AWS
3. Instalación y configuración de Terraform
4. Inicialización de Terraform
5. Planificación de Terraform
6. Aplicación de cambios 

Además, hay workflows de destroy para cada ambiente que requieren confirmación manual antes de ejecutarse.

## Solución de Problemas

Si encuentras problemas durante el despliegue o la ejecución:
1. Verifica los logs de CloudWatch para los servicios ECS.
2. Comprueba el estado de las tareas en la consola de ECS.
3. Revisa las configuraciones de red y seguridad en la VPC y grupos de seguridad.
4. Asegúrate de que las imágenes de los contenedores estén correctamente etiquetadas y disponibles en ECR.

## Contacto

Para cualquier pregunta o comentario, por favor contacta a [josem.vanegasa@gmail.com].
