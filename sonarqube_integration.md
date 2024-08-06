# SonarQube integration in flutter project.

Required 2 things to set up
1. SonarQube Server
2. Sonar Scanner


# Download and Setting up Sonarqube

1. Go to the Link → https://www.sonarqube.org/downloads/
2. Click COMMUNITY to download as a zip file
3. Extract a zip file and Move into the global folder(root directory)
4. Change the name of the folder as SonarQube

# Download and Setting up SonarScanner

1. Go to the Link → https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/
2. Click and download sonarscanner depends on your system OS
3. Extract a zip file and move into global folder(root directory)
4. Rename it as SonarScanner


# For Flutter download Sonar-Flutter Plugin

1. Go to the link https://github.com/insideapp-oss/sonar-flutter/releases/
2. Get latest release on sonar-scanner
3. Download sonar-flutter-plugin under the assets
4. Move it into inside global folder(root directory) → SonarQube → extensions → plugins folder.  


### Set path in Terminal:
Open terminal. your Terminal tells you which shell you’re using. Depends on your shell set a path, save and quite a terminal.

### See below guideline to add path
- Ubuntu : [How To View and Update the Linux PATH Environment Variable | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-view-and-update-the-linux-path-environment-variable#step-3-mdash-permanently-adding-a-directory-to-the-path-variable)

- Mac : [How to set or change $PATH variable on macOS/Mac OS X](https://www.cyberciti.biz/faq/appleosx-bash-unix-change-set-path-environment-variable/)


**NOTE:** **GLOBALPATH** is (root directory) that you have stored **SonarScanner** and **SonarQube**

```bash
export PATH=$PATH:/GLOBALPATH/SonarScanner/bin
export PATH=$PATH:/GLOBALPATH/SonarQube/bin
```

The setting up sonarqube and sonarscanner over. now we need to start the sonarqube server and Run sonarscanner

# Start SonarQube Server

- Run the following command in your terminal for mac:
```bash
sh /GLOBALPATH/SonarQube/bin/macosx-universal-64/sonar.sh console
```

- Run the following command in your terminal for linux:
```bash
sh /GLOBALPATH/SonarQube/bin/linux-x86-64/sonar.sh console
```

### Sonar Server logs
![Sonar Server](/sonarqube_integration_steps/sonar_server.png "Sonar Server")


# Logging In and Create Project
1. Go to the browser. Open url —> http://localhost:9000/about
2. Click on Login use admin as username, admin as password
3. Create a Project as manually [Image](/sonarqube_integration_steps/create_project_step1.png)
4. Use Global Settings [Image](/sonarqube_integration_steps/create_project_step2.png)
5. Use **Locally** for analysis mode [Image](/sonarqube_integration_steps/create_project_step3.png)
6. Click create and generate token for a project [Image](/sonarqube_integration_steps/create_project_step4.png)
7. In Provide Token Section your generated token autofilled, Click on Continue [Image](/sonarqube_integration_steps/create_project_step5.png)
8. Choose **Other** option for build and select your OS you'll get command for analyze the project [Image](/sonarqube_integration_steps/create_project_step6.png)

# Project Configuration
1. Open your flutter project
2. Create a new file **sonar-project.properties** [Refer demo file](/sonar-project.properties)
3. Add the following code in your projecct.
note: your project key should be match with your sonarqube project key 


# Perform Analysis

1. Open new terminal in your project directory and run the following commands
2. flutter pub get
3. Execute below command, You'll get this command from SonarQube admin panel in last step [Image](/sonarqube_integration_steps/create_project_step6.png)
```bash
sonar-scanner \                                 
  -Dsonar.projectKey=flutter_architecture \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://localhost:9000 \
  -Dsonar.token=sqp_3e0f4b7f03d677ed75935171e5b21fe7a73c703b
```
4. After getting a success message in the terminal, you can check the dashboard of sonarqube to see the result.
