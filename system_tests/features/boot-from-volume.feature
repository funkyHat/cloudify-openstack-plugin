Feature: Boot From Volume

  @local @volume @server
  Scenario: Local deployment of server with boot from Volume
    Given I have installed cfy
    And I have installed the plugin locally
    And I know what is on the platform

    When I download {{openstack.external_image_url}} to image_file.img
    And I have blueprint boot-from-volume.yaml from template blueprints/boot-from-volume.yaml
    And I have inputs boot-from-volume-inputs.yaml from template inputs/boot-from-volume
    And I have script scripts/test_boot_volume.py from template scripts/test_boot_volume.py
    And I pip install https://github.com/cloudify-cosmo/cloudify-fabric-plugin/archive/1.3-build.zip
    And I locally initialise blueprint boot-from-volume.yaml with inputs boot-from-volume-inputs.yaml
    And I run the local install workflow

    Then I know what has been changed on the platform
    And 1 volume(s) were created on the platform with resources prefix
    And 1 server(s) were created on the platform with resources prefix
    And I confirm that local output os_distro is Linux cirros
