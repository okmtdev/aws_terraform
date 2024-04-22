variable "environment" {
  default = "sandbox"
}

variable "zone_id" {
  default = "Z06637531YBCMH55FF8KU" # okmtdev.com
}

variable "attributes" {
  description = "A list of attributes to be used by the DynamoDB table"
  type = list(object({
    name = string
    type = string
  }))
  default = [
    {
      name = "UserId",
      type = "S"
    },
    {
      name = "GameTitle",
      type = "S"
    }
  ]
}
