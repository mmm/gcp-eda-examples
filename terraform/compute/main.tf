#
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

locals {
  region = join("-", slice(split("-", var.zone), 0, 2))
}

provider "google" {
  project = var.project
  region  = local.region
}

module "slurm_cluster" {
  source = "../modules/slurm-gcp/tf/modules/cluster"

  cluster_name                  = "g1"
  project = var.project
  zone = var.zone
  #network_name = "default"

  # login_node_count              = 1

  # Optional network storage fields
  # network_storage is mounted on all instances
  # login_network_storage is mounted on controller and login instances
  # network_storage = [{
  #   server_ip     = "<storage host>"
  #   remote_mount  = "/home"
  #   local_mount   = "/home"
  #   fs_type       = "nfs"
  #   mount_options = null
  # }]

  partitions = [
    { name                 = "debug"
      machine_type         = "n1-standard-2"
      static_node_count    = 0
      max_node_count       = 10
      zone                 = "us-west1-a"
      compute_disk_type    = "pd-standard"
      compute_disk_size_gb = 20
      compute_labels       = {}
      cpu_platform         = null
      gpu_count            = 0
      gpu_type             = null
      network_storage      = []
      preemptible_bursting = true
      vpc_subnet           = null
    },
  ]
}
