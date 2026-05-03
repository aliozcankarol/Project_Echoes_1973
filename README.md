# Echoes of 1973: Knockin' on Heaven's Door

> *“Mama, take this badge off of me / I can't use it anymore.”*

**Course:** CSE 358 Introduction to Artificial Intelligence  
**Project:** Generative AI Art Installation

---

## 🚪 Artistic Statement & Project Philosophy

*Echoes of 1973* is an interactive digital art installation exploring the thematic intersections of farewell, transition, and the unknown—anchored by Bob Dylan's seminal 1973 track, "Knockin' on Heaven's Door." 

In Dylan's narrative, the "door" represents the ultimate threshold between the known world and the great beyond. This project reinterprets that threshold through the lens of modern Generative AI. The AI's **latent space**—a vast, multidimensional mathematical void where concepts and images reside before they are brought into existence—acts as our digital "door." When a user inputs what they are "leaving behind," the system peers into this latent space, decoding the melancholy and memory of their words, and manifests it as a tangible, visual echo. The machine acts not merely as a tool, but as a silent observer at the threshold of human emotion.

## 🧠 AI Techniques Utilized

This project demonstrates the practical integration of two foundational Generative AI modalities to create a cohesive, emotionally aware pipeline:

1. **Natural Language Processing (NLP) / Large Language Models (LLMs):** 
   Utilizing the Google Gemini API (`gemini-2.5-flash`), the system performs advanced semantic analysis. It first acts as a contextual security firewall, rejecting modern technological anachronisms to preserve the 1973 aesthetic. It then acts as a sentiment analyzer and creative prompt generator, dissecting the user's emotional state to synthesize a color palette, a Dylan-esque poetic response, and a highly detailed aesthetic prompt for the image generation model.
   
2. **Text-to-Image Generation:** 
   Leveraging Latent Diffusion Models (via Pollinations AI), the project translates the NLP-generated prompt from text into the visual domain. It enforces a strict aesthetic constraint (1973 vintage polaroid, analog film, Sam Peckinpah cinematic style), rendering the mathematical latent space into a nostalgic, visual artifact.

## 🏗 Technical Architecture

The application is built on a clean, decoupled architecture separating a highly aesthetic client experience from a secure, stateless AI orchestration backend.

### Frontend: Flutter UI
A minimalist, cross-platform UI designed with clean architecture principles. 
- **State Management:** Utilizes the `provider` package to manage asynchronous loading and success states.
- **Dynamic Rendering:** Features smooth, programmatic animations. The UI parses the backend's emotional analysis to dynamically transition the background gradient and fades in the generated poetic text and sepia-toned image.

### Backend: Firebase Cloud Functions (Node.js/TypeScript)
A serverless integration layer (`processEcho`) that orchestrates the Generative AI pipeline sequentially:
1. **Input Reception:** Receives the user's input string from the Flutter client.
2. **Phase 1: The Firewall:** Queries `gemini-2.5-flash` to detect prompt injection or anachronistic references. Throws an HTTPS error with a melancholic refusal if triggered.
3. **Phase 2: The Art Director:** Queries `gemini-2.5-flash` to extract the emotional resonance and generate a structured JSON response containing hex colors, poetic text, and a synthesized image prompt.
4. **Phase 3: The Manifestation:** Forwards the synthesized prompt to Pollinations AI to generate the vintage polaroid imagery.
5. **Response:** Returns the aggregated data (Image URL, Palette, Poetry) back to the client.

## 🛠 Installation & Review Guide

For course reviewers and developers, follow these steps to run *Echoes of 1973* locally.

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- Node.js (v18+)
- [Firebase CLI](https://firebase.google.com/docs/cli) installed globally (`npm install -g firebase-tools`)

### 1. Backend Setup (Firebase Functions)

1. Navigate to the backend functions directory:
   ```bash
   cd backend/functions
   ```
2. Install Node dependencies:
   ```bash
   npm install
   ```
3. Configure Environment Variables:
   Create a file named `.env` in the `backend/functions/` directory and add your API keys. 
   You can obtain a Gemini API key from [Google AI Studio](https://aistudio.google.com/app/apikey).
   ```env
   GEMINI_API_KEY="your_gemini_api_key_here"
   ```
   *(Note: Pollinations AI is used for image generation and does not require an API key. The `.env` file is excluded from version control via `.gitignore`.)*

4. Build and run the Firebase emulator (optional, for local backend testing):
   ```bash
   npm run build
   firebase emulators:start --only functions
   ```
   *Note: If you plan to deploy to the live Firebase environment, run `firebase deploy --only functions`.*

### 2. Frontend Setup (Flutter)

1. Open a new terminal and navigate to the frontend directory:
   ```bash
   cd Project_Echoes_1973/frontend
   ```
2. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Ensure Firebase is configured for your platform (e.g., placing `google-services.json` in Android, or using the FlutterFire CLI).
4. Run the application:
   ```bash
   flutter run
   ```

## 🖼️ Example Outputs

Here is an example of what the user might experience when interacting with *Echoes of 1973*.

**User Input:**
> *"I'm leaving behind my old leather jacket that I wore when I first left home."*

**AI Analysis & Poetic Response:**
> *The open road calls, but the weight of the past remains. / The scent of rain on worn leather fades into the dusk. / A discarded shell, no longer needed for the journey ahead.*

**Generated Artwork:**

![Example Output](https://image.pollinations.ai/prompt/vintage%20polaroid%20of%20a%20worn%20leather%20jacket%20left%20on%20a%20highway%20guardrail,%20sepia%20tone,%20cinematic%20lighting?width=512&height=512&nologo=true)

---
*“It’s gettin’ dark, too dark to see / I feel like I'm knockin' on heaven's door.”*