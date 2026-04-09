variable "ubuntu_22_img_url" {
  description = "Path or URL to the Ubuntu image"
  default     = "/root/workspace/terraform-libvirt-sample/script/jammy-server-cloudimg-amd64.img"
}

variable "ssh_keys" {
  description = "List of authorized SSH public keys"
  type        = list(string)
  default = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC5Fhxh3KgDQ8NNa5Bbn6RE2eDNDAZuDTQOMLU4M8FOGTb/PeFDfMQ2ACy2XdadPsmntGngOwNijFWIFs+aAP8jO01q2AJQ30ORdt193mtW8RxEn2jJFZiWfMEBla48MTaDQdUQtzH4qB4WgzIN173oDG6UnSxdiKJoIN0bHocAIQ/GDPPRYmn0eCJpknlwHUxUYnOmWJBimwxylazKzwJhCov4gGfQeB1bAyybG4vjDtz4K+se83sBQkpd98XFbeRIAUJOQXDaYXX9VTH9EOE78vC+HB95KpryY5/GuHEodMgOgKUp7DdQPdprh5u9J/yQWcGcENYOqfa8RDum2VKbqMiGOJBltVsEQ1s1AlzDWkdgs4fkwX+gYd9/9SuC9sP8f4FeJEf3UmahGR7tKX25SQ6I2C22LHREQoRb0yHLLW+h8wS+qfhPQ61zhnq3/WRjJdHH+UmFOWduc+CDX9IbtoIy8j+aoJHld4VTln59JFS83Ek9GXeaTw3yaBLg1oM= root@e-lab"
  ]
}

variable "root_password" {
  description = "Root password for VMs"
  type        = string
  default     = "123456"
  sensitive   = true
}

variable "vms" {
  description = "Map of VM configurations"
  type = map(object({
    vm_hostname = string
    memory      = number #GB
    vcpu        = number
    disk        = number #GB
  }))
  default = {
    "vm1" = {
      vm_hostname = "k8s-node1"
      memory      = 8
      vcpu        = 4
      disk        = 100
    },
    "vm2" = {
      vm_hostname = "k8s-node2"
      memory      = 4
      vcpu        = 2
      disk        = 50
    },
    "vm3" = {
      vm_hostname = "k8s-node3"
      memory      = 2
      vcpu        = 2
      disk        = 50
    },
  }
}
