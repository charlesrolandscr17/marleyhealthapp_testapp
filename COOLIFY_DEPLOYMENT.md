# Deploying Marley Healthcare App on Coolify

This guide provides step-by-step instructions for deploying the Marley Healthcare App (ERPNext with custom app) on Coolify.

## Prerequisites

1. A running Coolify instance (v4.0 or later)
2. A domain name pointed to your Coolify server
3. SSH access to your Coolify server (for initial setup)

## Deployment Steps

### 1. Prepare Your Coolify Instance

Ensure your Coolify instance has sufficient resources:
- **Minimum**: 2 CPU cores, 4GB RAM, 20GB storage
- **Recommended**: 4 CPU cores, 8GB RAM, 50GB storage

### 2. Create a New Project in Coolify

1. Log in to your Coolify dashboard
2. Click on "New Project"
3. Name it "Marley Healthcare" or your preferred name
4. Select your server

### 3. Add a New Resource

1. In your project, click "New Resource"
2. Select "Docker Compose"
3. Choose "Public Repository"
4. Enter the repository URL: `https://github.com/charlesrolandscr17/marleyhealthapp_testapp`
5. Select the branch (usually `main`)
6. Coolify will automatically detect the `docker-compose.yml` file

### 4. Configure Environment Variables

In the Coolify environment configuration, add these variables:

```bash
# Required Variables
SITE_NAME=your-domain.com
ADMIN_PASSWORD=your-secure-password-here
DB_ROOT_PASSWORD=your-secure-db-password-here

# Database Configuration
DB_HOST=db
DB_PORT=3306

# Frontend Configuration
FRONTEND_PORT=8080

# Optional: Advanced Configuration
PROXY_READ_TIMEOUT=120
CLIENT_MAX_BODY_SIZE=50m
```

**Important**: Replace `your-domain.com` with your actual domain name.

### 5. Configure Domain

1. In the resource settings, go to "Domains"
2. Add your domain (e.g., `erp.yourdomain.com`)
3. Enable "SSL/TLS" - Coolify will automatically obtain a Let's Encrypt certificate
4. Save the configuration

### 6. Configure Port Mapping

Coolify should automatically detect port 8080 from the docker-compose.yml. If not:
1. Go to "Ports" section
2. Add port mapping: Container port `8080` → Public port `80` (or `443` for HTTPS)

### 7. Deploy the Application

1. Click "Deploy" button
2. Monitor the deployment logs
3. Wait for all services to start (this may take 5-10 minutes on first deployment)

### 8. Initialize the ERPNext Site (First Deployment Only)

Once the deployment is complete, you need to create the ERPNext site:

#### Option A: Using Coolify Terminal

1. In Coolify, go to your resource
2. Click on "Terminal" for the `backend` service
3. Run the following commands:

```bash
# Create the site
bench new-site your-domain.com --admin-password your-admin-password --db-root-password your-db-password

# Install ERPNext
bench --site your-domain.com install-app erpnext

# Install Marley Healthcare App
bench --site your-domain.com install-app marley_healthcare_app

# Set as current site
bench use your-domain.com
```

#### Option B: Using SSH

1. SSH into your Coolify server
2. Find the backend container:

```bash
docker ps | grep backend
```

3. Execute commands in the container:

```bash
# Replace CONTAINER_ID with your backend container ID
docker exec -it CONTAINER_ID bash

# Then run the same commands as Option A
bench new-site your-domain.com --admin-password your-admin-password --db-root-password your-db-password
bench --site your-domain.com install-app erpnext
bench --site your-domain.com install-app marley_healthcare_app
bench use your-domain.com
```

### 9. Access Your ERPNext Instance

1. Open your browser
2. Navigate to your configured domain (e.g., `https://erp.yourdomain.com`)
3. Log in with:
   - **Username**: Administrator
   - **Password**: The password you set in `ADMIN_PASSWORD`

## Post-Deployment Configuration

### Enable Scheduled Backups

Connect to the backend container and run:

```bash
bench --site your-domain.com set-config backup_schedule "0 3 * * *"
```

This sets up daily backups at 3 AM.

### Configure Email

1. Log in to ERPNext
2. Go to Settings > Email Domain
3. Configure your SMTP settings for email notifications

### Set Up Users

1. Go to User Management
2. Create user accounts for your team
3. Assign appropriate roles

## Monitoring and Maintenance

### View Logs

In Coolify:
1. Go to your resource
2. Click on "Logs" to view container logs
3. You can filter by service (backend, frontend, db, etc.)

### Resource Usage

Monitor resource usage in Coolify:
1. Go to "Metrics" section
2. Check CPU, Memory, and Disk usage
3. Scale up if needed

### Backups

Backups are stored in the `sites` volume. To access them:

```bash
docker exec -it BACKEND_CONTAINER_ID bash
cd sites/your-domain.com/private/backups
ls -lh
```

To download backups, use Coolify's file browser or SCP.

### Updates

To update ERPNext or the Marley Healthcare App:

1. In Coolify, go to your resource
2. Click "Redeploy" to pull latest changes
3. In the backend container, run:

```bash
bench update --reset
```

## Troubleshooting

### Issue: Site Not Loading

**Solution**:
1. Check if all containers are running: `docker ps`
2. View logs in Coolify
3. Ensure the site was created: `docker exec BACKEND_CONTAINER bench list-sites`

### Issue: Database Connection Error

**Solution**:
1. Check if the database container is healthy
2. Verify environment variables in Coolify
3. Check database logs in Coolify

### Issue: 502 Bad Gateway

**Solution**:
1. Wait a few minutes - services might still be starting
2. Restart the backend service in Coolify
3. Check backend container logs for errors

### Issue: SSL Certificate Problems

**Solution**:
1. Ensure your domain is properly pointed to the server
2. In Coolify, try regenerating the SSL certificate
3. Check if port 80 and 443 are accessible

## Advanced Configuration

### Custom Domain for Multiple Sites

To host multiple sites on the same deployment:

1. Create additional sites using the bench command
2. Configure Coolify to route different domains to different sites
3. Update the nginx configuration in the frontend container

### Scaling Workers

To add more background workers:

1. Edit the docker-compose.yml in your repository
2. Add more queue-short or queue-long services
3. Redeploy in Coolify

### Database Optimization

For better performance:

1. SSH into your server
2. Edit MariaDB configuration in the db container
3. Increase buffer sizes and connection limits

## Security Best Practices

1. **Always use HTTPS**: Coolify handles this automatically
2. **Strong passwords**: Use complex passwords for all accounts
3. **Regular updates**: Keep ERPNext and the app updated
4. **Firewall**: Ensure only necessary ports are open
5. **Backups**: Test backup restoration regularly
6. **Monitoring**: Set up alerts for unusual activity

## Support and Resources

- **Coolify Documentation**: https://coolify.io/docs
- **ERPNext Documentation**: https://docs.erpnext.com
- **Frappe Documentation**: https://frappeframework.com/docs
- **Community Forum**: https://discuss.erpnext.com

## Conclusion

Your Marley Healthcare App should now be successfully deployed on Coolify. For any issues, check the troubleshooting section or refer to the support resources.

Remember to:
- Monitor your instance regularly
- Keep backups up to date
- Update the application periodically
- Review security settings

Happy healthcare managing! 🏥
