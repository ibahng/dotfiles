$hash_calc_ignore_pattern{'pytxcode'} = '^=>PYTHONTEX#|id=';
add_cus_dep('pytxcode', 'tex', 0, 'pythontex');
sub pythontex {
    return system("pythontex \"$_[0]\"");
}