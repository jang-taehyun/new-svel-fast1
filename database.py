
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import os

# DATABASE_URL = "mysql+pymysql://user:1234@211.183.3.10/db"
DATABASE_URL = os.getenv("DB_URL","mysql+pymysql://user:test1234@database-1.c5kqucccw075.ap-northeast-2.rds.amazonaws.com/db")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()