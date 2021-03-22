module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "shindex-wordpress"

  engine            = "mysql"       # どのdbを使うのか
  engine_version    = "5.7.19"      # dbのバージョン
  instance_class    = "db.t2.large" # インスタンスタイプ
  allocated_storage = 5

  # dbの情報
  name     = "demodb"
  username = "user"
  password = "password"
  port     = "3306"

  # IAMアカウントからデータベースアカウントへのマッピングを有効にするかどうか
  iam_database_authentication_enabled = true

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval = "60"
  monitoring_role_name = "shindexRDSMonitoringRole"
  create_monitoring_role = true

  # このRDS用に作成したsgを適応
  vpc_security_group_ids = [aws_security_group.wordpress_db.id]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # EKSと同じsubnetsを適応
  subnet_ids = module.vpc.private_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # 削除保護機能
  deletion_protection = true

  # これより下、どういう意味があるのかまだ理解していません
  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}