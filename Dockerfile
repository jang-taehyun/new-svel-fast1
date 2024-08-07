#FROM public.ecr.aws/docker/library/python:3.9-slim
FROM python:3.9-alpine

COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt

RUN chmod +x entrypoint.sh
#
ENV DB_URL=mysql+pymysql://root:test123@database-1.c1ass4wwycc9.ap-northeast-2.rds.amazonaws.com/db
ENTRYPOINT ["sh", "/app/entrypoint.sh"]
