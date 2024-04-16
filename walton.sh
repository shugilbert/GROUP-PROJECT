#!/bin/bash

# Update the package index
echo "Updating package index..."
sudo yum update -y

# Install PostgreSQL 15
echo "Installing PostgreSQL 15..."
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL$(rpm -E %centos)/-x86_64/pgdg-redhat-repo-latest.noarch.rpm

# Now install the PostgreSQL 15 server package
sudo yum install -y postgresql15-server

# Initialize the PostgreSQL database cluster
echo "Initializing PostgreSQL 15 database cluster..."
sudo /usr/pgsql-15/bin/postgresql-15-setup initdb

# Start the PostgreSQL 15 server
echo "Starting PostgreSQL 15 server..."
sudo systemctl start postgresql-15

# Enable PostgreSQL 15 to start on boot
echo "Enabling PostgreSQL 15 to start on boot..."
sudo systemctl enable postgresql-15

echo "PostgreSQL 15 installation and configuration completed successfully."

