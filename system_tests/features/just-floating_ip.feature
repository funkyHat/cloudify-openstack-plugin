Feature: Just a floating_ip
  @local
  @single_node
  @floating_ip
  Scenario: Local deployment of just a floating_ip
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-floating_ip.yaml from template blueprints/just-floating_ip
    And I have inputs just-floating_ip-inputs.yaml from template inputs/just-floating_ip
    And I locally initialise blueprint just-floating_ip.yaml with inputs just-floating_ip-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 floating_ip(s) were created on the platform

  @local
  @single_node
  @floating_ip
  Scenario: Removing the floating_ip
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 floating_ip(s) were deleted from the platform
