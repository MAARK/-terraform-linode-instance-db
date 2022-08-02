package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

/* TODO random region
func randomRegion(r []string) {
	var len = len(r)
	var key = random.RandomInt([len]int)
	return r[key]
}
*/

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

}
