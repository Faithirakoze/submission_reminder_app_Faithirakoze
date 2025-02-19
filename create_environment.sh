#!/bin/bash

# This script set up the environment
# for the reminder app to run

# Create the directory
read -p "Enter your name:  " username
mkdir submission_reminder_"$username"
echo "Project root directory created successfully"

main_dir=submission_reminder_"$username"

# create subdirectories
mkdir "$main_dir"/app
mkdir "$main_dir"/modules
mkdir "$main_dir"/assets
mkdir "$main_dir"/config
echo "Project subdirectories created successfully"

# create the project files
touch "$main_dir"/app/reminder.sh
touch "$main_dir"/modules/functions.sh
touch "$main_dir"/assets/submissions.txt
touch "$main_dir"/config/config.env
touch "$main_dir"/startup.sh

# Create the scripts for the environment

cat > "$main_dir"/startup.sh << 'EOF'
#!/bin/bash
# This script runs the reminder app
bash app/reminder.sh
EOF

# Create the reminder.sh

cat > "$main_dir"/app/reminder.sh << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
echo "reminder.sh file created succesfully"

cat > "$main_dir"/config/config.env << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
echo "config.env file created succesfully"

# Create the functions.sh file

cat > "$main_dir"/modules/functions.sh << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

# Create the submissions.txt

cat > "$main_dir"/assets/submissions.txt << 'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Faith, Filesystems, not submitted
Bode, Shell Navigation, not submitted
Tifare, Processes, not submitted
Maurice, Shell Navigation, not submitted
Louis, Shell Navigation, not submitted

EOF
echo "submissions.txt file created successfully"

# Make the files executable
chmod a+x "$main_dir"/startup.sh
chmod a+x "$main_dir"/app/reminder.sh
chmod a+x "$main_dir"/modules/functions.sh

echo "functions.sh file created successfully"
echo "Environment created successfully"
echo "Change to $main_dir directory and"
echo "Use bash create_environment.sh or ./create_environment.sh to create your app environment"
echo "Environment created by Faith Irakoze"