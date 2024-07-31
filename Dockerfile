#FROM public.ecr.aws/docker/library/python:3.9-slim
FROM python:3.9-slim

COPY . /app
WORKDIR /app

RUN pip install -r requirements.txt

RUN chmod +x entrypoint.sh
#
ENV DB_URL=mysql+pymysql://user:test1234@database-1.c5kqucccw075.ap-northeast-2.rds.amazonaws.com/db
ENTRYPOINT ["/app/entrypoint.sh"]
