variable "iso_path" {
  type        = string
  description = "live-buildで生成したQuokka OS ISOへのパス(例: ../live-build/live-image-amd64.hybrid.iso)"
}

variable "iso_checksum" {
  type        = string
  description = "ISOのSHA256チェックサム。`sha256sum <iso>` の出力を \"sha256:<hash>\" 形式で指定"
}

variable "vm_name" {
  type    = string
  default = "quokka-os"
}

variable "disk_size_mb" {
  type    = number
  default = 40960 # 40GB
}

variable "memory_mb" {
  type    = number
  default = 4096
}

variable "cpus" {
  type    = number
  default = 2
}

variable "ssh_username" {
  type    = string
  default = "quokka"
}

variable "ssh_password" {
  type      = string
  default   = "quokka"
  sensitive = true
}
