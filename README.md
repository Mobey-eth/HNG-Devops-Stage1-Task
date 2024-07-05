# HNG DevOps Stage 1 Task: User Management Script

This repository contains a Bash script (`create_users.sh`) designed to automate the process of creating users and managing their group memberships on a Linux system.  

## Script Functionality

- Reads user information from a text file (provided as an argument).
- Creates user accounts with their home directories and default shells.
- Generates strong random passwords for each new user.
- Assigns users to specified groups (creating groups if they don't exist).
- Logs all actions taken by the script for auditing and troubleshooting.
- Stores generated passwords securely in a restricted-access file.

## Requirements

- A Linux-based operating system (tested on Ubuntu).
- `sudo` privileges to create users and groups.

## Usage

1. **Clone this repository:**
```bash
    git clone https://github.com/Mobey-eth/HNG-Devops-Stage1-Task.git
```
2. **Create an input text file:**
Each line in the file should follow this format: 
`username;group1,group2,...`
Example:
```
    john;sudo,developers
    jane;marketing,sales
```

3. **Make the script executable:**
```bash
    chmod +x create_users.sh
```

4. **Run the script with the input file as an argument:**

```bash
    sudo ./create_users.sh <text_file.txt>
```
Replace <text_file.txt> with the actual name of your input file.

## Verification

After running the script, verify the results:
Log File: Check `/var/log/user_management.log` for a detailed record of actions taken.
Password File: Ensure the password file exists at `/var/secure/user_passwords.csv` and contains the generated usernames and passwords.

## Contributing
Feel free to open issues or submit pull requests to contribute improvements or report any bugs.

This project was completed as part of the HNG DevOps Stage 1 task.