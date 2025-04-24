if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting
starship init fish | source

# Load environment variables and PATH
if test -f ~/.linux_paths
    for line in (cat ~/.linux_paths)
        # Add directories to PATH
        if string match -q "export PATH=" -- $line
            set dir (string replace "export PATH=" "" -- $line)
            set -x PATH $dir $PATH
            # Set environment variables
        else if string match -q "export " -- $line
            set var_value (string split "=" -- $line)
            set -x (string trim -c ' ' $var_value[1]) $var_value[2]
        end
    end
end

# Load Abbrs and Aliases
function import_bash_aliases --description 'bash aliases to fish abbr'
    for a in (cat ~/.linux_abbrs | grep "^alias")
        set aname (echo $a | sed "s/alias \(.*\)='\(.*\)'/\1/")
        set command (echo $a | sed "s/alias \(.*\)='\(.*\)'/\2/")
        abbr -a $aname $command
    end
end
import_bash_aliases
