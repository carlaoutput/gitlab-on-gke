resource google_redis_instance gitlab {
  project = var.project
  region = var.region
  display_name = var.display-name
  memory_size_gb = var.memory-size-gb
  name = var.name
  tier = var.tier
}