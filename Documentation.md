# Documentation

## Implementation and Deployment:
 - The CloudLab Openstack default profile contains set up of X compute nodes to support KVM-based VMs without support for Docker
 - **Project Primary Task:**  
   a) Augment the CloudLab Openstack default profile to support the inclusion of one additional compute node type that provides support for Docker virtualization. 
 - **Project Subtasks:**  
   a) Understand the installation scripts provided in CloudLab Openstack default profile.  
   b) Able to enable Docker support manually on an instantiation of this profile.  
   c) Able to convert the installation steps into automated scripts embedded inside the CloudLab Openstack default profile.

## Project Plan:
 1. Read and understand CloubLab OpenStack default profile.
 2. Remove unnecessary Bash scripts from the default profile.
 3. Begin local build of our Openstack profile.
 4. Check to make sure the OpenStack build, along with its core controller node, is running properly.
 5. Modify Openstack build to support an additional compute node type running the Nova hypervisor.
 6. Manually modify the Nova hypervisor to support docker virtualization.
 7. Test the local build.
 8. Move the local build to CloudLab.
 9. Automate Docker installation steps using automated scripts.
 10. Test the CloudLab OpenStack build.
 
 
## Project Repository: https://github.com/ab922530/496-cloud-project.git

## Useful Links:
- https://gitlab.flux.utah.edu/johnsond/openstack-build-ubuntu
- https://wiki.openstack.org/wiki/Docker#Configure_an_existing_OpenStack_installation_to_enable_Docker
- https://docs.openstack.org/install-guide/overview.html
- https://docs.openstack.org/python-openstackclient/latest/cli/index.html
- https://docs.docker.com/
