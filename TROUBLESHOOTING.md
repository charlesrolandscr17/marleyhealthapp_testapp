# Troubleshooting Guide

Common issues and solutions for the Marley Healthcare App setup.

## Installation Issues

### Docker Compose Not Found

**Error**: `bash: docker-compose: command not found`

**Solution**: 
- Modern Docker includes compose as a subcommand
- Use `docker compose` instead of `docker-compose`
- Or install docker-compose separately: `pip install docker-compose`

### Permission Denied

**Error**: `permission denied while trying to connect to the Docker daemon socket`

**Solution**:
```bash
# Add your user to the docker group
sudo usermod -aG docker $USER
# Log out and back in, then try again
```

### Port Already in Use

**Error**: `Bind for 0.0.0.0:8080 failed: port is already allocated`

**Solution**:
```bash
# Change the port in .env file
FRONTEND_PORT=8081

# Or stop the service using port 8080
sudo lsof -ti:8080 | xargs kill -9
```

## Site Creation Issues

### Site Already Exists

**Error**: `Site already exists`

**Solution**:
```bash
# List existing sites
docker compose exec backend bench list-sites

# Remove the site if needed
docker compose exec backend bench drop-site sitename --force

# Or use a different site name
```

### Database Connection Failed

**Error**: `Could not connect to database`

**Solution**:
```bash
# Check if database is healthy
docker compose ps db

# Check database logs
docker compose logs db

# Verify database password in .env matches
# Wait a bit longer for database to initialize (can take 1-2 minutes)
```

### Bench Command Not Found

**Error**: `bench: command not found`

**Solution**:
```bash
# Ensure you're running commands inside the backend container
docker compose exec backend bench --version

# Not directly on host
```

## Runtime Issues

### 502 Bad Gateway

**Symptoms**: Nginx shows 502 Bad Gateway error

**Solutions**:
1. **Services still starting**: Wait 2-3 minutes for all services to initialize
2. **Backend crashed**: 
   ```bash
   docker compose logs backend
   docker compose restart backend
   ```
3. **No site configured**:
   ```bash
   docker compose exec backend bench list-sites
   # If empty, create a site (see QUICKSTART.md)
   ```

### Site Not Loading

**Symptoms**: Blank page or "Site not found" error

**Solutions**:
```bash
# 1. Check if site exists
docker compose exec backend bench list-sites

# 2. Set the site as current site
docker compose exec backend bench use your-site-name

# 3. Check site config
docker compose exec backend cat sites/your-site-name/site_config.json

# 4. Clear cache
docker compose exec backend bench --site your-site-name clear-cache

# 5. Restart services
docker compose restart
```

### Slow Performance

**Symptoms**: Pages loading slowly

**Solutions**:
1. **Increase RAM**: Ensure Docker has at least 4GB RAM allocated
2. **Check resources**:
   ```bash
   docker stats
   ```
3. **Optimize database**:
   ```bash
   docker compose exec backend bench --site your-site-name optimize-assets
   docker compose exec backend bench --site your-site-name build
   ```

### Background Jobs Not Running

**Symptoms**: Scheduled tasks or background jobs not executing

**Solutions**:
```bash
# Check if workers are running
docker compose ps queue-short queue-long scheduler

# Restart workers
docker compose restart queue-short queue-long scheduler

# Check worker logs
docker compose logs queue-short
docker compose logs queue-long
docker compose logs scheduler
```

## App Installation Issues

### App Not Found

**Error**: `App marley_healthcare_app not found`

**Solution**:
```bash
# Verify app is mounted
docker compose exec backend ls -la apps/marley_healthcare_app

# Rebuild and restart
docker compose restart backend

# Try installing again
docker compose exec backend bench --site your-site-name install-app marley_healthcare_app
```

### Module Import Error

**Error**: `ModuleNotFoundError: No module named 'marley_healthcare_app'`

**Solution**:
```bash
# Ensure app is in apps.txt
docker compose exec backend cat sites/apps.txt

# If not, add it
docker compose exec backend bash -c "echo marley_healthcare_app >> sites/apps.txt"

# Restart services
docker compose restart
```

## Data Issues

### Lost Data After Restart

**Symptoms**: Data disappears after `docker compose down`

**Solution**:
- **NEVER** use `docker compose down -v` as it removes volumes
- Use `docker compose down` (without -v) to preserve data
- Volumes are persistent by default

### Cannot Delete DocType

**Error**: `Cannot delete DocType: Links exist`

**Solution**:
```bash
# Check linked records
docker compose exec backend bench --site your-site-name console

# In console:
>>> frappe.get_all("DocType Name", fields=["*"])

# Delete linked records first, then the DocType
```

### Database Backup Failed

**Error**: Backup command fails

**Solution**:
```bash
# Check disk space
df -h

# Manual backup
docker compose exec backend bench --site your-site-name backup --with-files

# Check backup location
docker compose exec backend ls -lh sites/your-site-name/private/backups/
```

## Coolify-Specific Issues

### Deployment Failed

**Solution**:
1. Check Coolify logs for specific error
2. Verify environment variables are set
3. Ensure domain is properly configured
4. Check if ports are available

### SSL Certificate Not Working

**Solution**:
1. Verify domain DNS is pointing to server
2. Wait a few minutes for certificate generation
3. Check if ports 80 and 443 are open
4. Regenerate certificate in Coolify UI

### Health Check Failing

**Solution**:
```bash
# Check service health
docker compose ps

# View health check logs
docker compose logs frontend

# May need to adjust health check timeout in Coolify
```

## Docker Issues

### Out of Disk Space

**Error**: `no space left on device`

**Solution**:
```bash
# Clean up Docker
docker system prune -a --volumes

# Remove unused images
docker image prune -a

# Check disk usage
docker system df
```

### Container Keeps Restarting

**Solution**:
```bash
# Check logs for the failing container
docker compose logs [service-name]

# Common causes:
# - Wrong credentials in .env
# - Database not ready (wait longer)
# - Port conflicts
# - Insufficient memory
```

### Cannot Connect to Redis

**Error**: `Connection refused: redis-cache:6379`

**Solution**:
```bash
# Check if Redis containers are running
docker compose ps redis-cache redis-queue

# Restart Redis
docker compose restart redis-cache redis-queue

# Check Redis logs
docker compose logs redis-cache
docker compose logs redis-queue
```

## Development Issues

### Changes Not Reflecting

**Symptoms**: Code changes not visible in the app

**Solution**:
```bash
# Clear cache
docker compose exec backend bench --site your-site-name clear-cache

# Rebuild assets
docker compose exec backend bench --site your-site-name build

# Restart backend
docker compose restart backend
```

### Cannot Create DocType

**Error**: Permission denied or DocType creation fails

**Solution**:
1. Ensure you're logged in as Administrator
2. Enable Developer Mode:
   ```bash
   docker compose exec backend bench --site your-site-name set-config developer_mode 1
   docker compose restart backend
   ```

## Network Issues

### Cannot Access from Outside

**Symptoms**: Works on localhost but not from other machines

**Solution**:
```bash
# Change bind address in docker-compose.yml ports section
# From: "8080:8080"
# To: "0.0.0.0:8080:8080"

docker compose up -d
```

### DNS Resolution Failed

**Error**: Container cannot resolve service names

**Solution**:
```bash
# Recreate network
docker compose down
docker compose up -d

# Or specify custom DNS in docker-compose.yml
```

## Getting Help

If none of the above solutions work:

1. **Check logs**: 
   ```bash
   docker compose logs -f
   ```

2. **Check ERPNext Forum**: https://discuss.erpnext.com/

3. **Check Frappe Forum**: https://discuss.frappe.io/

4. **GitHub Issues**: Open an issue with:
   - Error message
   - Steps to reproduce
   - Docker version
   - OS version
   - Relevant logs

## Useful Commands

```bash
# View all logs
docker compose logs -f

# View specific service logs
docker compose logs -f backend

# Check container status
docker compose ps

# Restart a service
docker compose restart [service-name]

# Stop all services
docker compose down

# Start services
docker compose up -d

# Access backend shell
docker compose exec backend bash

# Access database
docker compose exec db mysql -uroot -p

# Check disk usage
docker system df

# Clean up
docker system prune
```

## Prevention Tips

1. **Regular backups**: Schedule automatic backups
2. **Monitor resources**: Keep an eye on CPU, RAM, and disk
3. **Update regularly**: Keep Docker and images updated
4. **Use .env file**: Never hardcode credentials
5. **Version control**: Keep docker-compose.yml in git
6. **Test changes**: Test in development before production
7. **Document customizations**: Keep notes on changes made

---

**Remember**: When in doubt, check the logs first! Most issues can be diagnosed from the logs.
