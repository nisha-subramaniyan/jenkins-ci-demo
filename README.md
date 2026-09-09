# Jenkins CI/CD Demo – Nisha Subramaniyan

This repository demonstrates a basic CI/CD setup using Jenkins, GitHub, and a simple shell-based “application”.

- **Tech Stack:** Ubuntu (WSL), Jenkins, Git, GitHub, Bash

---

## Repository Structure

```text
.
├── app.sh          # Simulated application build script
├── test.sh         # Simulated test script
├── Jenkinsfile     # Declarative Pipeline definition
└── README.md       # This file
```

---

## Prerequisites

- Ubuntu (native or WSL2) with:
  - Java (OpenJDK 21)
  - Git
  - Jenkins installed and running
- GitHub account and repository
- (Optional) ngrok for exposing Jenkins to GitHub webhooks in a local setup

---

## Installation & Setup Summary

### 1. Install Jenkins (Ubuntu/WSL)

```bash
# Remove any broken Jenkins repo
sudo rm -f /etc/apt/sources.list.d/jenkins.list
sudo rm -f /usr/share/keyrings/jenkins-keyring.asc

# Add Jenkins key and repo
curl -fsSL [https://pkg.jenkins.io/debian/jenkins.io-2023.key](https://pkg.jenkins.io/debian/jenkins.io-2023.key) | \
  sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] [https://pkg.jenkins.io/debian](https://pkg.jenkins.io/debian) stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list

# Install Jenkins
sudo apt update
sudo apt install -y jenkins
sudo systemctl enable --now jenkins
sudo systemctl status jenkins
```

Open Jenkins in browser:

```text
http://localhost:8080
```

Initial admin password:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

### 2. Create GitHub Repository

1. Create a new public repo, e.g. `jenkins-ci-demo`.
2. Clone it:

   ```bash
   git clone https://github.com/YOUR_USERNAME/jenkins-ci-demo.git
   cd jenkins-ci-demo
   ```

3. Add the files: `app.sh`, `test.sh`, `Jenkinsfile`, and this `README.md`.
4. Push:

   ```bash
   git add .
   git commit -m "Initial Jenkins CI demo"
   git push origin main
   ```

---

### 3. Jenkins Jobs

#### Freestyle Job: `freestyle-github-build`

- **Source Code Management:** Git  
  - Repository URL: `https://github.com/nisha-subramaniyan/jenkins-ci-demo.git`
  - Branch: `*/main`
- **Build Triggers:** GitHub hook trigger for GITScm polling
- **Build Step:** Execute shell

  ```bash
  chmod +x app.sh test.sh
  ./app.sh
  ./test.sh
  ```

#### Pipeline Job: `jenkins-ci-pipeline`

- **Definition:** Pipeline script from SCM
- **SCM:** Git
  - Repository URL: `https://github.com/nisha-subramaniyan/jenkins-ci-demo.git`
  - Script Path: `Jenkinsfile`

---

### 4. Jenkinsfile (Declarative Pipeline)

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh '''
                    chmod +x app.sh test.sh
                    ./app.sh
                '''
            }
        }

        stage('Test') {
            steps {
                sh './test.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Check the console output.'
        }
    }
}
```

---

### 5. GitHub Webhook Integration

1. In Jenkins job → **Configure** → **Build Triggers**:
   - Enable **GitHub hook trigger for GITScm polling**.
2. Expose Jenkins using ngrok (for local/WSL setups):

   ```bash
   ngrok http 8080
   ```

   Note the `Forwarding` URL, e.g.:

   ```text
   https://3f5a-1234-5678-90ab.ngrok-free.app
   ```

3. In GitHub repo → **Settings** → **Webhooks** → **Add webhook**:
   - **Payload URL**:

     ```text
     https://YOUR-NGROK-DOMAIN.ngrok-free.app/github-webhook/
     ```

   - **Content type:** `application/json`
   - **Events:** Just the push event
   - **Active:** checked
4. Save, then push a small change to the repo and verify that Jenkins triggers a build automatically.

---

## How to View Logs

### Jenkins Service Logs

```bash
sudo journalctl -u jenkins -f
```

### Specific Job Build Logs (on disk)

```bash
cd /var/lib/jenkins/jobs/YOUR_JOB_NAME/builds/
sudo tail -f BUILD_NUMBER/log
```

### In Jenkins UI

- Job → Click build number → **Console Output**.

---

## Submission Artifacts

For the assignment, the following are submitted separately:

- **GitHub Repository Link:**  
  `https://github.com/YOUR_USERNAME/jenkins-ci-demo`
- **PDF Report:**  
  `Week5_Jenkins.pdf`  
  (Covers CI/CD, Jenkins architecture, Freestyle jobs, Declarative pipelines, Jenkinsfile, GitHub webhooks, credentials, and pipeline stages.)
- **Screenshots:**
  - Jenkins Dashboard
  - GitHub Integration (Webhooks page)
  - Pipeline Execution (Stage View)
  - Build Logs (Console Output)

---

## Notes

- This is a demo setup for learning CI/CD concepts with Jenkins.
- In production, you would:
  - Use proper build tools (Maven, Gradle, npm, etc.).
  - Secure credentials via Jenkins Credentials.
  - Use agents/nodes for scalability.
  - Enforce branch protection and code review workflows.
