#####################################################
#
# Programador: Emiliano Moreno Hernandez 
#
# Fecha de Creación: 25-Oct-2024
# Fecha de Modificación: 25-Oct-2024 
#
#####################################################

# access key
variable "aws_key" {
    description = "llave de acceso de AWS"
    type = string
  
}

#clave secreta 
variable "aws_secret" {
    description = "Clave secreta de AWS"
    type = string
  
}

#region de trabajo 
variable "region_aws" {
    description = "region AWS"
    default = "us-east-1"

  
}