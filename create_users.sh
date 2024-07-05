#!/bin/bash

# Log file
LOG_FILE="/var/log/user_management.log"
# Password file
PASSWORD_FILE="/var/secure/user_passwords.csv"

# Ensure secure directory exists
mkdir -p /var/secure
chmod 700 /var/secure

# Log function
log_action() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> $LOG_FILE
}

# Function to generate random password
generate_password() {
    tr -dc A-Za-z0-9 </dev/urandom | head -c 12
}

# Check if the input file is provided
if [ $# -ne 1 ]; then
    echo "Missing Argument : <name-of-text-file>, Only One Argument is required."
    exit 1
fi

INPUT_FILE="$1"

# Ensure the log and password files exist
touch $LOG_FILE
touch $PASSWORD_FILE
chmod 600 $PASSWORD_FILE

# Read the input file line by line
while IFS=';' read -r username groups; do
    # Trim leading/trailing whitespace
    username=$(echo "$username" | xargs)
    groups=$(echo "$groups" | xargs)

    # Check if the username is empty
    if [ -z "$username" ]; then
        continue
    fi

    # Create the user's personal group
    if ! getent group "$username" > /dev/null; then
        groupadd "$username"
        log_action "Created group $username"
    fi

    # Create the user with the user's personal group
    if ! id -u "$username" > /dev/null 2>&1; then
        useradd -m -g "$username" -s /bin/bash "$username"
        log_action "Created user $username with group $username"
    else
        log_action "User $username already exists"
    fi

    # Set up home directory permissions
    chmod 700 /home/$username
    chown $username:$username /home/$username

    # Assign the user to additional groups
    if [ -n "$groups" ]; then
        IFS=',' read -ra GROUP_ARRAY <<< "$groups"
        for group in "${GROUP_ARRAY[@]}"; do
            group=$(echo "$group" | xargs)
            if ! getent group "$group" > /dev/null; then
                groupadd "$group"
                log_action "Created group $group"
            fi
            usermod -aG "$group" "$username"
            log_action "Added user $username to group $group"
        done
    fi

    # Generate random password and set it
    password=$(generate_password)
    echo "$username:$password" | chpasswd
    log_action "Set password for user $username"

    # Store the username and password securely
    echo "$username,$password" >> $PASSWORD_FILE

done < "$INPUT_FILE"

echo "User creation process completed. Check $LOG_FILE for details."
