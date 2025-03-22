from fastapi import FastAPI
from pydantic import BaseModel
import redis

app = FastAPI()
redis_client = redis.Redis(host="redis", port=6379)

class Input(BaseModel):
    message: str

@app.post("/predict")
def predict(input: Input):
    redis_client.set("last_input", input.message)
    return {"echo": input.message}
