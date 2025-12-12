#!/bin/bash

# Marley Healthcare App - Installation Script
# This script helps set up the ERPNext environment with Marley Healthcare App

set -e

echo "======================================"
echo "Marley Healthcare App - Setup Script"
echo "======================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from .env.example..."
    cp .env.example .env
    echo "✅ .env file created. Please edit it with your configuration."
    echo ""
fi

# Ask for site name
read -p "Enter your site name (default: erp.marleyhealthcare.local): " SITE_NAME
SITE_NAME=${SITE_NAME:-erp.marleyhealthcare.local}

# Ask for admin password
read -sp "Enter admin password (default: admin): " ADMIN_PASSWORD
ADMIN_PASSWORD=${ADMIN_PASSWORD:-admin}
echo ""

# Ask for database root password
read -sp "Enter database root password (default: admin): " DB_ROOT_PASSWORD
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-admin}
echo ""
echo ""

# Update .env file
sed -i "s/SITE_NAME=.*/SITE_NAME=$SITE_NAME/" .env
sed -i "s/ADMIN_PASSWORD=.*/ADMIN_PASSWORD=$ADMIN_PASSWORD/" .env
sed -i "s/DB_ROOT_PASSWORD=.*/DB_ROOT_PASSWORD=$DB_ROOT_PASSWORD/" .env

echo "🚀 Starting Docker services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready (this may take 1-2 minutes)..."
sleep 60

echo ""
echo "🔧 Creating new site: $SITE_NAME..."
docker-compose exec -T backend bench new-site "$SITE_NAME" \
    --admin-password "$ADMIN_PASSWORD" \
    --db-root-password "$DB_ROOT_PASSWORD" \
    --no-mariadb-socket

echo ""
echo "📦 Installing ERPNext..."
docker-compose exec -T backend bench --site "$SITE_NAME" install-app erpnext

echo ""
echo "📦 Installing Marley Healthcare App..."
docker-compose exec -T backend bench --site "$SITE_NAME" install-app marley_healthcare_app

echo ""
echo "✅ Setting $SITE_NAME as the current site..."
docker-compose exec -T backend bench use "$SITE_NAME"

echo ""
echo "======================================"
echo "✅ Installation Complete!"
echo "======================================"
echo ""
echo "Access your ERPNext instance at:"
echo "  URL: http://localhost:8080"
echo "  Username: Administrator"
echo "  Password: $ADMIN_PASSWORD"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""
echo "To stop services:"
echo "  docker-compose down"
echo ""
