Feature: Just a image
  @local @single_node @image
  Scenario: Local deployment of just a image
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I download {{openstack.external_image_url}} to image_file.data
    And I have blueprint just-image.yaml from template blueprints/just-image
    And I have inputs just-image-inputs.yaml from template inputs/just-image
    And I locally initialise blueprint just-image.yaml with inputs just-image-inputs.yaml
    And I run the local install workflow
    Then I know what has been changed on the platform
    And 1 image(s) were created on the platform with resources prefix

  @local @single_node @image
  Scenario: Removing the image
    Given no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    Then I know what has been changed on the platform
    And 1 image(s) with resources prefix were deleted from the platform
