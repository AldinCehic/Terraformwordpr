# Variables can be used to store values used in .tf code
# Use format as shown here. Use "var.[variable name]" to use in code

variable "key" {
    default = "vockey"
}

variable "ami" {
    default = "ami-0df24e148fdb9f1d8"
}

variable "CIDR" {
    default = ["0.0.0.0/0"]
}
 