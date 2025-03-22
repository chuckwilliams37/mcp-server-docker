from fastapi import FastAPI
from pydantic import BaseModel
import redis
import os
from dotenv import load_dotenv
from mcp import MCPServer, resource, tool

load_dotenv()  # Load .env into environment

# Redis connection from env
redis_host = os.getenv("REDIS_HOST", "localhost")
redis_port = int(os.getenv("REDIS_PORT", "6379"))
redis_client = redis.Redis(host=redis_host, port=redis_port)

app = FastAPI()

mcp_server = MCPServer(app)

@resource("greeting://{name}")
def get_greeting(name: str) -> str:
    """Get a personalized greeting"""
    return f"Hello, {name}!"

mcp_server.add_resource(get_greeting)

@resource("data://item/{item_id}")
def get_item(item_id: int) -> dict:
    """Retrieve item details by ID"""
    # Logic to fetch item details
    return {"id": item_id, "name": "Sample Item"}

mcp_server.add_resource(get_item)


@tool("calculator")
def calculate(expression: str) -> float:
    """Evaluate a mathematical expression"""
    return eval(expression)

mcp_server.add_tool(calculate)

@prompt("summarize")
def summarize(text: str) -> str:
    """Summarize the provided text"""
    # Logic to summarize text
    return "Summary of the text."

mcp_server.add_prompt(summarize)

class Input(BaseModel):
    message: str

@app.post("/predict")
def predict(input: Input):
    redis_client.set("last_input", input.message)
    return {"echo": input.message}
