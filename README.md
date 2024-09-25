
# `Automate Docker Image Build and ECR Push with GitHub Actions`

The workflow of building and pushing Docker images to AWS ECR is a crucial part of modern DevOps practices, particularly in containerized application deployment. This process involves automating the build and Push of Docker images using GitHub Actions, a CI service that integrates seamlessly with GitHub repositories.



## `Project Objectives`

- Automate building Docker image using Dockerfile.

- Automate Taging the Docker Image.

- Automate the Pushing the Docker Image to ECR


## 🔗 `Links`

[![linkedin](https://img.shields.io/badge/linkedin-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sathish-gurka)


## `Authors`

- [@GurkaSathish](https://github.com/sathishyadav024)


## `Pre-Requisites`

- `GitHub`  

- `AWS account (user)`

- `GitHub repository with the necessary secrets configured." AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_REGION, AWS_ACCOUNT_ID, ECR_REPOSITORY_NAME"`
## Dockerfile

```
# Use the official Node.js LTS image as the base
FROM node:18-alpine

# Set environment variables
ENV NODE_ENV=production
ENV PORT=9000

# Create and set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy the rest of the application code
COPY . .

# Expose the port Medusa runs on
EXPOSE 9000

# Command to run the Medusa server
CMD ["npm", "start"]

```
##  Github Actions Workflow

```
name: Build and push Docker image to ECR

on:
  push:
    branches:
      - main  # Trigger on push to the 'main' branch
jobs:
 pull_tag_push_image:
  name: Build, Tag, and Push to ECR
  runs-on: ubuntu-latest
  steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Configure AWS Credentials
      uses: aws-actions/configure-aws-credentials@v1
      with:
        aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
        aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        aws-region: ${{ secrets.AWS_REGION }}

    - name: Set ECR Repository URL
      run: |
        echo "ECR_REPOSITORY_URL=${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.${{ secrets.AWS_REGION }}.amazonaws.com/${{ secrets.ECR_REPOSITORY_NAME }}" >> $GITHUB_ENV

    - name: Log in to Amazon ECR
      run: |
        aws ecr get-login-password --region ${{ secrets.AWS_REGION }} | docker login --username AWS --password-stdin ${{ env.ECR_REPOSITORY_URL }}

    # Build Docker image
    - name: Build Docker Image
      run: docker build -t medusa-backend .

    # Tag the Docker image with the ECR repository URL
    - name: Tag Docker Image
      run: docker tag medusa-backend:latest ${{ env.ECR_REPOSITORY_URL }}:v2

    # Push the Docker image to ECR
    - name: Push Docker Image to ECR
      run: docker push ${{ env.ECR_REPOSITORY_URL }}:v2
```
## `Workflow Steps`

`1. Triggering the Workflow:`

- The workflow is triggered on a push event to the main branch. This means that any changes pushed to this branch will initiate the workflow, ensuring that the latest version of the application is always built and pushed.

`2. Checkout Code:`

- The workflow starts by checking out the code from the repository using the actions/checkout action. This makes the repository code available for subsequent steps in the workflow.

`3. Configure AWS Credentials:`

- To interact with AWS services, the workflow configures AWS credentials using the aws-actions/configure-aws-credentials action. These credentials, including the access key, secret access key, and region, are stored securely in GitHub Secrets.

`4. Set ECR Repository URL:`

- The workflow constructs the ECR repository URL dynamically using environment variables and saves it to the environment. This URL will be used in the login and push steps.

`5. Log in to Amazon ECR:`

- Before pushing the Docker image, the workflow logs into AWS ECR . It retrieves a login password and uses it to authenticate the Docker client against the ECR registry.

`6. Build Docker Image:`

- The workflow builds the Docker image using a Dockerfile located in the repository. The image is tagged with the name medusa-backend, ensuring that it is identifiable and can be easily referenced later.

`7. Tag Docker Image:`

- Once the image is built, it is tagged with the ECR repository URL and a version number (v2). This step is essential for versioning and managing images within the ECR repository.

`8. Push Docker Image to ECR:`

- Finally, the workflow pushes the tagged Docker image to the specified ECR repository. This makes the image available for deployment to services such as ECS or EKS.


## `Technologies Used`


- `GitHub Actions`: Automation tool for CI/CD pipelines.

- `AWS ECR`: Cloud-based Container Registry.

- `Medusa`: E-commerce backend platform.

## `Contact`


   For any inquiries or issues related to this project, please reach out via email:  
   
   
   Author: `Gurka Sathish`
   
   Email: ` sathishgurka@gmail.com `
## `Result`

`Successfully Built and Pushed the Docker Image to AWs ECR` 
