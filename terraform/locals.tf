locals {
  dns_zone_name = "tfg.${var.environment}"

  ecr_reg          = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
  ecr_repo         = var.service
  image_tag        = "latest"
  ecr_docker_image = "${local.ecr_reg}/${local.ecr_repo}:${local.image_tag}"

  dkr_img_src_path   = "${path.module}/../${var.service}"
  dkr_img_src_sha256 = sha256(join("", [for f in fileset(".", "${local.dkr_img_src_path}/**") : file(f)]))

  dkr_build_cmd = <<-EOT
docker build -t ${local.ecr_docker_image} --platform linux/arm64

aws ecr get-login-password --region ${var.region} | \
  docker login --username AWS --password-stdin ${local.ecr_reg}

docker push ${local.ecr_docker_image}
EOT

  tags = {
    "Environment" = var.environment
    "Service"     = var.service
    "CreatedBy"   = "Terraform"
  }
}
