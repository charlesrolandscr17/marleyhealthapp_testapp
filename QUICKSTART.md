# Quick Start Guide

## 🚀 Fast Setup (5 minutes)

### Prerequisites
- Docker & Docker Compose installed
- 4GB+ RAM available
- 10GB+ disk space

### Steps

1. **Clone the repository**
```bash
git clone https://github.com/charlesrolandscr17/marleyhealthapp_testapp.git
cd marleyhealthapp_testapp
```

2. **Run the automated setup** (Easiest method)
```bash
chmod +x setup.sh
./setup.sh
```

The script will:
- Create environment configuration
- Start all Docker services
- Create a new ERPNext site
- Install ERPNext and Marley Healthcare App
- Configure everything automatically

3. **Access your instance**
- URL: http://localhost:8080
- Username: Administrator
- Password: (the one you set during setup)

---

## 🛠️ Manual Setup

If you prefer manual setup:

1. **Configure environment**
```bash
cp .env.example .env
# Edit .env with your settings
```

2. **Start services**
```bash
docker compose up -d
```

3. **Wait for services to be ready** (1-2 minutes)
```bash
docker compose ps
```

4. **Create site and install apps**
```bash
# Create site
docker compose exec backend bench new-site erp.marleyhealthcare.local \
  --admin-password admin \
  --db-root-password admin

# Install ERPNext
docker compose exec backend bench --site erp.marleyhealthcare.local install-app erpnext

# Install Marley Healthcare App
docker compose exec backend bench --site erp.marleyhealthcare.local install-app marley_healthcare_app
```

5. **Access**: http://localhost:8080

---

## 📦 What's Included

- **ERPNext v15**: Full ERP system
- **Marley Healthcare App**: Custom healthcare module
- **MariaDB**: Database
- **Redis**: Caching and queues
- **Nginx**: Web server
- **Background Workers**: For async tasks
- **Scheduler**: For cron jobs

---

## 🌐 Deploy to Coolify

1. Create new Docker Compose resource in Coolify
2. Connect this GitHub repository
3. Set environment variables (see `.env.example`)
4. Deploy!
5. Run initialization commands (see COOLIFY_DEPLOYMENT.md)

Full Coolify guide: [COOLIFY_DEPLOYMENT.md](COOLIFY_DEPLOYMENT.md)

---

## 🆘 Common Issues

### Services not starting?
```bash
docker compose logs -f
```

### Need to restart?
```bash
docker compose restart
```

### Want to start fresh?
```bash
docker compose down -v
docker compose up -d
```

---

## 📚 Documentation

- [Full README](README.md) - Complete documentation
- [Coolify Deployment](COOLIFY_DEPLOYMENT.md) - Deploy on Coolify
- [ERPNext Docs](https://docs.erpnext.com) - ERPNext documentation

---

## 🎯 Next Steps

After setup:
1. ✅ Log in to ERPNext
2. ✅ Complete setup wizard
3. ✅ Explore the Marley Healthcare module
4. ✅ Create users and assign roles
5. ✅ Configure email settings
6. ✅ Set up backups

---

**Need help?** Check the [full README](README.md) or open an issue on GitHub.
