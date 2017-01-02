Feature: Just a volume
  @local @single_node @volume
  Scenario: Local deployment of just a volume
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-volume.yaml from template blueprints/just-volume
    And I have inputs just-volume-inputs.yaml from template inputs/just-volume
    And I locally initialise blueprint just-volume.yaml with inputs just-volume-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 volume(s) were created on the platform with resources prefix

  @local @single_node @volume
  Scenario: Removing the volume
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    # Volume deletion can take a little time to register on packstack test environments
    Then I wait 3 seconds
    And I know what has been changed on the platform
    And 1 volume(s) with resources prefix were deleted from the platform
