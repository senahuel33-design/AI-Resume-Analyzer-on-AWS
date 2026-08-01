# AI-Resume-Analyzer-on-AWS
AI Resume Analyzer on AWS is a production-style cloud application that analyzes PDF resumes using AI. The application is built with FastAPI, containerized with Docker, deployed on AWS infrastructure, automated with GitHub Actions, and provisioned using Terraform. This project demonstrates modern Cloud and DevOps engineering practices from local development to automated deployment.

The application allows users to upload a resume/CV and receive AI-generated feedback including:

* ATS optimization suggestions
* Skill gap analysis
* Grammar improvements
* Cloud/DevOps career recommendations
* Resume strengths and weaknesses

The project showcases:

* Containerization with Docker
* CI/CD automation with GitHub Actions
* Infrastructure provisioning with Terraform
* AWS cloud deployment
* AI API integration
* Monitoring and logging practices

---

## 🏗️ Architecture Overview
The application is built on a serverless, containerized AWS architecture:

* **Traffic Routing:** An Application Load Balancer (ALB) routes public HTTP traffic to the backend.
* **Compute Layer:** Runs as a containerized FastAPI service on AWS ECS Fargate inside isolated subnets.
* **Infrastructure & Deployment:** Provisioned via Terraform IaC and deployed automatically using GitHub Actions.

📸 **Architecture Diagram**

![Architecture](<Architecture/Architecture.png>)

---

# 🌐 Live Application

🚀 **Live Application:** [Access App Here](http://ai-resume-alb-578273199481.eu-west-1.elb.amazonaws.com)

*Note: Deployed publicly on AWS via Application Load Balancer.*

---

## Step 1: Project Initialization (Architecture Setup)

The first step was to initialize the base structure of the FastAPI application. This ensures a clean, modular, and scalable foundation for future development, CI/CD integration, and AWS deployment.

### Project Structure

```text
AI-Resume-Analyzer-on-AWS/
│
├── app/
│   ├── main.py            # FastAPI backend logic & API routes
│   └── utils.py           # Helper functions (text extraction, AI handling)
│
├── frontend/              # Frontend Web Interface
│   ├── index.html         # Main UI structure
│   ├── style.css          # UI custom styling & responsiveness
│   └── app.js             # JavaScript handling fetch calls
│
├── terraform/             # IaC Cloud Provisioning
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── provider.tf
│
├── .github/
│   └── workflows/
│       └── deploy.yml     # GitHub Actions automated CI/CD pipeline
│
├── Dockerfile             # Production container configurations
├── requirements.txt       # Python backend dependencies
├── .env                   # Local environment variables
└── README.md              # Project documentation
```
## Local Development Setup

```bash
# Clone the repository
git clone [https://github.com/senahuel33-design/AI-Resume-Analyzer-on-AWS.git](https://github.com/senahuel33-design/AI-Resume-Analyzer-on-AWS.git)
cd AI-Resume-Analyzer-on-AWS

# Set up virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run backend server
uvicorn app.main:app --reload
```
---
# Phase 2: Containerization with Docker

## Goal

Containerize the FastAPI application to ensure consistent execution across development, testing, and cloud environments.

Docker allows the application and its dependencies to be packaged into a portable image that can be deployed reliably to AWS ECS later in the project.

---

## Step 1: Docker Build Optimization

Created a `.dockerignore` file to exclude unnecessary files from the Docker build context.

Excluded files:

* Virtual environments
* Environment files
* Python cache files
* Git metadata

### Screenshot

![Docker Ignore](<Screenshots/Containerization with Docker/dockerignore.png>)

---

## Step 2: Create the Dockerfile

Built a production-ready Docker image using the official Python 3.12 slim image.

Key configuration:

* Python 3.12 runtime
* Dependency installation through `requirements.txt`
* Application source code copied into the container
* Port 8000 exposed
* Uvicorn configured as the application server

### Screenshot

![Dockerfile](<Screenshots/Containerization with Docker/Dockerfile.png>)

---

## Step 3: Build the Docker Image

Built the application image locally using Docker.

```bash
docker build -t ai-resume-analyzer:v1 .
```

### Screenshot

![Docker Build](<Screenshots/Containerization with Docker/docker-build.png>)

---

## Step 4: Run the Container

Started the container locally and passed environment variables securely using the `.env` file.

```bash
docker run -d \
  --name resume-api-container \
  -p 8000:8000 \
  --env-file .env \
  ai-resume-analyzer:v1
```

### Screenshot

![Docker Container Running](<Screenshots/Containerization with Docker/docker-run.png>)

---

## Step 5: Validate the Containerized Application

Verified that the application was running correctly inside the Docker container.

Checks performed:

* Container status validation
* API accessibility
* Swagger UI functionality
* Resume analysis endpoint testing

```bash
docker ps
```

### Screenshots

![Docker PS](<Screenshots/Containerization with Docker/04_docker_ps_validation.png>)

![Swagger UI Docker](<Screenshots/Containerization with Docker/swagger-ui-docker.png>)
![Swagger UI Docker 2](<Screenshots/Containerization with Docker/swagger-ui-docker.png 2.png>)

---

### Next Phase

Deploy the containerized application using cloud infrastructure provisioned with Terraform and AWS services.

# Phase 3: Frontend Development

## Goal

Build a simple and responsive web interface that allows users to upload resumes and view AI-generated feedback directly in the browser.

---

## Step 1: Frontend Structure

Created a dedicated frontend directory to separate the user interface from the backend API.

```text
frontend/
├── index.html
├── style.css
└── app.js
```

### Screenshot

![Frontend Structure](<Screenshots/Frontend Development/frontend-structure.png>)

---

## Step 2: Build the User Interface

Developed a clean and responsive interface using HTML and CSS.

Features:

* Drag-and-drop file upload area
* Resume upload button
* Results display section
* Responsive layout for desktop and mobile

### Screenshot

![Frontend UI](<Screenshots/Frontend Development/frontend-ui.png>)

---

## Step 3: Styling and User Experience

Implemented custom styling to improve usability and readability.

Features:

* Modern card layout
* Responsive design
* Interactive upload area
* Loading state support
* Form validation feedback

### Screenshot

![Frontend Styling](<Screenshots/Frontend Development/upload-screen.png>)

---

## Step 4: Connect Frontend to FastAPI Backend

Implemented JavaScript functionality to communicate with the backend API.

The frontend:

* Captures uploaded PDF files
* Sends requests to the `/analyze` endpoint
* Receives AI-generated feedback
* Displays analysis results dynamically

### Screenshot

![JavaScript Integration](<Screenshots/Frontend Development/frontend-js.png>)

---

## Step 5: End-to-End Testing

Validated the complete workflow between frontend and backend.

Workflow:

1. User uploads a PDF resume
2. Frontend sends request to FastAPI API
3. Backend extracts resume content
4. AI analyzes the resume
5. Results are displayed in the browser

### Screenshots

![Upload Screen](<Screenshots/Frontend Development/upload-screen.png>)

![Analysis Results](<Screenshots/Frontend Development/frontend-results.png>)

---

## Phase 4: CI/CD Pipeline with GitHub Actions

This project includes a GitHub Actions workflow that automatically validates the application whenever code is pushed to the repository.

### Workflow Features

- Runs automatically on every push to the main branch
- Creates a clean Ubuntu runner
- Installs project dependencies
- Builds the Docker image
- Verifies that the application can be successfully containerized

### Workflow File

```text
.github/workflows/deploy.yml
```

### Pipeline Execution

![GitHub Actions Pipeline](<Screenshots/CICD Pipeline with GitHub Actions/github-actions-success.png>)
## Outcome

At the end of this phase, the application achieved full CI/CD automation. Any changes pushed to the `main` branch automatically trigger GitHub Actions to run unit tests, build the Docker container, push the image to AWS ECR, and deploy the updated tasks to the AWS ECS Fargate cluster with zero manual intervention.

### 🛠️ Troubleshooting & Lessons Learned

During the initial pipeline configuration, the workflow deployment script failed with syntax validation errors:
* `Invalid workflow file: .github/workflows/deploy.yml` 
* `error: 'name' is already defined, 'on' is already defined, 'jobs' is already defined`

#### Root Cause:
When configuring the workflows via the Ubuntu terminal using `nano`, the deployment steps were accidentally pasted into an existing configuration file that already contained a separate code validation/testing script. Because YAML structure restricts duplicate root-level blocks (like `name`, `on`, and `jobs`), the GitHub parser threw an exception and refused to execute.

#### Resolution:
The file architecture was separated. The deployment configuration was completely isolated into its own dedicated file (`.github/workflows/deploy.yml`), while keeping the code validation test script independent. This allows both pipelines to execute simultaneously and cleanly on every code push.

### 🛠️ Key Technologies & AWS Architecture

* **Infrastructure & Compute:** AWS VPC, ECS Fargate, ECR, Application Load Balancer (ALB), S3.
* **Frontend & Backend:** HTML5, CSS3, JavaScript (Fetch API), FastAPI, Uvicorn, Docker.
* **DevOps & Observability:** Terraform (IaC), GitHub Actions (CI/CD), AWS CloudWatch, IAM (Least Privilege).

---

# 🚀 CI/CD & Cloud Security

### Automated Pipeline
On `git push`, GitHub Actions automatically triggers: **Image Build → Container Tests → Push to ECR → Service Rollout on ECS Fargate**.

![GitHub Actions Pipeline](Screenshots/CICD%20Pipeline%20with%20GitHub%20Actions/github-actions-success.png)

### Security & Observability
* **Zero Hardcoded Credentials:** Secrets injected via GitHub Secrets & IAM Least Privilege policies.
* **Centralized Logs:** Operational and container logs streamed directly to AWS CloudWatch.

---

# 🎯 Key Takeaways & Roadmap

| 💡 Core Learnings | 🔮 Future Enhancements |
| :--- | :--- |
| • Infrastructure as Code with Terraform | • SSL/TLS Encryption via AWS Certificate Manager (ACM) |
| • Container orchestration via ECS Fargate | • Custom Domain routing via Amazon Route 53 |
| • End-to-end CI/CD automation & pipeline security | • Native AI model integration via AWS Bedrock |

---

# 👤 Author

**Nahuel Egidi**  
🔗 [GitHub Profile](https://github.com/senahuel33-design) | 💼 [LinkedIn Profile](https://www.linkedin.com/in/nahuel-egidi-21b8202aa/)
