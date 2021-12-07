variable "gke_num_nodes" {
  type = number
  default     = 1
  description = "number of gke nodes in each zone"
}
variable "project_id" {
  type = string
  description = "project id"
}

variable "region" {
  type = string
  description = "region"
}
variable "airflow_webui_username" {
  type = string
  description = "airflow username for authentication with web ui" 
}
variable "airflow_webui_password" {
  type = string
  description = "airflow password for authentication with web ui"
}
variable "index_node_pool" {
    type = list(number)
    description = "indexes of node pools"
    default = [1, 2, 3]
}
variable "zones" {
    type = map(string)
    description = "all zones in the region"
    default = {
        a = "a",
        b = "b",
        c = "c"
    }
}
variable  "helm_chart_name" {
  type = string
  description = "name of chart"
  default = "airflow"
}