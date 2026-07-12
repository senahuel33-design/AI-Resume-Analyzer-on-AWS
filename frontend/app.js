document.addEventListener('DOMContentLoaded', () => {
    const uploadForm = document.getElementById('uploadForm');
    const resumeInput = document.getElementById('resumeFile');
    const resultsSection = document.getElementById('resultsSection');
    const loadingDiv = document.getElementById('loading');
    const outputDiv = document.getElementById('analysisOutput');
    const dropZone = document.querySelector('.drop-zone');

    // Simple click event forward to file input
    dropZone.addEventListener('click', () => resumeInput.click());

    // Show selected filename inside dropzone prompt
    resumeInput.addEventListener('change', () => {
        if (resumeInput.files.length) {
            document.querySelector('.drop-zone__prompt').textContent = resumeInput.files[0].name;
        }
    });

    uploadForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        if (!resumeInput.files.length) return alert('Please select a file first.');

        const formData = new FormData();
        formData.append('file', resumeInput.files[0]);

        // Unhide results framework layout
        resultsSection.classList.remove('hidden');
        loadingDiv.classList.remove('hidden');
        outputDiv.textContent = '';

        try {
            // Fetch request straight to your Dockerized port 8000
            const response = await fetch('http://52.212.94.212:8000/analyze', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (!response.ok) {
                throw new Error(data.detail || 'An error occurred during verification.');
            }

            // Print the Gemini analysis text response directly to the page!
            outputDiv.textContent = data.analysis;

        } catch (error) {
            outputDiv.textContent = `❌ Error: ${error.message}`;
        } finally {
            loadingDiv.classList.add('hidden');
        }
    });
});
