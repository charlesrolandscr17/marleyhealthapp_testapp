# Project Structure

This document describes the structure and purpose of all files in this repository.

## Root Directory

```
marleyhealthapp_testapp/
├── .env.example                    # Environment variable template
├── .gitignore                      # Git ignore rules
├── COOLIFY_DEPLOYMENT.md           # Coolify deployment guide
├── Dockerfile                      # Custom Docker image build
├── LICENSE                         # MIT License
├── MANIFEST.in                     # Python package manifest
├── QUICKSTART.md                   # Quick setup guide
├── README.md                       # Main documentation
├── TROUBLESHOOTING.md              # Troubleshooting guide
├── docker-compose.yml              # Docker Compose configuration
├── marley_healthcare_app/          # Frappe app directory
├── requirements.txt                # Python dependencies
├── setup.py                        # Python package setup
└── setup.sh                        # Automated setup script
```

## Documentation Files

### README.md
- **Purpose**: Main documentation hub
- **Contents**: 
  - Project overview
  - Prerequisites
  - Installation instructions
  - Architecture details
  - Backup procedures
  - Production considerations

### QUICKSTART.md
- **Purpose**: Fast setup for users who want to get started quickly
- **Contents**:
  - 5-minute setup guide
  - Manual and automated setup options
  - Quick troubleshooting
  - Next steps

### COOLIFY_DEPLOYMENT.md
- **Purpose**: Comprehensive Coolify deployment guide
- **Contents**:
  - Step-by-step Coolify setup
  - Environment configuration
  - Domain setup
  - Site initialization
  - Post-deployment tasks
  - Troubleshooting specific to Coolify

### TROUBLESHOOTING.md
- **Purpose**: Common issues and solutions
- **Contents**:
  - Installation issues
  - Runtime problems
  - Development issues
  - Network problems
  - Docker issues
  - Useful commands

## Configuration Files

### .env.example
- **Purpose**: Template for environment variables
- **Contains**:
  - Database credentials
  - Site name
  - Admin password
  - Port configurations
  - Proxy settings
- **Usage**: Copy to `.env` and customize

### docker-compose.yml
- **Purpose**: Defines all services for ERPNext deployment
- **Services**:
  - `backend`: ERPNext application server
  - `frontend`: Nginx web server
  - `websocket`: Real-time communication
  - `queue-short`: Short background tasks
  - `queue-long`: Long background tasks
  - `scheduler`: Cron job scheduler
  - `db`: MariaDB database
  - `redis-cache`: Caching layer
  - `redis-queue`: Job queue
  - `configurator`: Initial configuration
- **Features**:
  - Health checks
  - Automatic restarts
  - Volume persistence
  - Service dependencies
  - Environment variable support

### Dockerfile
- **Purpose**: Custom Docker image with Marley Healthcare app
- **Based on**: frappe/erpnext:v15.35.0
- **Adds**: Marley Healthcare app installation

### .gitignore
- **Purpose**: Excludes files from version control
- **Ignores**:
  - Environment files (.env)
  - Python cache
  - Docker volumes
  - IDE files
  - OS-specific files

## Python Package Files

### setup.py
- **Purpose**: Python package setup for pip installation
- **Contains**:
  - Package metadata
  - Dependencies
  - Version information

### requirements.txt
- **Purpose**: Lists Python dependencies
- **Contains**: frappe (main dependency)

### MANIFEST.in
- **Purpose**: Specifies files to include in package distribution
- **Includes**:
  - Python files
  - JSON files
  - Static assets
  - Templates

## Scripts

### setup.sh
- **Purpose**: Automated installation script
- **Features**:
  - Checks Docker installation
  - Supports both `docker-compose` and `docker compose`
  - Creates .env file if missing
  - Prompts for configuration
  - Starts all services
  - Creates ERPNext site
  - Installs apps
- **Usage**: `chmod +x setup.sh && ./setup.sh`

## Marley Healthcare App Directory

```
marley_healthcare_app/
├── __init__.py                     # App version definition
├── config/                         # Configuration files
│   ├── __init__.py
│   └── desktop.py                  # Desktop/module icon config
├── hooks.py                        # App hooks and configurations
├── marley_healthcare/              # Main module
│   ├── __init__.py
│   └── module.json                 # Module definition
├── modules/                        # Additional modules (empty)
├── modules.txt                     # List of modules
└── public/                         # Static files (empty)
```

### marley_healthcare_app/__init__.py
- **Purpose**: Defines app version
- **Contains**: `__version__ = '0.0.1'`

### marley_healthcare_app/hooks.py
- **Purpose**: Main app configuration
- **Contains**:
  - App metadata (name, title, publisher)
  - Includes (CSS, JS)
  - Document event hooks
  - Scheduled tasks hooks
  - Permission overrides
  - Custom methods
- **Format**: Python dictionary with configuration options

### marley_healthcare_app/modules.txt
- **Purpose**: Lists all modules in the app
- **Contains**: "Marley Healthcare"

### marley_healthcare_app/config/desktop.py
- **Purpose**: Configures desktop icon for the app
- **Contains**: get_data() function returning configuration dict
- **Defines**:
  - Category
  - Label
  - Icon (octicon octicon-heart)
  - Color (#FF6B6B)

### marley_healthcare_app/marley_healthcare/module.json
- **Purpose**: Defines the Marley Healthcare module
- **Contains**:
  - Module name
  - Creation/modification dates
  - Owner information
- **Format**: JSON

## Docker Volumes

Created automatically by Docker Compose:

- **db-data**: MariaDB database files
- **redis-cache-data**: Redis cache data
- **redis-queue-data**: Redis queue data
- **sites**: ERPNext site files and assets
- **logs**: Application logs

## License

### LICENSE
- **Type**: MIT License
- **Copyright**: 2024 Marley Healthcare
- **Permissions**: Commercial use, modification, distribution, private use

## Key Concepts

### Frappe App Structure
A Frappe app must have:
1. `hooks.py` - App configuration
2. `__init__.py` - Version definition
3. `modules.txt` - Module list
4. Module directories with `module.json`

### ERPNext Deployment
The setup includes:
- Application server (backend)
- Web server (frontend/nginx)
- Database (MariaDB)
- Caching (Redis)
- Background workers
- Scheduler

### Coolify Compatibility
- Uses Docker Compose v2 format
- Environment variable driven
- Health checks for all services
- Proper service dependencies
- Volume persistence

## File Sizes

| File | Size | Type |
|------|------|------|
| README.md | 7.1 KB | Documentation |
| COOLIFY_DEPLOYMENT.md | 7.1 KB | Documentation |
| TROUBLESHOOTING.md | 8.8 KB | Documentation |
| docker-compose.yml | 5.8 KB | Configuration |
| hooks.py | 4.7 KB | Python |
| setup.sh | 2.8 KB | Shell Script |
| QUICKSTART.md | 2.8 KB | Documentation |

Total documentation: ~26 KB
Total configuration: ~10 KB

## Development Workflow

1. **Initial Setup**: Run `./setup.sh` or follow QUICKSTART.md
2. **Customization**: Edit files in `marley_healthcare_app/`
3. **Testing**: Use development site with Docker Compose
4. **Deployment**: Deploy to Coolify following COOLIFY_DEPLOYMENT.md
5. **Troubleshooting**: Refer to TROUBLESHOOTING.md for issues

## Best Practices

1. **Never commit .env**: Contains sensitive credentials
2. **Use volumes for data**: Never delete volumes with `-v` flag
3. **Regular backups**: Use built-in ERPNext backup
4. **Monitor resources**: Check Docker stats regularly
5. **Update carefully**: Test updates in development first

## Support Resources

- **ERPNext Docs**: https://docs.erpnext.com
- **Frappe Docs**: https://frappeframework.com/docs
- **Docker Docs**: https://docs.docker.com
- **Coolify Docs**: https://coolify.io/docs

---

For detailed information on any component, refer to the respective documentation files.
