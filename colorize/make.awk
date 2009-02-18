# mske.awk
#
# This is an nawk script used to colorize the output from gnu make.   Simply
# pipe the output from make into the nawk (or gawk) program with this
# file as the awk script.
#
# Examples:
#    make 2>&1 | nawk -f make.awk
#
# Functions:
#    cmake () { make $* 2>&1 | nawk -f make.awk; }
# -----------------------------------------------------------------------------

BEGIN {

# Define the colors in our color pallete
# --------------------------------------
    normal       = "\033[0m"
    boldon       = "\033[1m"
    italicson    = "\033[3m"
    underlineon  = "\033[4m"
    inverseon    = "\033[7m"
    strikethon   = "\033[9m"
    boldoff      = "\033[22m"
    italicsoff   = "\033[23m"
    underlineoff = "\033[24m"
    inverseoff   = "\033[27m"
    strikethoff  = "\033[29m"
    fgblack      = "\033[30m"
    fgred        = "\033[31m"
    fggreen      = "\033[32m"
    fgyellow     = "\033[33m"
    fgblue       = "\033[34m"
    fgmagenta    = "\033[35m"
    fgcyan       = "\033[36m"
    fgwhite      = "\033[37m"
    fgdefault    = "\033[39m"
    bgblack      = "\033[40m"
    bgred        = "\033[41m"
    bggreen      = "\033[42m"
    bgyellow     = "\033[43m"
    bgblue       = "\033[44m"
    bgmagenta    = "\033[45m"
    bgcyan       = "\033[46m"
    bgwhite      = "\033[47m"
    bgdefault    = "\033[49m"
}


# Errors reported by the make system
/^make(\[[0-9]+\])?: \*\*\*/ {
    print boldon fgwhite bgred $0 normal
    next
}

# Normal make info lines
/^make/ { print boldon fgblue $0 normal; next }

# Comments generated by the make system
/^(==>>|\*\*\*\*)/ { print boldon fgcyan $0 normal; next }

# Warnings generated by the compiler (file must end in .h .hpp .c .cpp)
/^[0-9A-Za-z_/]+\.(hpp|h|cpp|c):([0-9]+:)* warning/ {
    print boldon fgred $0 normal
#    lappend ofInterest "${make_warning}${s}${normal}"
    next
}

         # Compiler generated alerts (file must end in .h .hpp .c .cpp)
#         } elseif {[regexp {^[0-9A-Za-z_/]+\.(hpp|h|cpp|c):} $s] ||
#                   [regexp {^In file included from} $s]          ||
#       	    [regexp {^                 from} $s]} {
#            puts "${make_alert}${s}${normal}"
#            lappend ofInterest "${make_alert}${s}${normal}"

{
    if (match( $0, /^[0-9A-Za-z_/]+\.(hpp|h|cpp|c):([0-9]+:)* error/ ) ||
        match( $0, /^In file included from/ ) ||
        match( $0, /^                 from/ )    ) {

        print boldon fgyellow $0 normal
#            lappend ofInterest "${make_alert}${s}${normal}"
        next
    }
}


# Everything else is white text on a black background
# except for compiler lines; we are grabbing the filename from
# compiler lines and coloring the filename
{
    if (match( $0, / [0-9A-z]+\.(hpp|h|cpp|c)/ ) > 0) {
        filename = sprintf( "%s%s%s%s",
                boldon, fgmagenta, substr( $0, RSTART+1, RLENGTH-1 ), normal )
        sub( /[0-9A-z]+\.(hpp|h|cpp|c)/, filename, $0 )
    }

    print $0
}

