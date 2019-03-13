package test

import (
	"fmt"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVpc(t *testing.T) {
	t.Parallel()

	awsRegion := "us-west-2"

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/test_fixture/vpc",
		Vars: map[string]interface{}{
			"project_name": fmt.Sprintf("t-%s", strings.ToLower(random.UniqueId())),
			"domain_name":  "petzold.io",
			"aws_region":   awsRegion,
			"aws_key_name": "vpc-test.pem",
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
	assert.Equal(t, awsRegion, terraform.Output(t, terraformOptions, "region"))
}
