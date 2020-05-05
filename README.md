# CSC 496 Cloud Computing - West Chester Universiy

<img src="https://github.com/ab922530/496-cloud-project/blob/master/images/openstack-docker.png" width="519" height="266"><img src="https://github.com/ab922530/496-cloud-project/blob/master/images/cloudlab-image.png" width="337" height="59">

## Table of Contents
  * [About :whale:](#about--whale-)
  * [Prerequisites](#prerequisites)
  * [Deployment Instructions :hammer:](#deployment-instructions--hammer-)
  * [Step-By-Step Manual Installations (Optional)](#step-by-step-manual-installations--optional-)
  * [Contributors :people_holding_hands:](#contributors--people-holding-hands-)
  * [FAQ :question:](#faq--question-)
  * [Support :pray:](#support--pray-)
  * [License :balance_scale:](#license--balance-scale-)
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
8. Once you verify that Docker is running, you can access your Horizon dashboard through cloudlab by navigating to your experiment page and expanding *Profile Instructions*. There you will find your password and link to your dashboard. Once you access your dashboard, you will see a tab on the side labeled *Containers*. Enter this section and click *Create Container*.   
9. After that, add the name of your container as well as its container name or ID. Click *Next* and specify the number of virtual CPUs and amount of memory you want allocated to your container. Click *Next* one more time and then click *Create*.  
10. :tada: Congratulations! :tada: :clap: :clap: :clap: You can now deploy your own cloud computing services in OpenStack and take advantage of the powerful containerization that Docker has to offer.

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

## Contributors :people_holding_hands:
Austin Bramley - https://github.com/ab922530  
Akash Kumar - https://github.com/KumarUniverse  
Simeon McGraw - https://github.com/simeonjmcg  
Endri Koti -  https://github.com/EndriKCyber  
Andrew Valenci - https://github.com/avalenci

## FAQ :question:
**Q1:**  
What kinds of modifications were necessary in order for a proper deployment?  
**A:**  
The types of changes we needed to make to the configuration files were pretty minimal, but one of the most common issues was in the URLs. Our controller node was referred to http://controller:5000 when in fact our controller node was actually called http://ctl:5000.  
The same error was found in compute vs cp for our compute node.  
We realized these errors were needed when we could not properly deploy the app container service on the compute node and were receiving networking errors.

**Q2:**  
In your opinion, what is the most valuable skill you learned from doing this?  
**A:**  
*Akash Kumar*: Hello! The most valuable skill we learned from doing this project is the ability to research project requirements and errors to find the simplest solution that works. If you don't know what the problem is, then it can be quite hard or even impossible to fix it. So being able to identify the problem in the first place can prove to be a great help.  
*Austin Bramley*: I think the most valuable skill I learned during this project was how to write a bash script. I think that it is a very valuable skill to have and I'm glad this project gave me an opportunity to work with them.  
*Endri Koti*: How to pay attention and not to mismatch directories in linux!  

**Q3:**  
Is there anything that you would change if you did it again? Also, how did you figure out where to go and where to start? This seems really interesting.  
**A:**
*Andrew Valenci*: If we had to do it again, we would probably choose to setup our OpenStack configuration in Google Cloud rather than CloudLab. When we first started with this project, we knew we had to add one additional compute node to the default OpenStack profile that provides support for Docker virtualization, but we did not have a plan as to how to accomplish this. Then, Dr. Ngo proposed the use of Zun, an OpenStack container service. Zun provides API endpoints for Openstack to integrate with other OpenStack Services, such as Keystone, Neutron and Glance. With Zun, we were able to give OpenStack the ability to manage application containers such as Docker. After doing some research, we realized that before installing Zun, we had to install Etcd in the controller node (to store data), Docker in the compute node, and Kuryr in both nodes (to function as a bridge between container frameworks and OpenStack).

## Support :pray:
Thanks to [Dr. Linh Ngo](https://www.cs.wcupa.edu/lngo/about/) for his expertise and support on this project.

## License :balance_scale:
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
