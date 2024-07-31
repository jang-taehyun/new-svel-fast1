#!/bin/sh

# Alembic 마이그레이션 실행
alembic upgrade head

# Uvicorn 서버 실행
uvicorn main:app --host 0.0.0.0 --port 8000