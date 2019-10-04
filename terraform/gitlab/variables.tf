variable project {}
variable region {}
variable k8s-ca-cert {}
variable k8s-endpoint {}
variable k8s-access-token {}
variable tiller-service-account { default = "tiller" }
variable namespace {}

variable domain-name {}
variable dns-managed-zone {}
variable static-ip-address{}

variable sqlproxy-service-account-key {}
variable sqlproxy-instance-name {}
variable sql-database {}
variable sql-username {}
variable sql-password {}

variable redis-host {}
variable redis-port {}

variable storage-service-account-key {}
variable storage-service-account-email {}
variable registry-bucket {}
variable lfs-bucket {}
variable artifacts-bucket {}
variable uploads-bucket {}
variable packages-bucket {}
variable externaldiffs-bucket {}
variable pseudonymizer-bucket {}
variable backup-bucket {}
variable backup-tmp-bucket {}

variable cluster-issuer-filename {}
variable cluster-issuer-name {}