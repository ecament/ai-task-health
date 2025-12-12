.PHONY: help install test run explain clean

help:
	@echo "VM Health Check Script - Makefile Commands"
	@echo "=========================================="
	@echo ""
	@echo "Available commands:"
	@echo "  make install   - Make scripts executable"
	@echo "  make run       - Run health check"
	@echo "  make explain   - Show detailed parameter explanations"
	@echo "  make test      - Run test suite"
	@echo "  make monitor   - Continuous monitoring (updates every 5 seconds)"
	@echo "  make clean     - Remove generated files"
	@echo "  make help      - Show this help message"
	@echo ""

install:
	@chmod +x scripts/healthcheck.sh scripts/test.sh
	@echo "✓ Scripts are now executable"

run: install
	@./scripts/healthcheck.sh

explain: install
	@./scripts/healthcheck.sh explain

test: install
	@bash scripts/test.sh

monitor: install
	@while true; do clear; ./scripts/healthcheck.sh; sleep 5; done

clean:
	@rm -f *.log
	@rm -rf __pycache__
	@echo "✓ Cleaned up temporary files"

.DEFAULT_GOAL := help
