## User history

As a developer
* Given I have access to the mma-fe repo in github
* Given I have access to xxx for guidance
* [x] I would like to create a Terraform powerered solution to the static site that is currently created using CloudFormation.
* [ ] I would like to use modules where possible
* [ ] I would like to document the solution using a diagram
* [x] I would like create documentation on how to run the Terraform script manually
* [x] I would like to incooperate this change as part of a continous Deployment solution using CircleCI
* [x] I would like to do this work in a separate repo
* [ ] I would like to add this solution to the mma-fe repo once code-review is complete
* [ ] I would like to deploy this solution to the development environment
* [ ] I would like to deploy this solution to the staging environment
* [ ] I would like to ensure my.dev.economist.com points to the correct cloudfront distribution
* [ ] I would like to ensure my.stage.economist.com points to the correct cloudfront distribution

<hr />

## References

The terraform cloudfront documentation can be consulted [here](https://www.terraform.io/docs/providers/aws/r/cloudfront_distribution.html). 

<hr />

## Deployment
Deploy with the following command:
```bash
terraform apply \
--var AWS_PERSONAL_ACCESS_KEY=$AWS_PERSONAL_ACCESS_KEY \
--var AWS_PERSONAL_SECRET_KEY=$AWS_PERSONAL_SECRET_KEY \
-auto-approve
```
<hr />

## Origin Access Identity

[Origin Access Identity](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html) (OAI) is a way of protecting your website origin s3 bucket from being exposed.
Instead of exposing your s3 bucket, you expose online the OAI, and it will retrieve the s3 content for you.

To see how to use Terraform the create the OIA, check [this](https://www.terraform.io/docs/providers/aws/r/cloudfront_origin_access_identity.html) page.

<hr />

## IAM policies

see [this](https://www.terraform.io/docs/providers/aws/d/iam_policy_document.html) page to use terraform to generate an IAM policy.

<hr />

## Circular dependencies
circular dependencies can be solved using a variable to reference in both dependents, as showed in the last configuration [here](https://operator-error.com/2017/02/21/managing-iam-policy-documents-in-hcl-with-terraform/).

<hr />

## Testing

* Question:
  * how should we test the successful deployment of the cloudformation app?

Note that the deployment of CF app requires around 15-20 minutes to be complete, because it must spread itself to the edge locations

<hr />

## Remaining

how to make sure my.dev.economist.com points to the correct cloudfront distribution

