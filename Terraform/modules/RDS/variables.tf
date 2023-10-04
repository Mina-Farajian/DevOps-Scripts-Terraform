variable "config" {
  type = object({
    environment               = string
    context                   = string
    vpc_id                    = string
    subnet_ids                = list(string)
    allocated_storage         = optional(number, 50)
    instance_class            = optional(string, "db.t3.micro")
    db_name                   = string
    db_username               = string
    db_password               = string
    db_port                   = optional(number, 5432)
    maintenance_window        = optional(string, "Mon:00:00-Mon:03:00")
    backup_window             = optional(string, "03:00-06:00")
    skip_final_snapshot       = optional(bool, false)
    backup_retention_period   = optional(number, 7)
    final_snapshot_identifier = optional(string, "final")
    engine                    = optional(string, "postgres")
    engine_version            = optional(string, "14.3")
    publicly_accessible       = optional(bool, false)
    tags                      = map(string)
    parameter_group_name      = optional(string, "")
    /*
    Possibility to attach an existing db access sg to the RDS
    */
    db_access_sg_exists = optional(bool, false)
    db_access_sg_id     = optional(string)
    monitoring_interval          = optional(number, 0)
    performance_insights_enabled = optional(bool, false)
  })
}
