# Virtual machine definition.
resource "libvirt_domain" "ubuntu" {
  for_each = var.vms

  name        = each.value.vm_hostname
  memory      = each.value.memory
  memory_unit = "GiB"
  vcpu        = each.value.vcpu
  type        = "kvm"

  cpu = {
    mode = "host-passthrough"
  }

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  devices = {
    disks = [
      {
        source = {
          volume = {
            pool   = libvirt_volume.ubuntu_disk[each.key].pool
            volume = libvirt_volume.ubuntu_disk[each.key].name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
        driver = {
          type = "qcow2"
        }
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.ubuntu_seed_volume[each.key].pool
            volume = libvirt_volume.ubuntu_seed_volume[each.key].name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
      }
    ]

    interfaces = [
      {
        type  = "network"
        model = { type = "virtio" }
        source = {
          network = {
            network = "default"
          }
        }
      }
    ]

    graphics = [
      {
        vnc = {
          auto_port = true
          listen    = "127.0.0.1"
        }
      }
    ]
  }

  running = true
}
