# Manual for Setting Up Development using Embedded Swift and Matter on macOS



This manual guides you through the installation of the necessary tools and setting up a terminal profile for Embedded Swift and Matter development.



## **1. Prerequisites**



### **1.1 Download and Install the Developer Toolchain**



Before running the installation scripts, you must manually download and install the **Xcode Developer Toolchain**. Follow these steps:



​	1.	Visit the [Apple Developer Toolchains page](https://developer.apple.com/download/more/) and search for the latest Xcode Developer Toolchain.

​	2.	Download the appropriate version for your macOS.

​	3.	Install the toolchain by opening the downloaded .xctoolchain file.



### **1.2 Cloning the Installation Scripts**



To clone the installation scripts and necessary repositories, you have two options: using your favorite Git GUI client or the Terminal.



​	•	**Using a GUI Git Client**:

​	•	Open your preferred Git client (e.g., Fork, SourceTree).

​	•	Clone the repository from the following URL:



https://github.com/TheMisfit68/MatTerMaster.git





​	•	**Using Terminal**:

​	•	Open the Terminal app.

​	•	Navigate to your desired directory, then run:



git clone https://github.com/TheMisfit68/MatTerMaster.git







**2. Setting Up a Terminal Profile for Embedded Swift and Matter Development**



**2.1 Creating the Profile**



​	1.	Open the Terminal app.

​	2.	Go to **Terminal > Preferences** (or press Cmd + ,).

​	3.	Click on the **Profiles** tab.

​	4.	Click the **+** button to create a new profile. Name it EmbeddedMatter.

​	5.	Set the **Working Directory** to your Embedded Projects Folder, which will be $HOME/swift-matter-examples.

​	6.	Optionally, customize colors, fonts, and other settings to your liking.



### **2.2 Attaching the Script**



To run the installation script automatically when opening a terminal window with the EmbeddedMatter profile:



​	1.	In the EmbeddedMatter profile settings, find the **Shell** section.

​	2.	In the **Run command** field, enter the path to your installation script:



source ~/MatTerMaster/MatterDevelopmentInstaller.sh





​	3.	Check the **Run command as a login shell** option to ensure the command executes each time a new terminal window is opened with this profile.



### **2.3 Running the Scripts Manually**



You can run the scripts manually before setting up the profile if you prefer:



​	1.	Open Terminal.

​	2.	Navigate to the cloned directory:



cd ~/MatTerMaster





​	3.	Execute the installation script:



./MatterDevelopmentInstaller.sh



You can perform a clean installation by using the command:



./MatterDevelopmentInstaller.sh true







## **3. Running the Scripts**



Once you’ve set up your profile, every time you open a new Terminal window with the EmbeddedMatter profile, the script will execute automatically. If there are no pre-installed SDKs or tools, it will perform a clean install.



### **3.1 Navigating the Working Directory**



To quickly navigate to your profile’s working directory, you can use the cd -projects command. This command will return you to your set working directory efficiently.



This manual should provide a clear, structured approach for your end users. If you need any more adjustments or additions, just let me know!
