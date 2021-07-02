macro cdecl proc, [arg]
{
    common
        size@cdecl = 0
    if ~ arg eq
    reverse
        push word arg
        size@cdecl = size@cdecl + 2
    common
    end if
        call proc
        if size@cdecl
            add sp, size@cdecl
        end if
}
