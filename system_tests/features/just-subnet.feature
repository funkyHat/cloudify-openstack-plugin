Feature: Just a subnet
  @local @single_node @subnet
  Scenario: Local deployment of just a subnet
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-subnet.yaml from template blueprints/just-subnet
    And I have inputs just-subnet-inputs.yaml from template inputs/just-subnet
    And I locally initialise blueprint just-subnet.yaml with inputs just-subnet-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 subnet(s) were created on the platform with resources prefix

  @local @single_node @subnet
  Scenario: Removing the subnet
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 subnet(s) with resources prefix were deleted from the platform
