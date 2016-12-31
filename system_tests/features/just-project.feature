Feature: Just a project
  @local @single_node @project
  Scenario: Local deployment of just a project
    Given I skip this test if openstack.can_create_tenants is false
    And I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I have blueprint just-project.yaml from template blueprints/just-project
    And I have inputs just-project-inputs.yaml from template inputs/just-project
    And I locally initialise blueprint just-project.yaml with inputs just-project-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 tenant(s) were created on the platform with resources prefix

  @local @single_node @project
  Scenario: Removing the project
    Given I skip this test if openstack.can_create_tenants is false
    And no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 tenant(s) with resources prefix were deleted from the platform
