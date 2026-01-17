.PHONY: help up down restart logs ps clean build shell-zabbix shell-grafana shell-db backup restore

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

up: ## Start all services
	@echo "Starting Zabbix monitoring stack..."
	docker-compose up -d
	@echo "Stack started! Access:"
	@echo "  Zabbix Web: http://localhost:8081 (Admin/zabbix)"
	@echo "  Grafana:    http://localhost:3000 (admin/admin)"
	@echo "  Laravel:    http://localhost:8080"

down: ## Stop all services
	@echo "Stopping stack..."
	docker-compose down

restart: ## Restart all services
	@echo "Restarting stack..."
	docker-compose restart

logs: ## View logs (use: make logs s=zabbix-server)
	@if [ -z "$(s)" ]; then \
		docker-compose logs -f; \
	else \
		docker-compose logs -f $(s); \
	fi

ps: ## List running containers
	docker-compose ps

clean: ## Stop and remove all containers, volumes and images
	@echo "Cleaning up..."
	docker-compose down -v --rmi local
	@echo "Cleanup complete!"

build: ## Rebuild containers
	docker-compose build --no-cache

shell-zabbix: ## Access Zabbix server shell
	docker exec -it zabbix-server /bin/bash

shell-grafana: ## Access Grafana shell
	docker exec -it grafana /bin/bash

shell-db: ## Access PostgreSQL shell
	docker exec -it zabbix-db psql -U $${POSTGRES_USER:-zabbix} -d $${POSTGRES_DB:-zabbix}

backup: ## Backup Zabbix database
	@echo "Backing up Zabbix database..."
	@mkdir -p backups
	docker exec zabbix-db pg_dump -U $${POSTGRES_USER:-zabbix} $${POSTGRES_DB:-zabbix} > backups/zabbix_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "Backup saved to backups/"

restore: ## Restore Zabbix database (use: make restore f=backup_file.sql)
	@if [ -z "$(f)" ]; then \
		echo "Usage: make restore f=backups/zabbix_backup_YYYYMMDD_HHMMSS.sql"; \
	else \
		echo "Restoring from $(f)..."; \
		docker exec -i zabbix-db psql -U $${POSTGRES_USER:-zabbix} $${POSTGRES_DB:-zabbix} < $(f); \
		echo "Restore complete!"; \
	fi

health: ## Check health of all services
	@echo "Checking services health..."
	@docker-compose ps --format "table {{.Name}}\t{{.Status}}"

status: ## Show detailed status
	@echo "=== Container Status ==="
	@docker-compose ps
	@echo ""
	@echo "=== Resource Usage ==="
	@docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
