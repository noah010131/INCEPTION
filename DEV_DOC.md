# DEV_DOC.md - Developer Documentation

## 1. Environment Setup
- **Prerequisites**: Debian-based VM, Docker, Docker Compose, and Make.
- **Setup**: Create a \`.env\` file based on the subject's requirements before building.

## 2. Build and Launch
- Use the **Makefile** for all operations.
- \`make\`: Builds images and starts containers.
- \`make fclean\`: Full cleanup including volumes and data.

## 3. Management Commands
- **Access Container**: \`docker exec -it <container_name> sh\`
- **Check Network**: \`docker network ls\`
- **Check Volumes**: \`docker volume ls\`

## 4. Data Persistence
- Data is stored in Docker Volumes.
- Mapped to host paths: \`/home/chanypar/data/wordpress\` and \`/home/chanypar/data/mariadb\`.