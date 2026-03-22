*This project has been created as part of the 42 curriculum by chanypar.*

# Inception

## Description
The **Inception** project is a system administration challenge that focuses on using Docker to create a small, secure infrastructure. The goal is to set up a LEMP stack (Nginx, MariaDB, and WordPress) where each service runs in its own dedicated, isolated container. All services are built from scratch using custom Dockerfiles (based on Debian) and orchestrated through Docker Compose, ensuring a deep understanding of containerization and network isolation.

## Project Description
This project implements a microservices architecture. Instead of using pre-built images from Docker Hub, each service is carefully configured via a \`Dockerfile\` to ensure security and specific version control.

### Main Design Choices
- **Minimalist Base**: All containers are based on a stable version of Debian to minimize the attack surface.
- **TLS Protocol**: Only TLS v1.2 or v1.3 is allowed for Nginx to ensure modern encryption standards.
- **Rootless/Isolated approach**: Services communicate only through a dedicated Docker internal network.

### Comparative Analysis
| Feature | Virtual Machines | Docker (Containers) |
| :--- | :--- | :--- |
| **Virtualization** | Hardware-level (Hypervisor) | OS-level (Kernel sharing) |
| **Weight** | Heavy (includes full OS) | Lightweight (shares host kernel) |
| **Boot Time** | Minutes | Seconds |

| Feature | Secrets | Environment Variables |
| :--- | :--- | :--- |
| **Security** | High (Encrypted, restricted access) | Low (Visible in process logs/\`env\`) |
| **Best Use Case** | DB passwords, private keys | Config flags, non-sensitive paths |

| Feature | Docker Network | Host Network |
| :--- | :--- | :--- |
| **Isolation** | High (Isolated bridge between containers) | Low (Uses host's IP stack directly) |
| **Port Management** | Flexible mapping (e.g., 443 -> 8443) | Restricted to host's available ports |

| Feature | Docker Volumes | Bind Mounts |
| :--- | :--- | :--- |
| **Management** | Managed by Docker (abstracted) | Linked to specific host file paths |
| **Portability** | High (Internal to Docker system) | Low (Depends on host file structure) |

## Instructions
### Prerequisites
- Docker and Docker-compose must be installed.
- Add \`127.0.0.1 chanypar.42.fr\` to your \`/etc/hosts\` file.

### Installation & Execution
1. Clone this repository.
2. Run the following command in the root directory:
   \`\`\`bash
   make
   \`\`\`
3. To stop and remove all containers:
   \`\`\`bash
   make clean
   \`\`\`

## Resources
### Official Documentation & Tutorials
* **Docker Engine & Compose**: [Docker Documentation](https://docs.docker.com/)
* **Nginx**: [Nginx HTTPS Guide](https://nginx.org/en/docs/http/configuring_https_servers.html)
* **WP-CLI**: [WP-CLI Commands](https://developer.wordpress.org/cli/commands/)
* **MariaDB**: [MariaDB Knowledge Base](https://mariadb.com/kb/en/)

### AI Usage Disclosure
AI (Generative AI) was used for:
1. **Documentation Structure**: Formatting Markdown files to meet subject requirements.
2. **Conceptual Comparison**: Summarizing technical differences between Volumes vs Bind Mounts.
3. **Troubleshooting**: Debugging Nginx TLS 1.3 configuration and Makefile rules.
