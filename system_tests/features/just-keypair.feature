Feature: Just a keypair
  @local @single_node @keypair
  Scenario: Local deployment of just a keypair
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-keypair.yaml from template blueprints/just-keypair
    And I have inputs just-keypair-inputs.yaml from template inputs/just-keypair
    And I locally initialise blueprint just-keypair.yaml with inputs just-keypair-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 keypair(s) were created on the platform with resources prefix

  @local @single_node @keypair
  Scenario: Removing the keypair
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 keypair(s) with resources prefix were deleted from the platform
