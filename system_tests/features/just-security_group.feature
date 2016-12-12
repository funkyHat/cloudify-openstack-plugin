Feature: Just a security_group
  @local
  @single_node
  @security_group
  Scenario: Local deployment of just a security_group
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-security_group.yaml from template blueprints/just-security_group
    And I have inputs just-security_group-inputs.yaml from template inputs/just-security_group
    And I locally initialise blueprint just-security_group.yaml with inputs just-security_group-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 security_group(s) were created on the platform with resources prefix

  @local
  @single_node
  @security_group
  Scenario: Removing the security_group
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 security_group(s) with resources prefix were deleted from the platform
