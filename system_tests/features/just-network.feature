Feature: Just a network
  @local
  @single_node
  @network
  Scenario: Local deployment of just a network
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-network.yaml from template blueprints/just-network
    And I have inputs just-network-inputs.yaml from template inputs/just-network
    And I locally initialise blueprint just-network.yaml with inputs just-network-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 network(s) were created on the platform with resources prefix

  @local
  @single_node
  @network
  Scenario: Removing the network
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 network(s) with resources prefix were deleted from the platform
