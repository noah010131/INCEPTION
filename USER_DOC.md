# USER_DOC.md - User Documentation

## 1. Services Overview
This stack provides:
- **Nginx**: Secure HTTPS entry point.
- **WordPress**: Website management system.
- **MariaDB**: Database for all site content.

## 2. Starting and Stopping
- **Start**: Run \`make\` in the root directory.
- **Stop**: Run \`make down\` to stop containers.
- **Reset**: Run \`make re\` to rebuild and restart.

## 3. Accessing the Project
- **Website**: \`https://<login>.42.fr\`
- **Admin Panel**: \`https://<login>.42.fr/wp-admin\`
*Note: Accept the self-signed certificate warning in your browser.*

## 4. Managing Credentials
- All credentials are stored in the \`.env\` file in the root directory.
- Edit this file to change database or admin passwords, then restart the services.

## 5. Health Check
- Run \`docker ps\` to ensure all containers are "Up".
- Check \`docker-compose logs -f\` if any service fails to start.