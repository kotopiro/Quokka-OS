packer {
  required_plugins {
    qemu = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/qemu"
    }
    virtualbox = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

# ---- QEMU/KVM ビルダー -> .qcow2 出力 ----
source "qemu" "quokka" {
  iso_url          = var.iso_path
  iso_checksum     = var.iso_checksum
  output_directory = "output/qemu"
  vm_name          = "${var.vm_name}.qcow2"
  format           = "qcow2"
  disk_size        = var.disk_size_mb
  memory           = var.memory_mb
  cpus             = var.cpus
  accelerator      = "kvm"

  http_directory = "http"
  boot_wait      = "5s"
  # Debianインストーラの起動画面でpreseedを自動投入するブートコマンド
  boot_command = [
    "<esc><wait>",
    "install ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "netcfg/get_hostname=quokka-os netcfg/get_domain=local ",
    "fb=false debconf/frontend=noninteractive ",
    "console-setup/ask_detect=false <enter>"
  ]

  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = "60m"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  qemuargs = [
    ["-display", "none"]
  ]
}

# ---- VirtualBox ビルダー -> .ova 出力(VirtualBox/VMware兼用として配布) ----
source "virtualbox-iso" "quokka" {
  iso_url      = var.iso_path
  iso_checksum = var.iso_checksum
  vm_name      = var.vm_name
  guest_os_type = "Debian_64"
  disk_size    = var.disk_size_mb
  memory       = var.memory_mb
  cpus         = var.cpus

  guest_additions_mode = "upload"

  http_directory = "http"
  boot_wait      = "5s"
  boot_command = [
    "<esc><wait>",
    "install ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "netcfg/get_hostname=quokka-os netcfg/get_domain=local ",
    "fb=false debconf/frontend=noninteractive ",
    "console-setup/ask_detect=false <enter>"
  ]

  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = "60m"
  shutdown_command = "echo '${var.ssh_password}' | sudo -S shutdown -P now"

  export_opts = [
    "--manifest",
    "--vsys", "0",
    "--description", "Quokka OS - Penetration Testing Distribution",
  ]
  format = "ova"
}

build {
  name = "quokka-os-vm"
  sources = [
    "source.qemu.quokka",
    "source.virtualbox-iso.quokka"
  ]

  # Guest Additions / QEMU guest agent など、VM専用の最終セットアップ
  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y qemu-guest-agent spice-vdagent",
      "sudo systemctl enable qemu-guest-agent || true"
    ]
  }
}
