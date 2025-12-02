variable "db_name" {
  description = "Nom de la base de données PostgreSQL."
  type        = string
  default     = "devops_db"
}

variable "db_user" {
  description = "Nom d'utilisateur PostgreSQL."
  type        = string
  default     = "devops_user1"
}

variable "db_password" {
  description = "Mot de passe PostgreSQL (Simulé, ne pas utiliser en prod)."
  type        = string
  default     = "strongpassword123"
  sensitive   = true
}

variable "app_port_external" {
  description = "Port externe pour l'application (map sur 80 interne)."
  type        = number
  default     = 8082
}
