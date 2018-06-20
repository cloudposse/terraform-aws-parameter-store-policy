<!-- This file was automatically generated by the `build-harness`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

[![Cloud Posse](https://cloudposse.com/logo-300x69.png)](https://cloudposse.com)

# terraform-aws-ssm-parameter-store-policy-documents  [![Build Status](https://travis-ci.org/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.svg?branch=master)](https://travis-ci.org/cloudposse/terraform-aws-ssm-parameter-store-policy-documents) [![Latest Release](https://img.shields.io/github/release/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.svg)](https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents/releases) [![Slack Community](https://slack.cloudposse.com/badge.svg)](https://slack.cloudposse.com)


This module generates JSON documents for restricted permission sets for AWS SSM Parameter Store access.
Helpful when combined with [terraform-aws-ssm-parameter-store](https://github.com/cloudposse/terraform-aws-ssm-parameter-store)


---

This project is part of our comprehensive ["SweetOps"](https://docs.cloudposse.com) approach towards DevOps. 


It's 100% Open Source and licensed under the [APACHE2](LICENSE).








## Examples

Create a policy that allows access to write all parameters
```hcl
module "ps_policy" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.git?ref=master"
}

resource "aws_iam_policy" "ps_write" {
  name_prefix   = "write_any_parameter_store_value"
  path   = "/"
  policy = "${module.ps_policy.write_parameter_store_policy}"
}
```

Create a policy that allows managing all policies
```hcl
module "ps_policy" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.git?ref=master"
}

resource "aws_iam_policy" "ps_manage" {
  name_prefix   = "manage_any_parameter_store_value"
  path   = "/"
  policy = "${module.ps_policy.manage_parameter_store_policy}"
}
```

Create a policy that allows reading all parameters that start with a certain prefix
```hcl
module "ps_policy" {
  source              = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.git?ref=master"
  parameter_root_name = "/cp/dev/app"

}

resource "aws_iam_policy" "ps_manage" {
  name_prefix   = "write_specific_parameter_store_value"
  path   = "/"
  policy = "${module.ps_policy.manage_parameter_store_policy}"
}
```

Create a kms policy to allow decrypting of the parameter store values
```hcl
module "kms_key" {
  source                  = "git::https://github.com/cloudposse/terraform-aws-kms-key.git?ref=master"
  namespace               = "cp"
  stage                   = "prod"
  name                    = "app"
  description             = "KMS key"
  deletion_window_in_days = 10
  enable_key_rotation     = "true"
  alias                   = "alias/parameter_store_key"
}

module "ps_policy" {
  source              = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.git?ref=master"
  parameter_root_name = "/cp/dev/app"
  kms_key             = "${module.kms_key.key_arn}"

}

resource "aws_iam_policy" "ps_kms" {
  name_prefix   = "decrypt_parameter_store_value"
  path   = "/"
  policy = "${module.ps_policy.manage_kms_store_policy}"
}
```

Create a policy for another account, or region
```hcl
module "ps_policy" {
  source              = "git::https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents.git?ref=master"
  parameter_root_name = "/cp/dev/app"
  account_id          = "783649272629220"
  region              = "ap-southeast-2"

}

resource "aws_iam_policy" "ps_manage" {
  name_prefix   = "manage_any_parameter_store_value"
  path   = "/"
  policy = "${module.ps_policy.manage_parameter_store_policy}"
}
```




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account_id | The account id of the parameter store you want to allow access to. If none supplied, it uses the current account id of the provider. | string | `` | no |
| kms_key | The arn of the KMS key that you want to allow access to. If empty it uses a wildcard resource. `*` | string | `` | no |
| parameter_root_name | The prefix or root parameter that you want to allow access to. | string | `` | no |
| region | The region of the parameter store value that you want to allow access to. If none supplied, it uses the current region of the provider. | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| manage_kms_store_policy | A JSON policy document that allows decryption access to a KMS key. |
| manage_parameter_store_policy | A JSON policy document that allows full access to the parameter store. |
| put_xray_trace_policy | A JSON policy document that allows putting data into x-ray for tracing parameter store requests. |
| read_parameter_store_policy | A JSON policy document that only allows read access to the parameter store. |
| write_parameter_store_policy | A JSON policy document that only allows write access to the parameter store. |

## Makefile Targets
```
Available targets:

  help                                This help screen
  help/all                            Display help for all targets
  lint                                Lint terraform code

```



## Related Projects

Check out these related projects.

- [terraform-aws-ssm-parameter-store](https://github.com/cloudposse/terraform-aws-ssm-parameter-store) - AWS SSM Parameter Store module
- [terraform-aws-ssm-iam-role](https://github.com/cloudposse/terraform-aws-ssm-iam-role) - Terraform module to provision an IAM role with configurable permissions to access SSM Parameter Store
- [terraform-aws-kms-key](https://github.com/cloudposse/terraform-aws-kms-key) - Terraform module to provision a KMS key with alias


## Help

**Got a question?**

File a GitHub [issue](https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents/issues), send us an [email][email] or join our [Slack Community][slack].

## Commerical Support

Work directly with our team of DevOps experts via email, slack, and video conferencing. 

We provide *commercial support* for all of our [Open Source][github] projects. As a *Dedicated Support* customer, you have access to our team of subject matter experts at a fraction of the cost of a fulltime engineer. 

- **Questions.** We'll use a Shared Slack channel between your team and ours.
- **Troubleshooting.** We'll help you triage why things aren't working.
- **Code Reviews.** We'll review your Pull Requests and provide constructive feedback.
- **Bug Fixes.** We'll rapidly work to fix any bugs in our projects.
- **Build New Terraform Modules.** We'll develop original modules to provision infrastructure.
- **Cloud Architecture.** We'll assist with your cloud strategy and design.
- **Implementation.** We'll provide hands on support to implement our reference architectures. 

## Community Forum

Get access to our [Open Source Community Forum][slack] on Slack. It's **FREE** to join for everyone! Our "SweetOps" community is where you get to talk with others who share a similar vision for how to rollout and manage infrastructure. This is the best place to talk shop, ask questions, solicit feedback, and work together as a community to build *sweet* infrastructure.

## Contributing

### Bug Reports & Feature Requests

Please use the [issue tracker](https://github.com/cloudposse/terraform-aws-ssm-parameter-store-policy-documents/issues) to report any bugs or file feature requests.

### Developing

If you are interested in being a contributor and want to get involved in developing this project or [help out](https://github.com/orgs/cloudposse/projects/3) with our other projects, we would love to hear from you! Shoot us an [email](mailto:hello@cloudposse.com).

In general, PRs are welcome. We follow the typical "fork-and-pull" Git workflow.

 1. **Fork** the repo on GitHub
 2. **Clone** the project to your own machine
 3. **Commit** changes to your own branch
 4. **Push** your work back up to your fork
 5. Submit a **Pull Request** so that we can review your changes

**NOTE:** Be sure to merge the latest changes from "upstream" before making a pull request!

## Copyright

Copyright © 2017-2018 [Cloud Posse, LLC](https://cloudposse.com)


## License 

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) 

See [LICENSE](LICENSE) for full details.

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing,
    software distributed under the License is distributed on an
    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
    KIND, either express or implied.  See the License for the
    specific language governing permissions and limitations
    under the License.


## Trademarks

All other trademarks referenced herein are the property of their respective owners.

## About

This project is maintained and funded by [Cloud Posse, LLC][website]. Like it? Please let us know at <hello@cloudposse.com>

[![Cloud Posse](https://cloudposse.com/logo-300x69.png)](https://cloudposse.com)

We're a [DevOps Professional Services][hire] company based in Los Angeles, CA. We love [Open Source Software](https://github.com/cloudposse/)!

We offer paid support on all of our projects.  

Check out [our other projects][github], [apply for a job][jobs], or [hire us][hire] to help with your cloud strategy and implementation.

  [docs]: https://docs.cloudposse.com/
  [website]: https://cloudposse.com/
  [github]: https://github.com/cloudposse/
  [jobs]: https://cloudposse.com/jobs/
  [hire]: https://cloudposse.com/contact/
  [slack]: https://slack.cloudposse.com/
  [linkedin]: https://www.linkedin.com/company/cloudposse
  [twitter]: https://twitter.com/cloudposse/
  [email]: mailto:hello@cloudposse.com


### Contributors

|  [![Jamie Nelson][Jamie-BitFlight_avatar]](Jamie-BitFlight_homepage)<br/>[Jamie Nelson][Jamie-BitFlight_homepage] | [![Erik Osterman][osterman_avatar]](osterman_homepage)<br/>[Erik Osterman][osterman_homepage] | [![Sarkis Varozian][sarkis_avatar]](sarkis_homepage)<br/>[Sarkis Varozian][sarkis_homepage] |
|---|---|---|

  [Jamie-BitFlight_homepage]: https://github.com/Jamie-BitFlight
  [Jamie-BitFlight_avatar]: https://avatars0.githubusercontent.com/u/25075504?s=144&u=ac7e53bda3706cb9d51907808574b6d342703b3e&v=4
  [osterman_homepage]: https://github.com/osterman
  [osterman_avatar]: http://s.gravatar.com/avatar/88c480d4f73b813904e00a5695a454cb?s=144
  [sarkis_homepage]: https://github.com/sarkis
  [sarkis_avatar]: https://avatars3.githubusercontent.com/u/42673?s=144&v=4


