from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from app.utils import extract_text_from_pdf, analyze_resume_with_ai

app = FastAPI(title="AI Resume Analyzer API")

# Configure CORS Middleware
# This allows your frontend browser application to communicate with your backend port
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins; change to specific domain/port in production
    allow_credentials=True,
    allow_methods=["*"],  # Allows all HTTP methods (POST, GET, etc.)
    allow_headers=["*"],  # Allows all headers
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the AI Resume Analyzer API"}

@app.post("/analyze")
async def analyze_resume(file: UploadFile = File(...)):
    if not file.filename.endswith('.pdf'):
        raise HTTPException(status_code=400, detail="Only PDF files are supported.")
    
    try:
        # Read the file bytes directly
        file_bytes = await file.read()
        
        # Extract text using the utility function
        text = extract_text_from_pdf(file_bytes)
        
        if not text.strip():
            raise HTTPException(status_code=400, detail="The PDF file appears to be empty or unreadable.")
        
        # Get AI optimization metrics
        analysis_result = analyze_resume_with_ai(text)
        
        return {"filename": file.filename, "analysis": analysis_result}
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"An internal error occurred during processing: {str(e)}")
