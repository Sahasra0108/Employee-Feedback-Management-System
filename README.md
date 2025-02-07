# Employee Feedback Management System

## 📌 Overview
The **Employee Feedback Management System** is a web application that allows employees to submit feedback about their team leads. It enables submission, and management of feedback within an organization.

## 🚀 Features
- Submit feedback with ratings
- View all feedback records
- Role-based access control
- User authentication and authorization
- Responsive UI with Material-UI

## 🛠️ Tech Stack
### Frontend:
- React.js (Vite)
- Material-UI
 

### Backend:
- Ballerina
### Database:
- MySQL

## ⚙️ Installation
### Clone the repository
 ```bash
git clone https://github.com/Sahasra0108/Employee-Feedback-Management-System.git
   ```
2.Navigate to the project directory
```bash
cd Employee-Feedback-Management-System
```

### Backend Setup
1. Install [Ballerina](https://ballerina.io/downloads/)
2. Configure MySQL database:
   - Create a database named `teamlead_feedback`
3. Update database credentials in `feedback.bal`:
   ```ballerina
   mysql:Client feedback = check new ("localhost",
       user = "root",
       password = "YOUR_PASSWORD",
       database = "teamlead_feedback",
       port = 3306
   );
   ```
 4. Run the backend service:
   ```bash
   bal run feedback.bal
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd front_end
   ```
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the development server:
   ```bash
   npm run dev
   ```

   ## 🔗 API Endpoints
| Method | Endpoint        | Description |
|--------|----------------|-------------|
| GET    | `/feedbacks`    | Retrieve all feedback records |
| GET    | `/teamLeads`    | Get a list of team leads |
| POST   | `/submitFeedback` | Submit new feedback |
 
