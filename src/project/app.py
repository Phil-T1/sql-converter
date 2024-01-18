from fastapi import FastAPI
from fastapi import Request
import uvicorn
from fastapi.templating import Jinja2Templates

app = FastAPI()
templates = Jinja2Templates(directory="templates")


@app.get("/")
def index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


if __name__ == "__main__":
    uvicorn.run(
        "app:app", host="0.0.0.0", port=8090, reload=True
    )  # pragma: no cover
