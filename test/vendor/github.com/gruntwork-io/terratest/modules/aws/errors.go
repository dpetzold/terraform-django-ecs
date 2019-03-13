package aws

import (
	"fmt"
)

// IpForEc2InstanceNotFound is an error that occurs when the IP for an EC2 instance is not found.
type IpForEc2InstanceNotFound struct {
	InstanceId string
	AwsRegion  string
	Type       string
}

func (err IpForEc2InstanceNotFound) Error() string {
	return fmt.Sprintf("Could not find a %s IP address for EC2 Instance %s in %s", err.Type, err.InstanceId, err.AwsRegion)
}

// HostnameForEc2InstanceNotFound is an error that occurs when the IP for an EC2 instance is not found.
type HostnameForEc2InstanceNotFound struct {
	InstanceId string
	AwsRegion  string
	Type       string
}

func (err HostnameForEc2InstanceNotFound) Error() string {
	return fmt.Sprintf("Could not find a %s hostname for EC2 Instance %s in %s", err.Type, err.InstanceId, err.AwsRegion)
}

// NotFoundError is returned when an expected object is not found
type NotFoundError struct {
	objectType string
	objectID   string
	region     string
}

func (err NotFoundError) Error() string {
	return fmt.Sprintf("Object of type %s with id %s not found in region %s", err.objectType, err.objectID, err.region)
}

func NewNotFoundError(objectType string, objectID string, region string) NotFoundError {
	return NotFoundError{objectType, objectID, region}
}

// AsgCapacityNotMetError is returned when the ASG capacity is not yet at the desired capacity.
type AsgCapacityNotMetError struct {
	asgName         string
	desiredCapacity int64
	currentCapacity int64
}

func (err AsgCapacityNotMetError) Error() string {
	return fmt.Sprintf(
		"ASG %s not yet at desired capacity %d (current %d)",
		err.asgName,
		err.desiredCapacity,
		err.currentCapacity,
	)
}

func NewAsgCapacityNotMetError(asgName string, desiredCapacity int64, currentCapacity int64) AsgCapacityNotMetError {
	return AsgCapacityNotMetError{asgName, desiredCapacity, currentCapacity}
}
