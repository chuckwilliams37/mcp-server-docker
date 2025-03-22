from fastapi import FastAPI
from pydantic import BaseModel
import redis
import os
from dotenv import load_dotenv

load_dotenv()  # Load .env into environment

# Redis connection from env
redis_host = os.getenv("REDIS_HOST", "localhost")
redis_port = int(os.getenv("REDIS_PORT", "6379"))
redis_client = redis.Redis(host=redis_host, port=redis_port)

app = FastAPI()

class Input(BaseModel):
    message: str

@app.post("/predict")
def predict(input: Input):
    redis_client.set("last_input", input.message)
    return {"echo": input.message}
