Feature: Just a router
  @local
  @single_node
  @router
  Scenario: Local deployment of just a router
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-router.yaml from template blueprints/just-router
    And I have inputs just-router-inputs.yaml from template inputs/just-router
    And I locally initialise blueprint just-router.yaml with inputs just-router-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 router(s) were created on the platform with resources prefix

  @local
  @single_node
  @router
  Scenario: Removing the router
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 router(s) with resources prefix were deleted from the platform
