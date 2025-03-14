FROM python:3.8-slim-bullseye

EXPOSE 8000

# 设置当前目录为工作目录
WORKDIR /app

COPY . /app

# apt-get换源并安装依赖（使用腾讯镜像）
RUN sed -i "s@http://deb.debian.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list
RUN cat /etc/apt/sources.list
RUN apt-get update && apt-get install -y libgl1 libgomp1 libglib2.0-0 libsm6 libxrender1 libxext6
# 清理apt-get缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# pip换源并安装python依赖（使用腾讯镜像）
RUN python3 -m pip install -i https://mirrors.cloud.tencent.com/pypi/simple --upgrade pip
RUN pip3 config set global.index-url https://mirrors.cloud.tencent.com/pypi/simple
RUN pip3 install -r requirements.txt

# CMD ["python3", "./main.py"]
CMD ["uvicorn", "main:app", "--host", "0.0.0.0"]
