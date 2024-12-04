# #!/bin/bash

# # Set variables
# BUCKET_NAME=" rivkyhoff-bucket"
# BRANCH="main"  # Specify the branch name explicitly

# # Log function for better output readability
# log() {
#     echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
# }

# # Step 1: Check for unstaged changes and commit them
# log "Checking for unstaged changes..."
# if [[ -n $(git status --porcelain) ]]; then
#     log "Changes detected. Staging and committing..."
#     git add .
#     git commit -m "Automated commit for deployment"
# else
#     log "No changes detected. Skipping commit step."
# fi

# # Step 2: Push changes to GitHub
# log "Pushing changes to GitHub..."
# if git push origin $BRANCH; then
#     log "Changes pushed successfully."
# else
#     log "Error: Failed to push changes. Exiting."
#     exit 1
# fi

# # Step 3: Install dependencies and build the React app
# log "Installing dependencies..."
# npm install

# log "Building React app..."
# if npm run build; then
#     log "React app built successfully."
# else
#     log "Error: React app build failed. Exiting."
#     exit 1
# fi

# # Step 4: Upload the built files to the GCS bucket
# log "Uploading files to GCS bucket ($BUCKET_NAME)..."
# if gsutil -m cp -r build/* gs://$rivkyhoff-bucket; then
#     log "Files uploaded successfully to GCS bucket."
# else
#     log "Error: Failed to upload files to GCS bucket. Exiting."
#     exit 1
# fi

# log "Automation script completed successfully!"


#!/bin/bash

# Set variables

BUCKET_NAME="rivkyhoff-bucket"
BRANCH="main"  # Specify the branch name explicitly

# Log function for better output readability
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Step 1: Check for unstaged changes and commit them
log "Checking for unstaged changes..."
if [[ -n $(git status --porcelain) ]]; then
    log "Changes detected. Staging changes..."
    git add .
    log "Enter a commit message:"
    read -r COMMIT_MESSAGE
    if [[ -z "$COMMIT_MESSAGE" ]]; then
        log "Error: Commit message cannot be empty. Exiting."
        exit 1
    fi
    git commit -m "$COMMIT_MESSAGE"
else
    log "No changes detected. Skipping commit step."
fi

# Step 2: Push changes to GitHub
log "Pushing changes to GitHub..."
if git push origin $BRANCH; then
    log "Changes pushed successfully."
else
    log "Error: Failed to push changes. Exiting."
    exit 1
fi

# Step 3: Install dependencies and build the React app
log "Installing dependencies..."
if [[ ! -d "node_modules" ]]; then
    npm install
else
    log "Dependencies already installed. Skipping npm install."
fi

log "Building React app..."
if npm run build; then
    log "React app built successfully."
else
    log "Error: React app build failed. Exiting."
    exit 1
fi

# Step 4: Upload the built files to the GCS bucket
log "Uploading files to GCS bucket ($rivkyhoff-bucket)..."
if gsutil -m cp -r build/* gs://$rivkyhoff-bucket; then
    log "Files uploaded successfully to GCS bucket."
else
    log "Error: Failed to upload files to GCS bucket. Exiting."
    exit 1
fi

log "Automation script completed successfully!"
