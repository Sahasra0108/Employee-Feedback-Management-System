# Employee-Feedback-Management-System-Backend
## 📌 Project Overview
This is the backend of the application built using **Ballerina**.

## 🔧 Installation & Setup

### Prerequisites
**[Ballerina](https://ballerina.io/downloads/)** (latest version)
- **MySQL** (or any compatible database)

1.Clone the repository
 ```bash
git clone https://github.com/Sahasra0108/Employee-Feedback-Management-System.git
   ```
2.Navigate to the project directory
```bash
cd Employee-Feedback-Management-System/back_end
```
3.Update the **database connection settings**.
```ballerina
mysql:Client feedback = check new ("localhost",
    user = "your-username",
    password = "your-password",
    database = "teamlead_feedback",
    port = 3306
);
```
4.Build and run the Ballerina service
```bash
bal build
bal run
```
 

 
