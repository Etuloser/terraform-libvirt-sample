data "template_file" "user_data" {
  for_each = var.vms

  template = file("${path.module}/config/cloud-init.tpl.yml")

  vars = {
    vm_hostname   = each.value.vm_hostname
    root_password = var.root_password
    ssh_keys      = join("\n  - ", var.ssh_keys)
  }
}

# Base Ubuntu Linux cloud image stored in the default pool.
resource "libvirt_volume" "ubuntu_base" {
  name = "ubuntu-22.04-base.qcow2"
  pool = "default"
  target = {
    format = {
      type = "qcow2"
    }
  }
  create = {
    content = {
      url = var.ubuntu_22_img_url
    }
  }
}

# Writable copy-on-write layer for the VM.
resource "libvirt_volume" "ubuntu_disk" {
  for_each = var.vms

  name = "${each.value.vm_hostname}.qcow2"
  pool = "default"
  target = {
    format = {
      type = "qcow2"
    }
  }
  capacity      = each.value.disk
  capacity_unit = "GiB"

  backing_store = {
    path = libvirt_volume.ubuntu_base.path
    format = {
      type = "qcow2"
    }
  }
}

# Cloud-init seed ISO.
resource "libvirt_cloudinit_disk" "ubuntu_seed" {
  for_each = var.vms

  name = "${each.value.vm_hostname}-cloudinit"

  user_data = data.template_file.user_data[each.key].rendered

  meta_data = <<-EOF
    instance-id: ${each.value.vm_hostname}
    local-hostname: ${each.value.vm_hostname}
  EOF

  network_config = <<-EOF
    version: 2
    ethernets:
      enp1s0:
        dhcp4: true
        match:
          name: en*
  EOF
}

# Upload the cloud-init ISO into the pool.
resource "libvirt_volume" "ubuntu_seed_volume" {
  for_each = var.vms

  name = "${each.value.vm_hostname}-cloudinit.iso"
  pool = "default"

  create = {
    content = {
      url = libvirt_cloudinit_disk.ubuntu_seed[each.key].path
    }
  }
}
