# Project-3: Application Deployment

This project demonstrates **end-to-end deployment** of a containerized application using **Git, Docker, Jenkins, AWS EC2**, and monitoring configured via **Monit**.

---

## 📂 Workflow Overview

### Git
- Code pushed to **dev** branch.
- Code merged into **main** branch.
- Webhook triggers Jenkins pipeline on branch updates.

### Docker
- Application dockerized using `Dockerfile`.
- `docker-compose.yml` orchestrates containers.
- Scripts:
  - `build.sh` → builds Docker images.
  - `deploy.sh` → deploys images to server.

### Docker Hub
- Images pushed to private/public repositories.
- Tags:
  - `percianancy/dev:latest` → Dev branch.
  - `percianancy/prod:latest` → Main branch.

### AWS EC2
- Jenkins installed on EC2.
- Security Group allows:
  - Port **8080** (Jenkins UI)
  - Port **22** (SSH)
  - Port **80** (App)
  - Port **443** (HTTPS)
  - Port **2812** (Monit UI)
- Docker, Docker Compose, and Git installed.
- Jenkins user added to Docker group:
  ```bash
  sudo usermod -aG docker jenkins
  ```

### Jenkins
- Plugins installed: **Docker, Git, Pipeline Steps**.
- Docker Hub credentials added.
- Pipeline created:
  - Push to **dev** → build & deploy `percianancy/dev:latest` → run `deploy.sh dev` → container `my-react-dev`.
  - Push/merge to **main** → build & deploy `percianancy/prod:latest` → run `deploy.sh prod` → container `my-react-prod` on port 80.

---


## 🔍 Monitoring with Monit

### Installation
```bash
sudo dnf update -y
sudo dnf groupinstall "Development Tools" -y
sudo dnf install gcc make wget tar openssl-devel pam-devel -y

wget https://mmonit.com/monit/dist/monit-5.33.0.tar.gz
tar xvf monit-5.33.0.tar.gz
cd monit-5.33.0
./configure --without-pam
make
sudo make install
```

### Verify Installation
```bash
/usr/local/bin/monit -V
```

### Configuration
Create `/etc/monitrc`:
```text
set daemon 60
set logfile /var/log/monit.log

# Monitor application on port 80
check host myapp with address <EC2-Public-IP>
  if failed port 80 protocol http then alert

# Web UI
set httpd port 2812 and
    use address 0.0.0.0
    allow admin:monit

# Email Alerts (example using Outlook SMTP)
set mailserver smtp.gmail.com port 587
  username "your-email@gmail.com" password "your-password"
  using tlsv12

set alert your-email@gmail.com
```

Secure config:
```bash
sudo chmod 600 /etc/monitrc
```

### Start Monit
```bash
sudo /usr/local/bin/monit -d 60
/usr/local/bin/monit status
```

### Security Group
- Allow inbound port **2812** for Monit UI (restrict to your IP for security).

### Behavior
- If container stops → Monit detects failure → email alert triggered.
- Once container restarts → Monit shows recovery.

---

## 📸 Screenshots

### 1. Jenkins Pipeline Run

<img width="1658" height="910" alt="image" src="https://github.com/user-attachments/assets/4a185c5b-a053-427f-beab-ac53b74aade6" />


### 2. Docker Container Running

<img width="2155" height="184" alt="image" src="https://github.com/user-attachments/assets/5d6e30e0-7e2e-4965-b81b-7898d11d34bb" />



### 3. Monit UI Dashboard

<img width="2798" height="926" alt="image" src="https://github.com/user-attachments/assets/e120d8fb-365d-4057-bb0e-149b16bb42a4" />



### 4. Application Running on EC2
<img width="2680" height="952" alt="image" src="https://github.com/user-attachments/assets/198810ba-bb2e-4a1c-beca-4e4c7b300cf2" />


---

## ✅ Summary
- Git workflow with dev and main branches.
- Dockerized app with build/deploy scripts.
- Jenkins pipeline automates builds and deployments.
- Docker Hub stores images.
- AWS EC2 hosts Jenkins and app containers.
- Monit provides monitoring, alerts, and a web UI.

---

## 🔗 Access Points
- **App URL**: `http://<EC2-Public-IP>`
- **Jenkins UI**: `http://<EC2-Public-IP>:8080`
- **Monit UI**: `http://<EC2-Public-IP>:2812` (login: `admin/monit`)

