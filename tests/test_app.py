from fastapi.testclient import TestClient
from src.project.app import app

client = TestClient(app)


def test_index():
    response = client.get("/")
    assert response.status_code == 200
