# demo-fastapi-crud-api

## 環境
- Python 3.11.4

## 仮想環境作成
```
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## サーバ起動
```
uvicorn app.main:app --reload
```

## APIドキュメント
```
# Swagger形式
http://127.0.0.1:8000/docs

# ReDoc形式
http://127.0.0.1:8000/redoc
```

## (参考)初期構築時にインストールしたもの
```
pip install fastapi
pip install sqlalchemy
pip install "uvicorn[standard]"
pip install flake8 black isort mypy

pip freeze > requirements.txt
```
