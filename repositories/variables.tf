variable "repository_name" {}
variable "description" {
  default = ""
}
variable "visibility" {
  default = "public"
}
variable "main_branch" {
  default = "main"
}
variable "checks" {
  default = []
}
variable "secrets" {
  default = {}
}

variable "dependabot_secrets" {
  default = {}
}

variable "collaborators" {
  type    = set(string)
  default = []
}
variable "language" {
  description = "Used to generate a .gitignore template"
}
