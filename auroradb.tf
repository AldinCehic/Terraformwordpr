# Resources required for setting up Aurora MySQL with two DB instances

# when trying to log into the database later on, be sure to use this master_user/pass
# the log in data originating from the shell script is only valid on the EC2 itself

###################
#   !Important!   #
###################

# to access MySQL on EC2
# mysql --user='wordpressuser' --password='pass'

# to access MySQL on AuroraDB
# mysql --user='test' --password='mustbeeightcharaters' \
# <copy/paste Writer instance endpoint here>

resource "aws_rds_cluster" "auroracluster" {
  cluster_identifier        = "auroracluster"
  availability_zones        = ["us-west-2a", "us-west-2b"]

  engine                    = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.11.1"
  
  database_name             = "auroradb"
  master_username           = "test"
  master_password           = "mustbeeightcharaters"

  skip_final_snapshot       = true
  final_snapshot_identifier = "aurora-final-snapshot"

  db_subnet_group_name = aws_db_subnet_group.db_subnet.id

  vpc_security_group_ids = [aws_security_group.allow_aurora_access.id]

  tags = {
    Name = "auroracluster-db"
  }
}

resource "aws_rds_cluster_instance" "clusterinstance" {
  count              = 2
  identifier         = "clusterinstance-${count.index}"
  cluster_identifier = aws_rds_cluster.auroracluster.id
  instance_class     = "db.t3.small"
  engine             = "aurora-mysql"
  availability_zone  = "us-west-2${count.index == 0 ? "a" : "b"}"

  tags = {
    Name = "auroracluster-db-instance${count.index + 1}"
  }
}


