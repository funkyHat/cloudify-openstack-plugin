Feature: Single VM
  @local
  Scenario: Local deployment of a single VM
    Given no tests have failed in this feature
    And I have installed cfy
    And I know what is on the platform
    When I have blueprint single-vm.yaml from template blueprints/single-vm
    And I have inputs single-vm-inputs.yaml from template inputs/single-vm
    And I locally initialise blueprint single-vm.yaml with inputs single-vm-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 server(s) were created on the platform with resources prefix
    And 1 router(s) were created on the platform with resources prefix
    And 1 network(s) were created on the platform with resources prefix
    And 1 subnet(s) were created on the platform with resources prefix
    And 1 security_group(s) were created on the platform with resources prefix
    And 1 keypair(s) were created on the platform with resources prefix
    And 1 floating_ip(s) were created on the platform

  @local
  Scenario: Removing single VM
    Given no tests have failed in this feature
    And I have installed cfy
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 server(s) with resources prefix were deleted from the platform
    And 1 router(s) with resources prefix were deleted from the platform
    And 1 network(s) with resources prefix were deleted from the platform
    And 1 subnet(s) with resources prefix were deleted from the platform
    And 1 security_group(s) with resources prefix were deleted from the platform
    And 1 keypair(s) with resources prefix were deleted from the platform
    And 1 floating_ip(s) were deleted from the platform
