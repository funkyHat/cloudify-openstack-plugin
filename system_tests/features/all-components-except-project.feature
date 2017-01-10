Feature: All components except project
  @local @multi_node @all_components
  Scenario: Local deployment of all components except project
    Given I skip this test if openstack.can_create_tenants is true
    And I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform
    When I download {{openstack.external_image_url}} to image_file.data
    And I have blueprint all-components-except-project.yaml from template blueprints/all-components-except-project
    And I have inputs all-components-except-project-inputs.yaml from template inputs/all-components-except-project
    And I have script scripts/test_disk.py from template scripts/test_disk.py
    And I pip install https://github.com/cloudify-cosmo/cloudify-fabric-plugin/archive/1.3-build.zip
    And I locally initialise blueprint all-components-except-project.yaml with inputs all-components-except-project-inputs.yaml
    And I run the local install workflow
    Then I confirm that local output script_success is True
    And I know what has been changed on the platform
    And 1 floating_ip(s) were created on the platform
    And 1 image(s) were created on the platform with resources prefix
    And 1 keypair(s) were created on the platform with resources prefix
    And 1 network(s) were created on the platform with resources prefix
    And 5 port(s) were created on the platform
    And 1 router(s) were created on the platform with resources prefix
    And 1 security_group(s) were created on the platform with resources prefix
    And 1 server(s) were created on the platform with resources prefix
    And 1 subnet(s) were created on the platform with resources prefix
    And 1 volume(s) were created on the platform with resources prefix

  @local @multi_node @all_components
  Scenario: Local undeployment of all components except project
    Given I skip this test if openstack.can_create_tenants is true
    And no tests have failed in this feature
    And I know what is on the platform
    When I run the local uninstall workflow
    # Volume deletion can take a little time to register on packstack test environments
    Then I wait 3 seconds
    And I know what has been changed on the platform
    And 1 floating_ip(s) were deleted from the platform
    And 1 image(s) with resources prefix were deleted from the platform
    And 1 keypair(s) with resources prefix were deleted from the platform
    And 1 network(s) with resources prefix were deleted from the platform
    And 5 port(s) were deleted from the platform
    And 1 router(s) with resources prefix were deleted from the platform
    And 1 security_group(s) with resources prefix were deleted from the platform
    And 1 server(s) with resources prefix were deleted from the platform
    And 1 subnet(s) with resources prefix were deleted from the platform
    And 1 volume(s) with resources prefix were deleted from the platform
