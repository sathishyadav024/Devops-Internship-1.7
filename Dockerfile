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

