#!/bin/bash
# This script will initialize all the settings for the .ini file and add
# this directory to the user path variable.
ask() {
    # https://gist.github.com/davejamesmiller/1965569
    local prompt default reply

    if [ "${2:-}" = "Y" ]; then
        prompt="Y/n"
        default=Y
    elif [ "${2:-}" = "N" ]; then
        prompt="y/N"
        default=N
    else
        prompt="y/n"
        default=
    fi

    while true; do

        # Ask the question (not using "read -p" as it uses stderr not stdout)
        echo -n "$1 [$prompt] "

        # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
        read reply </dev/tty

        # Default?
        if [ -z "$reply" ]; then
            reply=$default
        fi

        # Check if the reply is valid
        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

echo "Setting up fdtd-slurm-batch"
echo "Your home directory is $HOME"
SCRIPTDIR=`dirname $(readlink -f $(which --skip-alias $0))`
echo "Current directory is $SCRIPTDIR"

if ask "Would you like to add this dir to the path variable?"; then
    echo "Adding this directory to the path variable in .bashrc"
    path='$PATH'
    echo "export PATH=$SCRIPTDIR:$path" >> $HOME/.bashrc
fi

if ask "Would you like to reset the user settings to default values? (yes for first run)"; then
    rm "./user_settings.ini"
    cp "./templates/default_settings.ini" "./user_settings.ini"
fi

if ask "Would you like to modify the user settings?"; then
    . ./templates/default_settings.ini
   
    read -p "How many simulation engines do you want to run at one time? (default $NUM_ENGINES)" num_engines
    if ! [ -z "$num_engines" ]
    then
	NUM_ENGINES=$num_engines
    fi
    echo "Number of engines: $NUM_ENGINES"

    read -p "What job name would you like? (default $JOB_NAME) " job_name
    if ! [ -z "$job_name" ]
    then
	JOB_NAME=$job_name
    fi
    echo "Job name: $JOB_NAME"
    
    while true; do
	read -p "What time limit would you like on your simulations in HH:MM:SS (default $TIME_LIMIT)? " time_limit
	if [[ ${#time_limit}==0 ]]; then
	    time_limit=$TIME_LIMIT
	fi
	if ask "Are you sure you want the time limit to be $time_limit? "; then
	    TIME_LIMIT=$time_limit
	    break
	fi
    done
    echo "Time limit: $TIME_LIMIT"

    while true; do
	read -p "How much memory would you like to have per CPU? (default $MEMORY_PER_CPU) " mem_per_cpu
	if [[ ${#mem_per_cpu}==0 ]]; then
	    mem_per_cpu=$MEMORY_PER_CPU
	fi
	if ask "Are you sure you want $mem_per_cpu per CPU? "; then
	   MEMORY_PER_CPU=$mem_per_cpu
	   break
	fi
    done
    echo "Memory per cpu: $MEMORY_PER_CPU"

    if ask "Would you like to receive emails from Slurm about your simulations? "; then
	while true; do
	    read -p "What is your email address? " email
	    if ask "Is $email correct?"; then
		EMAIL=$email
		break
	    fi
	done

	mail_type="ARRAY_TASKS"

	while true; do
	    if ask "Would you like to receive emails at the start of simulations?"; then
		mail_type="$mail_type,BEGIN"
	    fi

	    if ask "Would you like to receive emails at the end of simulations?"; then
		mail_type="$mail_type,END"
	    fi

	    if ask "Would you like to receive emails when simulations fail?"; then
		mail_type="$mail_type,FAIL"
	    fi

	    if ask "Would you like to receive emails when simulations reach the time limit?"; then
		mail_type="$mail_type,TIME_LIMIT"
	    fi

	    if ask "Would you like to receive emails when simulations reach half the time limit?"; then
		mail_type="$mail_type,TIME_LIMIT_50"
	    fi

	    if ask "Would you like to receive emails when simulations reach 80 percent of the time limit?"; then
		mail_type="$mail_type,TIME_LIMIT_80"
	    fi

	    if ask "Are you happy with the following email settings?\n $mail_type>"; then
		MAIL_TYPE=$mail_type
		break
	    fi
	done
    else
	MAIL_TYPE="NONE"
    fi
    
    sed -e "s#<email>#$EMAIL#g" \
	-e "s#<mail_type>#$MAIL_TYPE#g" \
	-e "s#<num_engines>#$NUM_ENGINES#g" \
	-e "s#<job_name>#$JOB_NAME#g" \
	-e "s#<time_limit>#$TIME_LIMIT#g" \
	-e "s#<mem>#$MEMORY_PER_CPU#g" \
	$SCRIPTDIR/templates/settings_template.ini > $SCRIPTDIR/user_settings.ini
fi

echo 'Then please log out and back in again to complete the installation.'
echo 'fdtd-slurm-batch setup completed.'
