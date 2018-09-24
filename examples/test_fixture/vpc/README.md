<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Test fixture of simple VPC](#test-fixture-of-simple-vpc)
  - [Usage](#usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Test fixture of simple VPC

Configuration in this directory creates a set of VPC resources to be tested by test kitchen.

There is a public and private subnet created per availability zone in addition to single NAT Gateway shared between 2 availability zones.

## Usage

To run the tests, from the repo root execute:

```bash
$ kitchen test
...
Finished in 4.25 seconds (files took 2.75 seconds to load)
20 examples, 0 failures

       Finished verifying <default-aws> (0m9.03s).
-----> Kitchen is finished. (0m9.40s)
```

This will destroy any existing test resources, create the resources afresh, run the tests, report back, and destroy the resources.
