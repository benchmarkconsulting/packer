<!-- ABOUT THE PROJECT -->
## About The Project
This uses a simple jenkins pipeline to run packer.io

Packer Benefits:
* Automated approach to image creation
* Images are continually secured: hardened at patched during creation
* Consistent method for creating consumable images
* Your time should be focused on creating something amazing. A project that solves a problem and helps others :smile:

You can suggest changes by forking this repo and creating a pull request or opening an issue.

A list of commonly used resources that we find helpful are listed in the Resources.

<!-- GETTING STARTED -->
## Getting Started



### Prerequisites

* Kubernetes Plugin manager
```
https://plugins.jenkins.io/kubernetes/
```
* JNLP slave with Packer 

### Usage

1. Clone the repo
```
git clone https://github.com/benchmarkconsulting/packer.git
```
2. Change Directory
```
cd packer/jenkins/
```

3. Build Jenkins Slave
```
docker build -t packer-slave
```
```
docker tag packer-slave <repo>/packer-slave
```
```
docker push
```
4. Create new Jenkins Job with Jenkinsfile


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make an open source community and such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.


<!-- CONTACT -->
## Contact

Matt Cole - matt.cole@benchmarkcorp.com  
Jeremy Carson - jeremy.carson@benchmarkcorp.com  
Jon Sammut - jon.sammut@benchmarkcorp.com  
David Patrick - dave.patrick@benchmarkcorp.com  

<!-- Resource LINKS  -->
## Resources

[https://packer.io](https://www.packer.io/)
[https://plugins.jenkins.io/kubernetes/](https://plugins.jenkins.io/kubernetes/)
[https://www.jenkins.io/](https://www.jenkins.io/)