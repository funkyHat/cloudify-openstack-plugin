Feature: Just a server
  @local
  @single_node
  @server
  Scenario: Local deployment of just a server
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-server.yaml from template blueprints/just-server
    And I have inputs just-server-inputs.yaml from template inputs/just-server
    And I locally initialise blueprint just-server.yaml with inputs just-server-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 server(s) were created on the platform with resources prefix

  @local
  @single_node
  @server
  Scenario: Removing the server
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 server(s) with resources prefix were deleted from the platform
