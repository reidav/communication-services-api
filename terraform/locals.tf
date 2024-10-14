locals {
  resource_suffix                = [lower(var.environment), lower(var.region), lower(var.domain), lower(var.workload), random_id.resource_group_name_suffix.hex]
  resource_suffix_kebabcase      = join("-", local.resource_suffix)
  resource_suffix_lowercase      = join("", local.resource_suffix)

  resource_group_name = coalesce(
    try(data.azurerm_resource_group.this[0].name, null),
    try(azurerm_resource_group.this[0].name, null)
  )
  resource_group_location = coalesce(
    try(data.azurerm_resource_group.this[0].location, null),
    try(azurerm_resource_group.this[0].location, null)
  )

  function_name = format("func-%s", local.resource_suffix_kebabcase)
  
  tags = merge(
    var.tags,
    tomap(
      {
        "Environment" = var.environment,
        "Domain"      = var.domain,
        "Deployment"  = "Terraform"
      }
    )
  )
}
