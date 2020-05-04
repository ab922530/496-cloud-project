# CSC 496 Cloud Computing - West Chester Universiy

<img src="https://github.com/ab922530/496-cloud-project/blob/master/images/openstack-docker.png" width="519" height="266"><img src="https://github.com/ab922530/496-cloud-project/blob/master/images/cloudlab-image.png" width="337" height="59">

## Table of Contents
  * [About :whale:](#about--whale-)
  * [Prerequisites](#prerequisites)
  * [Deployment Instructions :hammer:](#deployment-instructions--hammer-)
  * [Step-By-Step Manual Installations (Optional)](#step-by-step-manual-installations--optional-)
  * [Contributors](#contributors)
  * [FAQ](#faq)
  * [Support](#support)
  * [License](#license)
  * [References :page_with_curl:](#references--page-with-curl-)

## About :whale:
This repo is for the creation of an OpenStack profile in CloudLab that supports the inclusion of one additional compute node type that provides support for Docker virtualization in a host server.
This project will serve as an ease to launch Docker containers via OpenStack in CloudLab.
The installation and usage of this project is for educational purposes only.

## Prerequisites
Access to a cloud computing platform such as Cloudlab or Google Cloud.  
https://cloud.google.com/  
https://www.cloudlab.us/  

## Deployment Instructions :hammer:
1. At the top of this git repo, click the green *Clone or download* button and copy the git repo link.
2. In your [CloudLab](https://www.cloudlab.us/) homepage, click on the *Experiments* menu in the top blue menu bar and select *Create Experiment Profile*.
3. Name your OpenStack profile and select your project. For the source code, select *Git Repo* and paste the git repo link you copied earlier. Then *Confirm* and wait for the page to load.
4. Once the page finishes loading, click *Create* to create your OpenStack profile.
5. Navigate to your new OpenStack profile. Scroll all the way to the bottom of the webpage and *Instantiate* the master branch.
6. Click *Next* twice. Select your project if it has not already been selected. Select a cluster. Click *Next*. Click *Finish*.
7. Wait for 10 minutes for your OpenStack experiment to get created. Once it is created, you will see two nodes in the *List View* section: the controller node (ctl) and the compute node (cp-1). SSH into the compute node and run `docker version` to check that Docker is working.  
8. Once you verify that docker is running you can access to your horizon dashboard through cloudlab by nagivating to your experiment page and expanding "Profile Instructions", there you will find your password and link to your dashboard. Once you access your dashboard you will see a tab on the side labeled "Containters", enter this section and click create container.   
9. After pressing create containter add the name of your container as well as its container name or ID. Click Next and specify number of virtual cpus and amount of memory allocated to your container. Click next one more time and then click create.  
10. :tada: Congratulations! :tada: :clap: :clap: :clap: You can now deploy your own computing services in OpenStack and take advantage of the powerful containerization that Docker has to offer.

## Step-By-Step Manual Installations (Optional)
See the following links for manual Installation of Zun  
Controller Node:  
https://docs.openstack.org/zun/latest/install/controller-install.html  
Compute Node:   
https://docs.openstack.org/zun/latest/install/compute-install.html  
Verify Operation:  
https://docs.openstack.org/zun/latest/install/verify.html  
Launch a container (without the use of Horizon dashboard):  
https://docs.openstack.org/zun/latest/install/launch-container.html  

## Contributors
Austin Bramley - https://github.com/ab922530  
Akash Kumar - https://github.com/KumarUniverse  
Simeon McGraw - https://github.com/simeonjmcg  
Endri Koti -  https://github.com/EndriKCyber  
Andrew Valenci - https://github.com/avalenci

## FAQ
Q:  
What kinds of modifications were necessary in order for a proper deployment?  
A:  
The types of changes we needed to make to the configuration files were pretty minimal, but one of the most common issues was in the URLs. Our controller node was referred to http://controller:5000 when in fact our controller node was actually called http://ctl:5000.  
The same error was found in compute vs cp for our compute node.  
We realized these errors were needed when we could not properly deploy the app container service on the compute node and were receiving networking errors.  

## Support 
Thank to Dr. Linh Ngo for his expertise and support on this project

## License
GNU General Public License v2.0

## References :page_with_curl:
- [CloudLab](https://www.cloudlab.us)
- [CloudLab OpenStack default profile](https://gitlab.flux.utah.edu/johnsond/openstack-build-ubuntu)
- [Intro to OpenStack](https://www.openstack.org/software/)
[OpenStack Wikipedia page](https://en.wikipedia.org/wiki/OpenStack)
- [Intro to Docker](https://docs.docker.com/get-started/)
- [Docker documentation](https://docs.docker.com/get-docker/)
- [Install Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [Zun Wiki page](https://wiki.openstack.org/wiki/Zun)
- [Zun documentation](https://docs.openstack.org/zun/latest/)
- [Install and configure Zun in controller node](https://docs.openstack.org/zun/latest/install/controller-install.html)
- [Install and configure Zun in the compute node](https://docs.openstack.org/zun/latest/install/compute-install.html)
- [Install and configure Kuryr in the controller node](https://docs.openstack.org/kuryr-libnetwork/latest/install/controller-install.html)
- [Install and configure Kuryr in the compute node for Ubuntu](https://docs.openstack.org/kuryr-libnetwork/latest/install/compute-install-ubuntu.html)
- [Install Etcd in the controller node for Ubuntu](https://docs.openstack.org/install-guide/environment-etcd-ubuntu.html)
- [Launch a container in Zun](https://docs.openstack.org/zun/latest/install/launch-container.html)
- [OpenStack Forums](https://ask.openstack.org/)

Made with :heart: by Austin Bramley, Akash Kumar, Endri Koti, Simeon McGraw & Andrew Valenci
