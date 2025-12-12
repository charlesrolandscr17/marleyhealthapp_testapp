# Marley Healthcare App

A custom Frappe/ERPNext application for healthcare management. This repository includes a complete Docker setup for running ERPNext with the Marley Healthcare app, compatible with Coolify deployment.

## Features

- Custom healthcare management module
- Built on ERPNext v15
- Docker Compose configuration for easy deployment
- Coolify-compatible setup
- Includes all necessary services (database, Redis, workers, scheduler)

## Prerequisites

- Docker (version 20.10 or higher)
- Docker Compose (version 1.29 or higher)
- At least 4GB RAM available for Docker
- 10GB free disk space

## Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/charlesrolandscr17/marleyhealthapp_testapp.git
cd marleyhealthapp_testapp
```

### 2. Configure Environment Variables

Copy the example environment file and customize it:

```bash
cp .env.example .env
```

Edit `.env` and update the following important variables:
- `ADMIN_PASSWORD`: Change from default 'admin' to a secure password
- `DB_ROOT_PASSWORD`: Set a secure database root password
- `SITE_NAME`: Your domain name (e.g., erp.yourdomain.com)

### 3. Start the Services

```bash
docker-compose up -d
```

This will start all required services:
- MariaDB (database)
- Redis (cache and queue)
- ERPNext backend
- Nginx frontend
- WebSocket server
- Background workers (short and long queues)
- Scheduler

### 4. Create a New Site

After all services are running, create your ERPNext site:

```bash
# Wait for services to be healthy (about 30-60 seconds)
docker-compose ps

# Create a new site
docker-compose exec backend bench new-site ${SITE_NAME:-erp.marleyhealthcare.local} \
  --admin-password ${ADMIN_PASSWORD:-admin} \
  --db-root-password ${DB_ROOT_PASSWORD:-admin}

# Install ERPNext
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} install-app erpnext

# Install Marley Healthcare App
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} install-app marley_healthcare_app

# Set the site as current site
docker-compose exec backend bench use ${SITE_NAME:-erp.marleyhealthcare.local}
```

### 5. Access ERPNext

Open your browser and navigate to:
- **URL**: http://localhost:8080 (or your configured domain)
- **Username**: Administrator
- **Password**: The password you set in `ADMIN_PASSWORD` (default: admin)

## Deployment on Coolify

Coolify is a self-hosted platform for deploying applications. Here's how to deploy this app on Coolify:

### Prerequisites
- Coolify instance running
- Domain name configured

### Deployment Steps

1. **Create a New Resource** in Coolify
   - Choose "Docker Compose" as the resource type
   - Connect your GitHub repository

2. **Configure the Service**
   - Set the branch to deploy (e.g., `main`)
   - Coolify will automatically detect the `docker-compose.yml` file

3. **Set Environment Variables**
   - In Coolify's environment section, add all variables from `.env.example`
   - Important: Update `SITE_NAME` to match your domain
   - Set secure passwords for `ADMIN_PASSWORD` and `DB_ROOT_PASSWORD`

4. **Configure Domain**
   - Add your domain in Coolify's domain settings
   - Coolify will automatically handle SSL certificates via Let's Encrypt

5. **Deploy**
   - Click "Deploy" in Coolify
   - Monitor the deployment logs

6. **Initialize the Site** (First deployment only)
   - Once deployed, use Coolify's terminal feature or SSH into your server
   - Run the site creation commands from step 4 above

### Post-Deployment Configuration

After the first deployment, you may need to:

1. **Enable the site** (if not already enabled):
```bash
docker-compose exec backend bench --site your-domain.com set-config maintenance_mode 0
```

2. **Configure backup schedule** (optional):
```bash
docker-compose exec backend bench --site your-domain.com set-config backup_schedule "0 3 * * *"
```

## Architecture

The setup includes the following services:

- **frontend**: Nginx reverse proxy (port 8080)
- **backend**: Frappe/ERPNext application server
- **websocket**: Real-time communication server
- **queue-short**: Background worker for short tasks
- **queue-long**: Background worker for long-running tasks
- **scheduler**: Scheduled task runner
- **db**: MariaDB database
- **redis-cache**: Redis for caching
- **redis-queue**: Redis for job queues
- **configurator**: Initial configuration service

## Development

### App Structure

```
marley_healthcare_app/
├── __init__.py              # App version
├── hooks.py                 # App configuration and hooks
├── modules.txt              # List of modules
├── config/                  # Configuration files
├── marley_healthcare/       # Main module
│   ├── __init__.py
│   └── module.json
└── public/                  # Static assets
```

### Adding Custom Doctypes

1. Access ERPNext at http://localhost:8080
2. Go to "Developer" > "DocType"
3. Create your custom DocType
4. Assign it to the "Marley Healthcare" module

### Making Changes to the App

When you make changes to the app code:

```bash
# Rebuild assets
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} build

# Clear cache
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} clear-cache

# Restart services
docker-compose restart backend
```

## Troubleshooting

### Services not starting

Check the logs:
```bash
docker-compose logs -f
```

### Database connection issues

Verify database is healthy:
```bash
docker-compose exec db mysql -uroot -p${DB_ROOT_PASSWORD:-admin} -e "SHOW DATABASES;"
```

### Site not loading

1. Check if site exists:
```bash
docker-compose exec backend bench list-sites
```

2. Check site config:
```bash
docker-compose exec backend cat sites/${SITE_NAME:-erp.marleyhealthcare.local}/site_config.json
```

### Reset Everything

To completely reset the setup:
```bash
docker-compose down -v
docker-compose up -d
# Then run the site creation commands again
```

## Backup and Restore

### Create Backup

```bash
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} backup \
  --with-files
```

Backups are stored in `sites/${SITE_NAME}/private/backups/`

### Restore Backup

```bash
docker-compose exec backend bench --site ${SITE_NAME:-erp.marleyhealthcare.local} restore \
  /home/frappe/frappe-bench/sites/${SITE_NAME}/private/backups/[backup-file]
```

## Production Considerations

For production deployments:

1. **Use secure passwords**: Update all default passwords
2. **Enable HTTPS**: Use a reverse proxy with SSL (Coolify handles this automatically)
3. **Regular backups**: Set up automated backup scripts
4. **Resource limits**: Configure Docker resource limits in production
5. **Monitoring**: Set up monitoring for services health
6. **Update strategy**: Plan for ERPNext version updates

## Support

For issues related to:
- **ERPNext**: Visit [ERPNext Forum](https://discuss.erpnext.com/)
- **Frappe Framework**: Visit [Frappe Forum](https://discuss.frappe.io/)
- **This app**: Open an issue on GitHub

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.