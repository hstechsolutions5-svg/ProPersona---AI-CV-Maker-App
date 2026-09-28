# ProPersona — The ATS Friendly CV Maker

<p align="center">
  <strong>Build smarter resumes. Improve ATS compatibility. Present your professional story with confidence.</strong>
</p>

<p align="center">
  A cross-platform AI-powered career development application by
  <strong>Huzentra Technologies</strong>.
</p>

---

## 📌 Project Status

> 🚧 **ProPersona is currently under active development.**

The project has completed its initial **Architecture & Foundation Phase (Phase 0)**.

Current development is moving toward:

**Phase 1 — Authentication & Onboarding**

The application is **not production-ready yet**.

---

## 📖 About ProPersona

**ProPersona** is an AI-powered career development platform designed to help fresh graduates and professionals create, optimize, analyze, and manage professional resumes and career documents.

The application is being developed with a strong focus on:

- ATS-friendly resume creation
- Structured career information
- AI-assisted resume optimization
- Job-description matching
- Professional PDF generation
- Responsive cross-platform experiences
- Secure user-specific data
- Scalable architecture

ProPersona is designed as a **Flutter-based cross-platform application** targeting:

- Android
- iOS
- Web
- Windows
- macOS

---

## 🎯 Product Vision

ProPersona aims to make professional resume creation more intelligent and accessible by combining structured resume building with AI-assisted career tools.

Instead of treating a resume as only a PDF document, ProPersona stores resume information as structured data that can later be:

- Edited
- Optimized
- Analyzed
- Reused
- Converted into different resume templates
- Matched against job descriptions
- Exported as professional PDFs

---

## ✨ Planned Core Features

### 📝 Intelligent Resume Builder

Users will be able to create structured resumes containing:

- Personal Information
- Professional Summary
- Education
- Work Experience
- Skills
- Projects
- Certifications
- Languages
- Custom Sections

Resume content will remain independent from visual templates, allowing users to switch designs without recreating their information.

---

### 🤖 AI Resume Optimization

AI-assisted tools are planned for improving resume content, including:

- Resume summary generation
- Bullet point rewriting
- Action verb improvements
- Achievement-focused writing
- Keyword suggestions
- Skills recommendations
- Resume content optimization

AI operations will be handled through a protected backend layer rather than exposing AI provider credentials inside the Flutter application.

---

### 📊 ATS Analyzer

Users will eventually be able to compare a resume against a target job description.

The ATS analysis system is planned to provide information such as:

- Overall ATS Match Score
- Keyword Match Score
- Skills Match
- Experience Relevance
- Missing Keywords
- Matched Keywords
- Strengths
- Improvement Recommendations

---

### ✉️ Cover Letter Generator

ProPersona will provide AI-assisted cover letter generation based on:

- Resume information
- Target role
- Company
- Job description
- Professional experience

---

### 🪄 Bullet Point Polish

Resume bullet points will be improved using achievement-oriented writing principles, including the **XYZ approach**:

> Accomplished **X**, as measured by **Y**, by doing **Z**.

---

### 📄 PDF Resume Export

Resume data will be converted into professional ATS-friendly PDF templates.

The planned export pipeline is:

```text
Resume Data
    ↓
Resume Template
    ↓
PDF Layout Engine
    ↓
Generated PDF
    ↓
Preview / Save / Share / Print
