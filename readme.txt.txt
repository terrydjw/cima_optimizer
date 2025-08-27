CIMA Optimizer - Project README
1. Project Overview
CIMA Optimizer is a comprehensive, cross-platform mobile application designed to provide an intelligent and efficient study experience for CIMA (Chartered Institute of Management Accountants) students. The project began with the goal of optimizing revision for the BA4 (Fundamentals of Ethics, Corporate Governance and Business Law) module and has been architected to be fully scalable to include all other CIMA papers.

The core philosophy of the app is to move beyond static, passive learning from textbooks and question banks. Instead, it creates a dynamic feedback loop: Learn -> Test -> Analyze & Improve. It leverages a cloud-based backend, persistent user profiles, and an integrated AI tutor to provide a personalized and adaptive learning path for each user.

2. Core Features Implemented
Our development journey has resulted in a feature-rich Minimum Viable Product (MVP) with the following key functionalities:

Knowledge Hub: A content section containing concise, exam-focused lessons for each key topic of the syllabus. The content is structured by syllabus area (A, B, C) for targeted learning.

Dynamic Practice Engine:

Topic-Specific Quizzes: Users can choose to practice questions from a specific syllabus area or from the entire syllabus.

Custom Question Count: Users can select a preset number of questions or enter a custom amount for their quiz session.

In-Quiz Tools: A pop-up calculator and a scratchpad are available during quizzes to simulate exam conditions.

AI-Powered Tutor (Gemini API Integration): After answering a question, users can tap an "Explain this to me" button. The app sends the question and answer to the Gemini API, which provides a clear, concise explanation of the underlying concept, offering instant, on-demand tutoring.

Persistent User Profiles & Progress Tracking:

Firebase Authentication: Secure user sign-up and login using email and password.

Cloud-Based Progress: All user progress (questions answered, topic performance) is saved to a Firestore database, ensuring it persists between sessions and across devices.

Adaptive Learning Dashboard: The main dashboard provides at-a-glance insights into the user's progress:

Syllabus Breakdown: Visual progress bars show the user's performance percentage for each individual syllabus area (A, B, C).

Recent Activity: A feed displays the results of the last three quiz sessions.

Intelligent Recommendation: The app analyzes the user's performance and dynamically suggests the "weakest topic" for them to review next.

Polished User Experience:

Custom Theme: A professional, modern UI with both Light and Dark modes.

Persistent Theme Settings: The user's theme choice is saved locally on their device.

Animations: Subtle animations on the dashboard and navigation transitions provide a smooth and responsive feel.

3. Technology Stack
The application is built using a modern, scalable tech stack:

Frontend: Flutter & Dart

Backend & Database: Google Firebase (Authentication & Cloud Firestore)

AI Tutor: Google Gemini API

State Management: Provider

Local Storage: shared_preferences (for theme settings)

Build Environment: Visual Studio with C++ toolchain (for Windows), Android Studio/SDK

4. Project Journey & Key Milestones
Initial Concept: The project began as a conversation to create an optimized revision strategy for the CIMA BA4 exam.

Data Analysis: We analyzed the official syllabus and sample questions to establish data-driven weightings for each topic area.

App Blueprint: We designed the MVP around a "Learn, Test, Analyze" loop, creating the initial UI for the Knowledge Hub, Practice Engine, and Dashboard.

State Management: We integrated the provider package to manage the app's state, starting with the quiz logic.

Backend Integration: We created a Firebase project and integrated Firebase Authentication for user accounts and Cloud Firestore for a cloud-based content system.

Content Automation: We moved from hardcoded Dart content to local JSON files and then created a Node.js script to automate the process of uploading this content to Firestore, making the app's content library fully scalable.

Feature Expansion: We added key features like topic-specific quizzes, a custom question count, in-quiz tools (calculator/notepad), and a detailed user profile screen.

AI Integration: We integrated the Gemini API to create the AI Tutor feature, providing on-demand explanations.

UI Polish: We refined the user experience by adding a custom theme with persistent light/dark modes and animations.

Troubleshooting: We systematically diagnosed and resolved numerous complex build environment issues related to the Flutter SDK, Java JDK, and the native Windows C++ toolchain, resulting in a stable and reliable project.