#!/bin/bash

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null
then
    echo "Error: kubectl is not installed. Please install it first."
    exit 1
fi

# Applying Lab Pre-Requisites
echo "Lab pre-requisites..."
if kubectl apply -f app.yaml; then
    echo "Successfully applied pre-requisites..."
else
    echo "Error: Failed to apply ~/sysdig-assignment/app.yaml"
    exit 1
fi

# Applying the Vulnerable Workload: Pillow
echo "Applying the vulnerable workload: pillow"
if kubectl apply -f ~/sysdig-assignment/pillow.yaml; then
    echo "Successfully applied the vulnerable workload: pillow"
else
    echo "Error: Failed to apply pillow.yaml"
    exit 1
fi

echo "Setup Complete!"
