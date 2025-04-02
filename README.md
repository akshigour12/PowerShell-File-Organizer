# 🗂 PowerShell File Organizer  

This script automatically **organizes files** in a selected folder by their extensions. It moves files into subfolders named after their file types (e.g., `.pdf`, `.jpg`, `.docx`).  

🔒 **Access Control:** The script ensures that only an authorized user can execute it.  

---

## 🚀 Features  
✅ **Restricts execution to the logged-in user**  
✅ **Prompts user to select a source and destination folder**  
✅ **Creates subfolders based on file extensions**  
✅ **Efficiently moves files to their respective folders**  
✅ **Fast execution with minimal prompts**  

---

## 📥 Installation & Usage  

### **1️⃣ Prerequisites**  
- Windows OS  
- PowerShell (`>= 5.1` recommended)  

### **2️⃣ Allow PowerShell Script Execution (If Needed)**  
If you see an error like _"execution of scripts is disabled on this system"_, enable script execution by running:  
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

🚀 Running the Script
1️⃣ Download the Script
Download or clone this repository to your local machine.

Ensure the script file File_Organizer.ps1 is in a known directory.

2️⃣ Open PowerShell
Press Win + X, then select PowerShell (Admin) to run as administrator.

3️⃣ Navigate to the Script Location
Run the following command, replacing the path with the actual location of the script:
cd "C:\path\to\your\script"

4️⃣ Execute the Script
Run the script using:
.\File_Organizer.ps1

🛠 Troubleshooting
1️⃣ "Access Denied" Error?
Run PowerShell as Administrator.

2️⃣ "No valid folder selected" Error?
Make sure you select a proper folder when prompted.

3️⃣ "Script execution is disabled" Error?
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

🤝 Contributing
Feel free to modify or improve this script! Fork the repository and submit a pull request.
