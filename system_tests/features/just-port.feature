Feature: Just a port
  @local @single_node @port
  Scenario: Local deployment of just a port
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-port.yaml from template blueprints/just-port
    And I have inputs just-port-inputs.yaml from template inputs/just-port
    And I locally initialise blueprint just-port.yaml with inputs just-port-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 port(s) were created on the platform

  @local @single_node @port
  Scenario: Removing the port
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 port(s) were deleted from the platform
