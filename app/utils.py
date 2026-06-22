import os
import io
import pypdf
from google import genai

def extract_text_from_pdf(file_bytes: bytes) -> str:
    """
    Parses the incoming PDF bytes and extracts raw text.
    """
    # This line strictly requires 'import io' at the top of the file!
    reader = pypdf.PdfReader(io.BytesIO(file_bytes))
    text = ""
    for page in reader.pages:
        text += page.extract_text() or ""
    return text

def analyze_resume_with_ai(resume_text: str) -> str:
    """
    Sends parsed resume data to Gemini API for structural evaluation.
    """
    # Using os.environ.get ensures it reads the key from Docker's system environment
    client = genai.Client(api_key=os.environ.get("GEMINI_API_KEY"))
    
    system_prompt = "You are an expert technical recruiter analyzing a resume."
    user_prompt = f"Analyze this resume content and provide structural feedback:\n\n{resume_text}"
    
    try:
        response = client.models.generate_content(
            model='gemini-2.5-flash',
            contents=f"{system_prompt}\n\n{user_prompt}"
        )
        return response.text
        
    except Exception as e:
        raise Exception(f"Gemini API Processing Failed: {str(e)}")
