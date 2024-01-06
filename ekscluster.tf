
provider "kubernetes" {
    load_config_file = "false"
    host = data.aws_eks_cluster.ekscluster.endpoint
    token = data.aws_eks_cluster.ekscluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.ekscluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "ekscluster" {
        name = module.eks.cluster.id
}

data "aws_eks_cluster_auth" "ekscluster" {
    name = module.eks.cluster.id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "13.2.1"
  # insert the 7 required variables here

  cluster_name = "ekscluster"
  cluster_version = "1.27"

  subnets = module.myapp-vpc.private_subnets
  vpc_id = module.myapp-vpc.vpc.id

  tags = {
    environment = "development"
    application = "myapp"
  }

  worker_groups = [
    {
            instance_type = "t2.small"
            name = "worker-group-1"
            asg_desired_capacity = 2
    },
    {
            instance_type = "t2.medium"
            name = "worker-group-2"
            asg_desired_capacity = 2

    }

  ]
    

}