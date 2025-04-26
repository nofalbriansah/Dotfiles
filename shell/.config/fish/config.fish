if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting
starship init fish | source

# Load environment variables and PATH
if test -f ~/.linux_paths
    for line in (cat ~/.linux_paths)
        set line (string trim $line)
        # Skip empty or comment lines
        if test -z "$line"
            continue
        end
        if string match -q "#*" -- $line
            continue
        end

        # Handle PATH additions
        if string match -q "export PATH=" -- $line
            set dir (string replace "export PATH=" "" -- $line)
            set dir (string replace "~" $HOME -- $dir)
            set dir (string replace ":$PATH" "" -- $dir)
            for d in (string split ":" $dir)
                if test -d $d
                    if not contains $d $PATH
                        set -gx PATH $d $PATH
                    end
                end
            end

        # Handle other environment variables
        else if string match -q "export " -- $line
            set var_assignment (string replace "export " "" -- $line)
            set var_name (string split "=" -- $var_assignment)[1]
            set var_value (string split "=" -- $var_assignment)[2..-1]
            set var_value (string join "=" $var_value)
            set var_value (string replace "~" $HOME -- $var_value)
            set -gx $var_name $var_value
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