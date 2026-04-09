# Outputs to help locate the VMs
output "vm_ids" {
  value       = { for k, v in libvirt_domain.ubuntu : k => v.id }
  description = "Domain IDs for all VMs"
}

output "vm_hostnames" {
  value       = { for k, v in libvirt_domain.ubuntu : k => v.name }
  description = "Hostnames for all VMs"
}

output "vm_memory" {
  value       = { for k, v in var.vms : k => v.memory }
  description = "Memory allocation for all VMs (GiB)"
}

output "vm_vcpu" {
  value       = { for k, v in var.vms : k => v.vcpu }
  description = "VCPU count for all VMs"
}

output "vm_disk" {
  value       = { for k, v in var.vms : k => v.disk }
  description = "Disk size for all VMs (GiB)"
}

output "instructions" {
  value     = <<-EOF

    Virtual machines have been created!

    VMs: ${join(", ", [for k, v in var.vms : v.vm_hostname])}

    To find IP addresses assigned by DHCP for each VM:
    ${join("\n", [for k, v in var.vms : "sudo virsh domifaddr ${v.vm_hostname}"])}

    Or check the DHCP leases:
      sudo virsh net-dhcp-leases default

    To connect via SSH (once you know the IP):
      ssh root@<IP-ADDRESS>
      Password: ${var.root_password}

    To view VM console:
    ${join("\n", [for k, v in var.vms : "sudo virsh console ${v.vm_hostname}"])}

    To connect via VNC:
      1. Find VNC port: sudo virsh domdisplay <VM_HOSTNAME>
      2. Connect with VNC client to that address

    Note: It may take 30-60 seconds after boot for cloud-init to complete
          and the SSH server to be available.
  EOF
  sensitive = true
}