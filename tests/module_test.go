package test

import (
	"fmt"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
)

/* TODO random region
func randomRegion(r []string) {
	var len = len(r)
	var key = random.RandomInt([len]int)
	return r[key]
}
*/

func TestTerraformLinodeInstanceDBPlan(t *testing.T) {
	t.Parallel()

	// Make a copy of the terraform module to a temporary directory. This allows running multiple tests in parallel
	// against the same terraform module.
	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "examples/build")

	// Give this EC2 Instance a unique ID for a name tag so we can distinguish it from any other EC2 Instance running
	// in your AWS account
	linodeRegion := "us-east"

	expectedTag := fmt.Sprintf("terratest-tag-%s", random.UniqueId())
	expectedLabel := fmt.Sprintf("terratest-instance-%s", random.UniqueId())

	// website::tag::1::Configure Terraform setting path to Terraform code, EC2 instance name, and AWS Region. We also
	// configure the options with default retryable errors to handle the most common retryable errors encountered in
	// terraform testing.
	planFilePath := filepath.Join(exampleFolder, "plan.out")
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../examples/build",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"testing_tag": expectedTag,
			"region":      linodeRegion,
			"label":       expectedLabel,
		},

		// Configure a plan file path so we can introspect the plan and make assertions about it.
		PlanFilePath: planFilePath,
	})

	// website::tag::2::Run `terraform init`, `terraform plan`, and `terraform show` and fail the test if there are any errors
	plan := terraform.InitAndPlanAndShowWithStruct(t, terraformOptions)

	// website::tag::3::Use the go struct to introspect the plan values.
	terraform.RequirePlannedValuesMapKeyExists(t, plan, "module.this")
	// instances values
	instance := plan.ResourcePlannedValuesMap["module.this.linode_instance.this"]
	//	instanceTags := instance.AttributeValues["tags"]
	instanceLabel := instance.AttributeValues["label"]

	assert.Equal(t, instanceLabel, expectedLabel)

	// website::tag::4::Alternatively, you can get the direct JSON output and use jsonpath to extract the data.
	// jsonpath only returns lists.
	//	assert.Equal(t, map[string]interface{}{"Name": expectedName}, jsonEC2Tags[0])
	// db values
	db := plan.ResourcePlannedValuesMap["module.this.linode_database_mysql.this"]
	dbLabel := db.AttributeValues["label"]
	assert.Equal(t, dbLabel, expectedLabel)
}

func TestLinodeInstanceDB(t *testing.T) {
	// Pick a random AWS region to test in. This helps ensure your code works in all regions.
	//linodeRegion := randomRegion([]string{"us-east", "ap-south"})
	linodeRegion := "us-east"

	expectedTag := fmt.Sprintf("terratest-tag-%s", random.UniqueId())
	expectedLabel := fmt.Sprintf("terratest-instance-%s", random.UniqueId())
	// retryable errors in terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/build",

		Vars: map[string]interface{}{
			"testing_tag": expectedTag,
			"region":      linodeRegion,
			"label":       expectedLabel,
		},
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	tags := terraform.Output(t, terraformOptions, "instance_tags")
	nameTag := tags[0]
	assert.Equal(t, expectedTag, nameTag)
}
